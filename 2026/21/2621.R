# --- tidytuesday::2621 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-05-26/readme.md

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
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-05-26/energy_cleaned.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-05-26/readme.md

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
