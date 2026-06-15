# --- tidytuesday::2624 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-06-16/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-06-16/england_wales_names.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-06-16/ni_names.csv'
  ) |>
  clean_names()

dfc <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-06-16/scotland_names.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-06-16/readme.md

# understand ----

df_list <- list(dfa = dfa, dfb = dfb, dfc = dfc)

# names
df_list |>
  map(
    ~ .x |>
      slice(0) |>
      glimpse()
  )

# glimpse & skim
df_list |> 
  map(
    ~.x |> 
      glimpse() |> 
      skim()
  )

# visualise ----

df_list |>
  map(
    ~ .x |>
      drop_na(name) |>
      group_by(name) |>
      summarise(n = n(), .groups = "drop") |>
      arrange(desc(n))
  )

# ...

# There are three datasets which cover baby names across England and Wales from
# the Office for National Statistics, Northern Ireland from the Northern Ireland
# Statistics and Research Agency, and Scotland from National Records of
# Scotland.

# Dearest gentle reader… we can report that Daphne, Eloise and Penelope have all
# increased in popularity this year, with the name of each Bridgerton character
# reaching joint 172nd, 91st, and 71st place respectively, up from 476th, 124th,
# and 81st in 2024.

# How does the ranking of most popular names compare between the three datasets?
# Are boys' or girls' names more likely to be unique? Can you show the
# Bridgerton trend in charts?

bridgerton_names <- c("Daphne", "Eloise", "Penelope", "Anthony", "Simon")

df_list |>
  map(
    ~ .x |>
      drop_na(name) |>
      filter(name %in% bridgerton_names) |>
      group_by(name) |>
      summarise(n = n(), .groups = "drop") |>
      arrange(desc(n))
  )
