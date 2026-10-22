# --- tidytuesday::2639 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-09-29/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-09-29/health.csv'
  ) |>
  clean_names()

# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-09-29/readme.md

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

# This week we're exploring the Global Human Settlement Urban Centre Database
# Produced by the Joint Research Centre (JRC) of the European Commission, part
# of the Copernicus Emergency Management Service. These are open and free data
# and tools to assess the human presence on the planet. The dataset covers more
# than 10,000 urban centres worldwide, each delineated using a population
# density, size, and grid-cell contiguity method called the Degree of
# Urbanisation. Here, we are specifically looking at the Health component which
# details information regarding hospitals and pharmacies in urban centers.

# This dataset contains statistics on urban centres based on data from the
# Global Human Settlement Layer (GHSL) produced at the Joint Research Centre of
# the European Commission, unit E.1 (Disaster Risk Management). This release is
# based on the GHSL Data Package 2023, the Degree of Urbanisation to delineate
# spatial entities, and geospatial data integration from a variety of open
# source datasets to characterise them. The result is the most complete
# information system on cities to date with data for 11,422 quality-controlled
# urban centres across 15 thematic domains [Health is one of them], 471
# indicators, and 2600 attributes.

# Which urban centre or country has the most number of hospitals and/or
# pharmacies per capita in 2025?

# Do urban centres that belong to a higher income group have a higher density of
# hospitals compared to those in a lower income group?

# Do cities with more hospitals also have more pharmacies, or are the two
# resources unrelated?

# Are there cities well-served by pharmacies but not hospitals (or the otherway
# around)?
