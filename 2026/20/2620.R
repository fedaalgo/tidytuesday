# --- tidytuesday::2620 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-05-12/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-05-19/member_participation_stats_by_country.csv'
  ) |>
  clean_names()

dfb <- 
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-05-19/metadata_coverage_stats_by_country.csv'
  ) |> 
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-05-12/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# transform ----

# visualise ----

# model ----

# communicate ----

# ...

# Crossref is a central pillar of the global research ecosystem, running open
# infrastructure to create a lasting and reusable scholarly record that
# underpins open science. While many of us know Crossref for providing Digital
# Object Identifiers (DOIs), they also maintain a massive repository of
# metadata, which is the essential data about research that makes it
# discoverable, linkable, and reusable. This dataset provides a granular look at
# how that metadata was populated across the globe from December 2018 to April
# 2026 (with monthly granularity beginning in January 2025). It is split into
# two files:
#
# - Member participation statistics by country: 
#   a look at the Crossref members registering DOIs,
#   broken down by region and country, highlighting the geographical
#   diversity of the publishing community.
# 
# - Metadata coverage statistics:
#   a look at metadata completion at the level of individual outputs,
#   also broken down by region and country, and also by content type.
#   This details the connectedness of research, including adoption metrics 
#   for citations, funding, ORCID IDs, and ROR IDs.
#
# By analyzing these files, you can explore themes of global research equity,
# the adoption of modern publishing standards, and the varying levels of
# metadata richness across different corners of the world. By shifting the lens
# from global aggregates to country-level insights, this dataset provides a new
# look at the global landscape of scholarly communication. It serves as a
# critical benchmark for Crossref's Research Nexus vision — the creation of a
# rich, reusable open network of relationships connecting research
# organizations, people, and actions — enabling the community to track progress
# toward a more transparent and interconnected global research record.
#
# - Which countries or regions show the fastest growth in metadata "richness" over time?
# - How does the connectedness of research vary across different work types within a single country?
# - Which regions are leading the way in adopting the Research Nexus vision?
