# --- tidytuesday::2613 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-03-31/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.5", .libPaths()))

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-31/ocean_temperature.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-31/ocean_temperature_deployments.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-03-31/readme.md

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

# visualise ----

# interactive map
dfb |>
  filter(!is.na(latitude) | !is.na(longitude)) |>
  filter(deployment_id != "depl_01") |> 
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

# 2 groups and 1 isolated reading detected
dfb |> filter(latitude < 44.57)
dfb |> filter(latitude > 44.57)

dfb |>
  filter(deployment_id != "depl_01") |> 
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

# The Province of Nova Scotia recognizes the importance of coastal
# waters, which are critical to the prosperity and sustainability of
# rural and coastal communities. To bridge the gap between science and
# decision making, the Nova Scotia Department of Fisheries and
# Aquaculture (NSDFA) partners with the Centre for Marine Applied
# Research (CMAR) to measure the environmental conditions of Nova
# Scotia’s coastal waters.

# how are temperatures changing over time?

set.seed(1)
dfa_sample <- dfa |> slice_sample(n = 100)

dfa_sample |>
  mutate(year = year(date)) |>
  group_by(year, sensor_depth_at_low_tide_m) |>
  summarise(mean_temp = mean(mean_temperature_degree_c, na.rm = TRUE),
            .groups = "drop") |>
  ggplot(aes(x = year, y = mean_temp)) +
  geom_line(colour = "#1D9E75", linewidth = 0.9) +
  geom_point(colour = "#0F6E56", size = 2) +
  facet_wrap( ~ sensor_depth_at_low_tide_m,
              labeller = label_both,
              ncol = 4) +
  labs(title = "Annual ean temperature trend by depth", x = NULL, y = "mean temperature (°C)") +
  theme_minimal()

ggsave(
  filename = "timelines.png",
  width    = 16,
  height   = 10,
  dpi      = 300,
  bg       = "#ffffff"
)
