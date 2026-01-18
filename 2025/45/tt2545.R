# --- tidytuesday::2545 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2025/2025-11-11/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-11-11/who_tb_data.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2025/2025-11-11/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# visualise

df |> 
  filter(country == "El Salvador") |> 
  ggplot(aes(year, e_mort_num)) +
  geom_line() +
  geom_point() +
  labs(
    x = "year",
    y = "incidents",
    title = "tuberculosis burden estimates",
  subtitle = "El Salvador"
  ) +
  theme_minimal()

# ...
