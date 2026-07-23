# --- tidytuesday::2630 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-07-28/readme.md

# setup ----

# library path
.libPaths("~/.local/share/R/x86_64-pc-linux-gnu-library/4.6")

# sanity check
pak::pkg_deps_tree()
pak::pkg_outdated()

# check requirements for specific packages
pak::pkg_sysreqs("ggraph")
pak::pkg_sysreqs("tidyverse")

# check requirements for ALL outdated packages
outdated <- pak::pkg_outdated()
if (nrow(outdated) > 0) {
  pak::pkg_sysreqs(outdated$package)
}
# if pak outputs pacman -s ... commands, run them in your terminal first.

pak::pkg_update(ask = FALSE, check_installed = TRUE)

# check: pak::pkg_outdated()
# verify sysreqs: pak::pkg_sysreqs(pak::pkg_outdated()$package) → install any listed system packages via pacman
# update: pak::pkg_update(ask = false, check_installed = true)
# load: keep using pacman::p_load(...) in your scripts

# load
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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-28/occurrences.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-28/tourism.csv'
  ) |>
  clean_names()

dfc <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-07-28/weather.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-07-28/readme.md

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

# transform ----

# visualise ----

# model ----

# communicate ----

# ...

# This week we're exploring ecotourism! The {ecotourism} R package provides
# tools to analyse ecological observation data alongside weather conditions and
# tourism data.

# The goal of ecotourism is to provide clean, ready-to-use datasets for example
# analyses in teaching, demos, and reproducible workflows.

# - Under which weather conditions are you most likely to observe a Gouldian finch?

dfa |>
  filter(organism_name == "Gouldian finch") |>
  group_by(date) |>
  summarise(sighting_count = n()) |>
  arrange(date) |>
  ggplot(aes(x = date, y = sighting_count)) +
  geom_line() +
  theme_minimal()

# - How does weather affect tourism numbers in each region?
# - How do observations of the different animals relate to numbers of tourists?
