# --- tidytuesday::2548 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2025/2025-12-02/readme.md

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
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-12-02/sechselaeuten.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2025/2025-12-02/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# visualise ----

p1 <- 
  df |> 
  filter(year > 1950) |> 
  ggplot(aes(x = year, y = duration)) +
  geom_line() +
  theme_minimal()

p2 <-
  df |> 
  filter(year > 1950) |> 
  ggplot(aes(x = year, y = tre200m0)) +
  geom_line() +
  theme_minimal()

p1 + p2

df |> 
  filter(year > 1950) |> 
  ggplot(aes(x = duration, y = tre200m0)) +
  geom_point() +
  geom_smooth(colour = '#cc241d', method = 'lm') +
  theme_minimal()

# ...
