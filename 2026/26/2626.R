# --- tidytuesday::2626 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-06-30/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.6", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  leaflet, # https://cran.r-project.org/web/packages/leaflet/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
dfa <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-06-30/wreck_inventory.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-06-30/readme.md

# understand ----

# names
dfa |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
dfa |>
  glimpse() |>
  skim()

# visualise ----

dfa |>
  filter(!is.na(latitude) | !is.na(longitude)) |>
  leaflet() |>
  addTiles() |>
  addProviderTiles("CartoDB.DarkMatter") |>
  addCircleMarkers(
    lng = ~ longitude,
    lat = ~ latitude,
    radius = 0.5,
    clusterOptions = markerClusterOptions(),
    fillOpacity = 0.05
  )

# ...

# This week we are exploring Irish shipwreck data. The Wreck Inventory of
# Ireland Database (WIID) holds records of over 18,000 known and potential wreck
# sites in Irish waters, with data going back all the way to the 1300s.
# The Wreck Inventory of Ireland Database (WIID) holds records of over 18,000
# known and potential wreck sites in the marine and inland waterways of Ireland.
# The WIID includes all known wrecks dating to pre-1946 but some later wrecks
# are also included. The database also includes records of aircraft wrecks where
# these have come to attention.

# - How many wrecks still have not been found?
# - Where are shipwrecks more likely to occur around Ireland?
