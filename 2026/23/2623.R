# --- tidytuesday::2623 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-06-09/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-06-09/game_films.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-06-09/readme.md

# understand ----

# names
dfa |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
dfa |>
  glimpse() |>
  skim()

# transform ----

# visualise ----

# model ----

# communicate ----

# ...

# The dataset this week comes from the Wikipedia article List of films based on
# video games. It covers theatrical releases, direct-to-video productions,
# television films, short films, and documentaries adapted from video games,
# spanning from the early 1990s to upcoming releases. Each row is a film, with
# box office figures, critic scores, budgets, and release dates where available.
# The list covers feature films, animated films, live-action films, television
# films, and short films that are based on or inspired by a video game
# franchise. Some questions worth exploring:

# - which video game franchise has generated the most film adaptations, and
#   which has earned the most at the box office?
# - which video game publishers have the most film adaptations, and how have
#   they performed at the box office?
# - do audiences and critics agree? Compare CinemaScore grades against Rotten
#   Tomatoes scores
