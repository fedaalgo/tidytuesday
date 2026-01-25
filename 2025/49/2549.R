# --- tidytuesday::2549 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2025/2025-12-09/readme.md

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
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-12-09/qatarcars.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2025/2025-12-09/readme.md

# understand ----

# names
df |> 
  slice(1) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

df |> 
  ggplot(aes(x = economy, y = mass)) +
  geom_point() +
  geom_smooth(colour = '#cc241d') +
  geom_smooth(colour = '#3C3836', method = 'lm') +
  theme_minimal()

# ...
