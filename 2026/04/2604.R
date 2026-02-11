# --- tidytuesday::2604 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-01-27/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.5", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
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

dfa |>
  group_by(legal_nature) |> 
  summarise(n = n()) |> 
  arrange(desc(n)) |> 
  print(n = Inf)

# how does **company size** relate to capital stock (and how skewed is it)?

summary(dfa$capital_stock)

dfa |> 
  group_by(company_size) |> 
  summarise(
    n = n(),
    mean_cap = mean(capital_stock),
    median_cap = median(capital_stock),
    sd_cap = sd(capital_stock),
    skew_cap = mean((capital_stock - mean(capital_stock))^3) / 
                   sd(capital_stock)^3
  ) |> 
  arrange(desc(mean_cap))

# @article{joanes1998comparing,
#   author  = {Joanes, D. N. and Gill, C. A.},
#   title   = {Comparing Measures of Sample Skewness and Kurtosis},
#   journal = {Journal of the Royal Statistical Society: Series D (The Statistician)},
#   year    = {1998},
#   volume  = {47},
#   number  = {1},
#   pages   = {183--189},
#   doi     = {10.1111/1467-9884.00122}
# }

# do specific **owner qualification** groups dominate high-capital companies?

dfa |> 
  group_by(owner_qualification) |> 
  summarise(n = n()) |> 
  arrange(desc(n))

# what patterns emerge when comparing the **top capital-stock tail** across categories (legal nature, size, qualification)?
