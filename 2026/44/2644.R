# --- tidytuesday::2644 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-11-03/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-11-03/grambank_languages.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-11-03/grambank_parameters.csv'
  ) |>
  clean_names()

dfc <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-11-03/grambank_values.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-11-03/readme.md

# understand ----

# names
dfa |> 
  slice(0) |> 
  glimpse()

dfb |> 
  slice(0) |> 
  glimpse()

dfc |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
dfa |>
  glimpse() |>
  skim()

dfb |>
  glimpse() |>
  skim()

dfc |>
  glimpse() |>
  skim()

# transform ----

# visualise ----

# model ----

# communicate ----

# ...

# This week we're exploring languages! The dataset comes from Grambank, a
# massive, open-access digital database that maps the grammatical structures of
# over 2,400 of the world's languages. Instead of looking at the vocabulary,
# Grambank focuses purely on grammar rules and structural features.

# For any given language, it looks at things like:

# - Word Order: Does the language put the subject before the verb (like English
#   "the cat sat") or after?
# - Pronouns: Does the language have a specific word for "we" that means "you
#   and me, but not anyone else"?
# - Grammatical Gender: Does it assign masculine or feminine genders to nouns?
# - Sound and Structure: How are plurals, tenses, or questions formed?

# It's a tool built by an international team of linguists to show just how
# diverse (and how connected) human speech really is.

# > "...An analysis of the consequences of language loss reveals that the
# > reduction in diversity will be strikingly uneven across the major linguistic
# > regions of the world. Without sustained efforts to document and revitalize
# > endangered languages, our linguistic window into human history, cognition,
# > and culture will be seriously fragmented."

# Here are a few questions you can answer with your visualisations this week:

# - How do specific grammatical features (like word order or head-marking)
#   spread spatially across borders compared to within language families?
# - Which typological features frequently co-occur across the world's languages?
# - How similar are languages structurally across families and macro-regions?
