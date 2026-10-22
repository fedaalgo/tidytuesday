# --- tidytuesday::2638 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-09-22/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-09-22/urban.csv'
  ) |>
  clean_names()

# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-09-22/readme.md

# understand ----

# names
dfa |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
dfa |>
  glimpse() |>
  skim()

# tokenize
# dfa |>
#   unnest_tokens(output = word, input = variable) |>
#   anti_join(stop_words, by = "word") |>
#   group_by(word) |>
#   summarise(n = n()) |>
#   arrange(desc(n))

# transform ----

# visualise ----

# model ----

# communicate ----

# ...

# This week we are exploring the average share of green areas in cities and
# urban areas and green area per capita around the world. The dataset this week
# comes from UN Habitat Urban Indicators Dataset.

# The data referenced herein is calculated using urban boundaries defined using
# the Degree of Urbanization approach to defining cities and urban areas, which
# may be larger or smaller than the official municipality boundaries. Within
# each city/urban area, the green areas are extracted using satellite imagery
# analysis for five time periods 1990, 2000, 2010,2020 and 2025 based on the
# Normalized Difference Vegetation Index (NDVI), which assesses the level of
# greenness from satellite imagery. In this analysis, green areas are defined as
# parts of the city that are green for most parts of the year, and include
# individual trees, forests or forested areas, shrubs, perennial grasses and
# such other types of long-term vegetation. Waterbodies are not considered as
# green areas in this assessment.

# - Which city has the most green area per capita in each year?
# - Which city has lost the largest percentage of its green area since 1990?
# - Which city has gained the largest percentage of green area since 1990?
