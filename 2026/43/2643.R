# --- tidytuesday::2643 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-10-27/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-27/ikea_places.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-27/ikea_seating.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-10-27/readme.md

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

# transform ----

# visualise ----

# model ----

# communicate ----

# ...

# This week's data is IKEA sofas and armchairs and the Swedish places they are
# named after. Ingvar Kamprad, IKEA's founder, had dyslexia and found names
# easier to remember than number codes. Since December 2020, new products get
# Swedish names only, and sofas and armchairs are named after places in Sweden.
# KLIPPAN is a town in Skåne and EKTORP a suburb of Stockholm, but many are
# hamlets of a few houses.

# One table lists every sofa and armchair on ikea.com in 50 countries on 28
# September 2026, with prices in local currency and US dollars. The other has
# the places in Sweden that share each name, from OpenStreetMap.

# Sources: product listings from ikea.com; places from OpenStreetMap via
# Nominatim, © OpenStreetMap contributors (ODbL); exchange rates from the
# fawazahmed0 currency API (CC0).

# - Where in Sweden do the names come from? Do they cluster anywhere, for
#   example around Älmhult in Småland, where IKEA started?
# - Which names are sold in the most countries, and which only in a few?
# - How does the price of the same product (item_no) differ between countries in
#   US dollars (price_usd)?
# - What kinds of places are they: villages, single farms, lakes, islets?
