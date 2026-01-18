# --- tidytuesday::2539 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2025/2025-09-30/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-09-30/cranes.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2025/2025-09-30/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |> 
  mutate(date = as.Date(date)) |> 
  glimpse() |> 
  skim()

df |> 
  filter(!is.na(observations)) |> 
  View()

# visualise ----

df |>
  filter(!is.na(observations)) |> 
  mutate(date = as.Date(date)) |> 
  arrange(date) |>
  ggplot(aes(date, observations)) +
  geom_point(alpha = 0.3) +
  geom_smooth(
    color = "#cc241d",
    se = FALSE,
    span = 0.2
  ) +
  labs(
    x = "date",
    y = "count",
    title = "observations over time"
  ) +
  theme_minimal()

df |>
  filter(!is.na(observations)) |>
  mutate(date = as.Date(date)) |> 
  mutate(week = floor_date(date, "week")) |>
  group_by(week) |>
  summarise(observations = sum(observations), .groups = "drop") |>
  ggplot(aes(week, observations)) +
  geom_line() +
  geom_point() +
  theme_minimal()

# ...
