# --- tidytuesday::2641 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-10-13/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-13/frogs_and_toads_amphibiaweb.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.

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

# This week we're exploring Frogs and Toads through AmphibiaWeb's massive
# dataset! The quote below is taken from one of the many weekly articles linked
# in their Amphibian News! portal, with entries going all the way back to 2009.

# Understanding why biodiversity is unevenly distributed is fundamental to
# ecology and evolution. Should we look to contemporary climate to explain where
# species diversity is highest, or look deeper into the past? Jongsma et al.
# (2026) tackled this question in the Lower Guinean Forests of Central Africa...
# Pleistocene forest stability explained 65-71% of spatial variance in species
# richness and phylogenetic diversity, which far exceeds contemporary
# temperature, precipitation, or forest cover.

# Here are a few questions you might answer with your visualisations this week:

# - Which frog families contain the highest species counts, and how is diversity
#   distributed across genera?

# - Which countries host the highest numbers of native frog/toad species?

# - How do IUCN status designations (interntnl_status) vary across families or
#   geographical regions?

# - Can historical geographic range notes or habitat descriptions explain
#   current regional species clustering?
