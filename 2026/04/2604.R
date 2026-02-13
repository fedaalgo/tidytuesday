# --- tidytuesday::2604 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-01-27/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.5", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  patchwork, # https://cran.r-project.org/web/packages/patchwork/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  styler, # https://cran.r-project.org/web/packages/styler/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
dfa <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-01-27/companies.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-01-27/legal_nature.csv'
  ) |>
  clean_names()

dfc <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-01-27/qualifications.csv'
  ) |>
  clean_names()

dfd <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-01-27/size.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-01-27/readme.md

# understand ----

# names
dfa |> 
  slice() |> 
  glimpse()

# glimpse & skim
dfa |>
  glimpse() |>
  skim()

# ...

# which **legal nature** categories concentrate the highest total and average capital stock?

## total
dfa |> 
  group_by(legal_nature) |> 
  summarise(n = sum(capital_stock)) |> 
  arrange(desc(n)) |> 
  print(n = Inf)
## average
dfa |> 
  group_by(legal_nature) |> 
  summarise(avg = mean(capital_stock)) |> 
  arrange(desc(avg)) |> 
  print(n = Inf)

# how does company size relate to capital stock (and how skewed is it)?

dfa |>
  filter(capital_stock < 100000000000) |> 
  group_by(company_size) |>
  summarise(
    n = n(),
    mean_capital = mean(capital_stock, na.rm = TRUE),
    median_capital = median(capital_stock, na.rm = TRUE),
    sd_capital = sd(capital_stock, na.rm = TRUE),
    min_capital = min(capital_stock, na.rm = TRUE),
    max_capital = max(capital_stock, na.rm = TRUE),
    skewness = mean(((capital_stock - mean(capital_stock, na.rm = TRUE)) /
                       sd(capital_stock, na.rm = TRUE)
    )^3, na.rm = TRUE) # https://doi.org/10.1111/1467-9884.00122
  )

# Company size shows a modest relationship with capital stock, with "other"
# companies (likely medium/large firms) having a median capital stock of
# approximately 1.03 million BRL—roughly 3 times higher than micro-enterprises
# (300k BRL) and small enterprises (350k BRL). However, all three categories
# exhibit extreme right-skewness (Joanes & Gill, 1998), with moment coefficients
# ranging from 33.7 (small enterprises) to 98.7 (micro-enterprises). This
# skewness reflects substantial within-category inequality: while most companies
# across all size classifications maintain relatively modest capital stocks near
# their respective medians, a small number of high-capital outliers dramatically
# inflate the group means. For instance, micro-enterprises show a mean capital
# stock of 6.6 million BRL despite a median of just 300k BRL—a 22-fold
# difference driven by outliers reaching up to 40 billion BRL. The pattern
# suggests that company size classification in this registry is not primarily
# determined by capital stock, as considerable capital heterogeneity exists
# within each category.
#
# Joanes, D. N., & Gill, C. A. (1998). Comparing measures of sample skewness and
# kurtosis. Journal of the Royal Statistical Society: Series D (The
# Statistician), 47(1), 183-189. https://doi.org/10.1111/1467-9884.00122

# do specific owner qualification groups dominate high-capital companies?

dfa |>
  filter(capital_stock < 100000000000) |>
  mutate(capital_category = ifelse(
    capital_stock >= quantile(capital_stock, 0.90, na.rm = TRUE), 
    "High Capital", 
    "Normal Capital"
  )) |>
  group_by(capital_category, owner_qualification) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(capital_category) |>
  mutate(pct = 100 * n / sum(n)) |>
  arrange(capital_category, desc(pct))

dfa |>
  filter(capital_stock < 100000000000) |>
  mutate(capital_category = ifelse(
    capital_stock >= quantile(capital_stock, 0.90, na.rm = TRUE), 
    "High Capital", 
    "Normal Capital"
  )) |>
  group_by(capital_category, owner_qualification) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(capital_category) |>
  mutate(pct = 100 * n / sum(n)) |>
  select(-n) |>
  tidyr::pivot_wider(names_from = capital_category, values_from = pct) |>
  arrange(desc(`High Capital`))

# High-capital companies (top 10% by capital stock) exhibit a markedly different
# ownership structure compared to normal-capital firms. While Managing Partners
# and Partner-Administrators dominate both segments, they are substantially less
# prevalent among high-capital companies (48.1%) than normal-capital ones
# (78.8%). This difference is offset by a dramatic overrepresentation of
# professional management roles in high-capital firms: Administrators and
# Managers account for 30.5% of high-capital companies compared to just 8.6% of
# normal-capital firms—a nearly fourfold increase. Similarly, formal corporate
# governance roles such as Directors/Officers (6.85% vs. 0.52%) and
# Presidents/Chairs (4.06% vs. 0.61%) are roughly 10-13 times more common in
# high-capital companies. Entrepreneurs and Business Owners show similar
# representation across both groups (~9-11%). This pattern suggests that
# high-capital companies are characterized by more formalized, hierarchical
# governance structures with separated ownership and management, whereas
# normal-capital firms rely predominantly on owner-managed partnership models.
# The shift from partner-administrators to professional administrators and
# executive officers appears to be a defining feature of capital concentration
# in this registry.

# what patterns emerge when comparing the top capital-stock tail across categories (legal nature, size, qualification)?

# by legal nature
dfa |>
  filter(capital_stock < 100000000000) |>
  mutate(in_tail = capital_stock >= quantile(capital_stock, 0.99, na.rm = TRUE)) |>
  group_by(in_tail, legal_nature) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(in_tail) |>
  mutate(pct = 100 * n / sum(n)) |>
  tidyr::pivot_wider(names_from = in_tail, values_from = pct, values_fill = 0) |>
  rename(Tail = `TRUE`, Normal = `FALSE`)

# by company size
dfa |>
  filter(capital_stock < 100000000000) |>
  mutate(in_tail = capital_stock >= quantile(capital_stock, 0.99, na.rm = TRUE)) |>
  group_by(in_tail, company_size) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(in_tail) |>
  mutate(pct = 100 * n / sum(n)) |>
  tidyr::pivot_wider(names_from = in_tail, values_from = pct, values_fill = 0) |>
  rename(Tail = `TRUE`, Normal = `FALSE`)

# by owner qualification
dfa |>
  filter(capital_stock < 100000000000) |>
  mutate(in_tail = capital_stock >= quantile(capital_stock, 0.99, na.rm = TRUE)) |>
  group_by(in_tail, owner_qualification) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(in_tail) |>
  mutate(pct = 100 * n / sum(n)) |>
  tidyr::pivot_wider(names_from = in_tail, values_from = pct, values_fill = 0) |>
  rename(Tail = `TRUE`, Normal = `FALSE`) |>
  arrange(desc(Tail))

# The top 1% capital stock tail reveals a systematic shift in company
# characteristics, though patterns vary by dimension. Legal nature provides no
# discriminatory power, as both the tail and the general population are
# dominated by Limited Liability Companies (~85-100%). However, company size
# shows a dramatic reversal: while micro-enterprises constitute 47% of
# normal-capital firms, they represent only 20% of the top tail, with "other"
# (medium/large) companies doubling their representation from 30% to 46%. The
# most striking transformation occurs in ownership qualification structure.
# Managing Partners, who account for 76% of normal companies, drop to just 44%
# in the tail—still the plurality but substantially diminished. This decline is
# offset by sharp increases in formalized executive roles: Directors/Officers
# increase thirteenfold (1.0% → 13.9%), Presidents/Chairs increase eightfold
# (0.9% → 7.3%), and professional Administrators/Managers nearly double their
# share (10.7% → 16.9%). Entrepreneurs also gain prominence (10.7% → 17.1%).
# These patterns suggest that extreme capital concentration is associated with
# larger firm classifications and a fundamental governance transition from
# owner-managed partnerships toward professionalized, hierarchical corporate
# structures with separated ownership and control.

# dramatic size shift
p1 <- 
  dfa |>
  filter(capital_stock < 100000000000) |>
  mutate(in_tail = ifelse(
    capital_stock >= quantile(capital_stock, 0.99, na.rm = TRUE),
    "Top 1% Tail",
    "Normal (Bottom 99%)"
  )) |>
  group_by(in_tail, company_size) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(in_tail) |>
  mutate(pct = 100 * n / sum(n)) |>
  ggplot(aes(x = in_tail, y = pct, fill = company_size)) +
  geom_col(position = "stack") +
  geom_text(
    aes(label = sprintf("%.1f%%", pct)),
    position = position_stack(vjust = 0.5),
    color = "white",
    fontface = "bold"
  ) +
  labs(
    title = "Company Size Distribution: Normal vs. Top 1% Tail",
    subtitle = "Micro-enterprises drop from majority to minority in high-capital tail",
    x = NULL,
    y = "Percentage",
    fill = "Company Size"
  ) +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal() +
  theme(legend.position = "bottom")

# owner qualification shift
p2 <- 
  dfa |>
  filter(capital_stock < 100000000000) |>
  mutate(in_tail = ifelse(
    capital_stock >= quantile(capital_stock, 0.99, na.rm = TRUE),
    "Top 1% Tail",
    "Normal (Bottom 99%)"
  )) |>
  group_by(in_tail, owner_qualification) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(in_tail) |>
  mutate(pct = 100 * n / sum(n)) |>
  filter(pct > 1) |>
  ggplot(aes(x = owner_qualification, y = pct, fill = in_tail)) +
  geom_col(position = "dodge") +
  coord_flip() +
  labs(
    title = "Owner Qualification: Normal vs. Top 1% Tail",
    subtitle = "Executive roles (Directors, Presidents) surge in high-capital companies",
    x = NULL,
    y = "Percentage",
    fill = NULL
  ) +
  scale_fill_manual(values = c("Top 1% Tail" = "#E41A1C", 
                               "Normal (Bottom 99%)" = "#377EB8")) +
  theme_minimal() +
  theme(legend.position = "bottom")

# side-by-side percentages
p3 <- 
  dfa |>
  filter(capital_stock < 100000000000) |>
  mutate(in_tail = capital_stock >= quantile(capital_stock, 0.99, na.rm = TRUE)) |>
  group_by(in_tail, owner_qualification) |>
  summarise(n = n(), .groups = "drop") |>
  group_by(in_tail) |>
  mutate(pct = 100 * n / sum(n)) |>
  tidyr::pivot_wider(names_from = in_tail, values_from = pct, values_fill = 0) |>
  rename(Tail = `TRUE`, Normal = `FALSE`) |>
  mutate(difference = Tail - Normal) |>
  filter(abs(difference) > 1) |>
  ggplot(aes(x = reorder(owner_qualification, difference), y = difference)) +
  geom_col(aes(fill = difference > 0)) +
  coord_flip() +
  labs(
    title = "Change in Owner Qualification: Top 1% Tail vs. Normal",
    subtitle = "Positive = overrepresented in tail; Negative = underrepresented",
    x = NULL,
    y = "Percentage Point Difference (Tail - Normal)"
  ) +
  scale_fill_manual(values = c("TRUE" = "#2CA02C", "FALSE" = "#D62728"),
                    guide = "none") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  theme_minimal()
