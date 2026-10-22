# --- tidytuesday::2642 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-10-20/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-20/ai_salary_majors.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-20/major_occupations.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-10-20/readme.md

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

# This week we're looking at which college majors are safest from AI, and
# whether the safe ones actually pay well.

# The dataset joins three public sources at the level of the college major.
# Starting salaries come from the U.S. Department of Education's College
# Scorecard field-of-study files, using median earnings one year after
# graduation for bachelor's degrees. AI disruption risk comes from the AI
# Occupational Exposure (AIOE) index of Felten, Raj and Seamans (2021), which
# scores how much each occupation's required abilities overlap with what AI can
# do. It also includes separate scores for language tasks and image tasks. To
# connect the two, I used the NCES/BLS CIP-to-SOC crosswalk, which maps fields
# of study to the occupations their graduates tend to enter.

# The result is 285 majors, each with a starting salary and an AI exposure
# score. What stands out is that the two barely relate to each other (r is about
# 0.01). Hands-on technical fields like nuclear, marine, and aerospace
# engineering technology show low exposure and high pay. Registered nursing sits
# near the 20th percentile of AI exposure and pays around $75,000 to start. On
# the other end, several humanities majors are both highly exposed and among the
# lowest paid.

# One thing to know about the exposure score: the AIOE is standardized to a mean
# of 0 and a standard deviation of 1. A value of 0 is an average occupation, and
# negative values fall below average. High exposure does not necessarily mean a
# job will be automated away, since AI can also assist the work rather than
# replace it. So that you don't need a stats background to read it, the main
# table also includes ai_exposure_percentile, a plain 0 to 100 rank across all
# majors.

# The AIOE links ten common AI applications with fifty-two distinct occupational
# abilities used by O*NET and uses the relative prevalence of these abilities
# within an occupation to generate an occupational measure of AI exposure.
# (Felten, Raj and Seamans 2021; description rephrased for compliance with
# licensing restrictions.)

# Some questions to explore:

# - Which majors are both safe from AI and well paid, and which are both exposed
#   and low paid?

# - Does the picture change when you look at language-task exposure versus
#   image-task exposure?

# - Do broad fields like Engineering, Health Professions, Business, and
#   Humanities cluster together?

# - The AIOE measures exposure, not automation. How would the story change if
#   high exposure mostly meant AI assisting the work rather than replacing it?
