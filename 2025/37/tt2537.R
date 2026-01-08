# --- tidytuesday::2537 --- #
# https://github.com/rfordatascience/tidytuesday/tree/main/data/2025/2025-09-16

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-09-16/all_recipes.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-09-16/cuisines.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2025/2025-09-16/readme.md

# understand ----

# names
dfa |> 
  slice(0) |> 
  glimpse()

dfb |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
dfa |>
  glimpse() |>
  skim()

dfb |>
  glimpse() |>
  skim()

# visualise ----

dfa |> 
  select(calories) |> 
  arrange(desc(calories)) |> 
  filter(calories < 1000) |> 
  ggplot(aes(calories)) + 
  geom_histogram(binwidth = 5) +
  theme_minimal()

# ...
