# --- tidytuesday::2611 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-03-17/readme.md

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
  tidyverse, # https://cran.r-project.org/web/packages/tidyverse/
  trend # https://cran.r-project.org/web/packages/trend/index.html
)

# import
dfa <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-17/monthly_losses_data.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-17/monthly_mortality_data.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-17/monthly_mortality_data.csv

# understand ----

# names
dfb |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# trigg ----

# The Fish Health Report is the Norwegian Veterinary Institute's
# annual status report on the health and welfare situation for
# Norwegian farmed fish and is based on official statistics, data
# from the Norwegian Veterinary Institute and private laboratories.
# The report also contains results from a survey among fish health
# personnel and inspectors from the Norwegian Food Safety Authority,
# as well as assessments of the situation, trends and risks.

## how does monthly mortality differ across the time period data is available for? ----

# monthly national totals and a loss-rate proxy
dfa_national <- dfa |>
  mutate(year = year(date), month = month(date, label = TRUE)) |>
  group_by(species, date, year, month) |>
  summarise(
    total_losses    = sum(losses, na.rm = TRUE),
    total_dead      = sum(dead, na.rm = TRUE),
    total_discarded = sum(discarded, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(pct_dead      = total_dead / total_losses,
         pct_discarded = total_discarded / total_losses)

# regional version for faceting
dfa_regional <- dfa |>
  mutate(year = year(date), month = month(date, label = TRUE))

# regional level
dfb_clean <- dfb |>
  mutate(year = year(date), month = month(date, label = TRUE))

p1 <- # activate for patchwork
dfa_national |>
  ggplot(aes(x = month, y = factor(year), fill = total_losses)) +
  geom_tile(colour = "white", linewidth = 0.4) +
  scale_fill_viridis_c(option = "inferno",
                       labels = scales::label_number(scale = 1e-6, suffix = "M")) +
  labs(
    title    = "Monthly salmon losses — national total",
    subtitle = "Colour = total losses (dead + discarded + other)",
    x = NULL,
    y = NULL,
    fill = "Losses"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid = element_blank())

p2 <- # activate for patchwork
dfb_clean |>
  group_by(date, year, month) |>
  summarise(
    med = median(median, na.rm = TRUE),
    q1  = median(q1, na.rm = TRUE),
    q3  = median(q3, na.rm = TRUE),
    .groups = "drop"
  ) |>
  ggplot(aes(x = date)) +
  geom_ribbon(aes(ymin = q1, ymax = q3),
              fill = "#cc241d",
              alpha = 0.2) +
  geom_line(aes(y = med), colour = "#cc241d", linewidth = 0.9) +
  scale_y_continuous(labels = scales::label_number(suffix = "%")) +
  labs(
    title    = "Monthly mortality rate — rainbow trout",
    subtitle = "Median with interquartile range across regions",
    x = NULL,
    y = "Monthly mortality (%)"
  ) +
  theme_minimal(base_size = 12)

# salmon losses by region
## production area → county name mapping
po_to_county_a <- tribble(
  ~ region,
  ~ county,
  ~ po_label,
  "1",
  "Agder",
  "PO1: Agder",
  "2",
  "Rogaland",
  "PO2: Ryfylke",
  "3",
  "Vestland",
  "PO3: Karmøy to Sotra",
  "4",
  "Vestland",
  "PO4: Nordhordland to Sogn",
  "5",
  "Vestland",
  "PO5: Fjordane",
  "6",
  "Møre og Romsdal",
  "PO6: Nordmøre and Romsdal",
  "7",
  "Trøndelag",
  "PO7: Sør-Trøndelag",
  "8",
  "Trøndelag",
  "PO8: Nord-Trøndelag",
  "9",
  "Nordland",
  "PO9: Helgeland",
  "10",
  "Nordland",
  "PO10: Bodø to Steigen",
  "11",
  "Troms",
  "PO11: Vestfjord and Vesterålen",
  "12",
  "Troms",
  "PO12: Troms",
  "13",
  "Finnmark",
  "PO13: Finnmark"
)

dfa_recoded <- dfa |>
  left_join(po_to_county_a, by = "region") |>
  mutate(
    # use county col for numeric POs
    # keep named counties as-is, flag Norge separately
    region_clean = case_when(
      region == "Norge"    ~ "Norge",!is.na(county) ~ county,
      # numeric PO → mapped county
      TRUE                 ~ region # already a county name
    ),
    is_national = region == "Norge",
    region_type = case_when(
      region == "Norge"                    ~ "national",
      str_detect(region, "^[0-9]+$")       ~ "production_area",
      TRUE                                 ~ "county"
    ),
    partial_series = region %in% c("7", "8", "11", "12", "13"),
    region_label = coalesce(po_label, region)
  ) |>
  select(-county, -po_label)

dfa_recoded |>
  as_tibble() |>
  distinct(region,
           region_clean,
           region_type,
           partial_series,
           region_label) |>
  arrange(region_type, region_clean) |>
  print(n = Inf)

p3 <- # activate for patchwork
  dfa_recoded |>
  filter(geo_group == "county", !is_national) |>
  ggplot(aes(x = date, y = losses)) +
  geom_line(alpha = 0.7, colour = "#cc241d") +
  facet_wrap( ~ region_clean, ncol = 3) +
  scale_x_date(
    breaks = "2 years",
    date_labels = "%Y" # just year, no month clutter
  ) +
  scale_y_continuous(labels = scales::label_number(scale = 1e-3, suffix = "k")) +
  labs(title = "Monthly salmon losses by region", x = NULL, y = "Total losses") +
  theme_minimal(base_size = 10) +
  theme(
    panel.spacing.x  = unit(0.8, "lines"),
    # more breathing room between cols
    strip.text       = element_text(size = 9),
    axis.text.x      = element_text(size = 8)
)

# trout mortality rate by region
## drop all numeric PO codes that have a county-named duplicate
po_duplicates_to_drop <- c("1 & 2",
                           "2 & 3",
                           "12 & 13",
                           "3",
                           "5",
                           "6",
                           "7",
                           "8",
                           "9",
                           "10",
                           "11",
                           "5, 6, & 9")

gruvbox_colours <- c(
  "Finnmark"        = "#cc241d",
  "Møre og Romsdal" = "#d79921",
  "Nordland"        = "#98971a",
  "Troms"           = "#689d6a",
  "Trøndelag"       = "#458588",
  "Vestland"        = "#b16286"
)

p4 <- # activate for patchwork
  dfb |>
  filter(!region %in% po_duplicates_to_drop) |>
  mutate(
    is_national  = region == "Norge",
    is_aggregate = str_detect(region, "&|,"),
    region_clean = if_else(region == "4", "Vestland", region)
  ) |>
  filter(!is_national, !is_aggregate) |>
  ggplot(aes(x = date, y = median, colour = region_clean, fill = region_clean)) +
  geom_ribbon(aes(ymin = q1, ymax = q3),
              alpha = 0.15, colour = NA) +
  geom_line(linewidth = 0.7, alpha = 0.9) +
  facet_wrap(~ region_clean, nrow = 2, scales = "free_y") +
  scale_colour_manual(values = gruvbox_colours) +
  scale_fill_manual(values = gruvbox_colours) +
  scale_y_continuous(labels = scales::label_number(suffix = "%")) +
  labs(
    title    = "Monthly mortality rate by region — rainbow trout",
    subtitle = "Median with IQR ribbon",
    x = NULL,
    y = "Monthly mortality (%)"
  ) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "none")

## patchwork

p_combined <- 
(p1 + p3)/(p2 + p4)

ggsave(
  filename = "patchwork.png",
  plot     = p_combined,
  width    = 16,
  height   = 10,
  dpi      = 300,
  bg       = "#ffffff"
)

# seasonal index
## which months are consistently worst?
dfa_national |>
  group_by(month) |>
  summarise(
    mean_losses = mean(total_losses),
    sd_losses   = sd(total_losses),
    cv          = sd_losses / mean_losses   # coefficient of variation
  ) |>
  arrange(desc(mean_losses))

# year-over-year trend test (Mann-Kendall on annual totals)
annual <- dfa_national |>
  group_by(year) |>
  summarise(annual_losses = sum(total_losses))

# p-value + direction of trend
mk.test(annual$annual_losses)

# there is a moderate positive trend in the data but you cannot confidently
# distinguish it from chance. With only n = 6 annual observations the test has
# very low statistical power — Mann-Kendall needs at least 8–10 points to
# reliably detect anything but the strongest trends. A τ of 0.60 would be a
# meaningful and significant result with more years behind it

## which region has lowest mortality? ----

dfb |>
  filter(!region %in% po_duplicates_to_drop) |>
  mutate(
    is_national  = region == "Norge",
    is_aggregate = str_detect(region, "&|,"),
    region_clean = if_else(region == "4", "Vestland", region)
  ) |>
  filter(!is_national, !is_aggregate) |>
  group_by(region_clean) |>
  summarise(
    mean_median = mean(median, na.rm = TRUE),
    mean_q1     = mean(q1,     na.rm = TRUE),
    mean_q3     = mean(q3,     na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(mean_median)

## what other types of loses may be significant in addition to death of fish? ----

dfa_recoded |>
  filter(!is_national) |>
  summarise(across(c(dead, discarded, escaped, other), sum, na.rm = TRUE)) |>
  pivot_longer(everything(), names_to = "category", values_to = "total") |>
  mutate(pct = total / sum(total))
