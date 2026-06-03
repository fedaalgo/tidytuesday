# --- tidytuesday::2619 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-05-12/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.6", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
dfa <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-05-12/cities.csv'
  ) |>
  clean_names()

dfb <- 
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-05-12/links.csv'
  ) |> 
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-05-12/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# transform ----

# visualise ----

# model ----

# communicate ----

# ...

dfa |> 
  filter(countrycd == "SV") |> 
  glimpse()

# This week we're exploring data about links between cities! Twinned towns (also
# known as sister cities) are a form of legal or social agreement between two
# geographically and politically distinct localities for the purpose of
# promoting cultural and commercial ties. This dataset looks at links
# specifically between cities, i.e. it does not include towns, villages or other
# geographic entities..

# - is every country connected through a chain of twin city links?
# - which city is the most connected?
# - which countries are the most connected to each other?
