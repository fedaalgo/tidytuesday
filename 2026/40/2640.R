# --- tidytuesday::2640 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-10-06/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-06/avocado_oil_bottles.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-10-06/avocado_oil_processed_foods.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-10-06/readme.md

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

# This week we're exploring avocado oil authenticity data from UC Davis
# researchers. The dataset includes two studies: one from 2020 examining bottled
# avocado oils and one from 2026 examining processed foods made with avocado
# oil. The studies reveal widespread fraud in the avocado oil market. The 2020
# study found that 82% of bottled avocado oils were either rancid or adulterated
# with cheaper oils like soybean oil. Six years later, the problem had spread to
# processed foods: 89% of chips, mayonnaise, and salad dressings labeled as
# "made with avocado oil" failed authenticity testing. By contrast, olive oil
# products (which have been regulated for decades) were overwhelmingly pure.

# The bottled oil dataset includes detailed chemical fingerprints (fatty acid
# profiles, sterol composition, and vitamin E content) that researchers use to
# detect fraud. The processed foods dataset tracks which specific brands and
# product categories passed or failed lot-level testing. Together, these
# datasets tell the story of a premium food category with almost no consumer
# protection.

# Consumers are increasingly paying a premium for products made with avocado oil
# or olive oil. They deserve to get what they pay for and food manufacturers
# deserve confidence that the ingredients they purchase from suppliers are
# authentic.

# - Can you use the fatty acid and sterol profiles to build a classifier that
#   distinguishes pure avocado oil from adulterated samples?

# - Which chemical markers are the strongest indicators of soybean oil vs.
#   sunflower/safflower oil adulteration?

# - How does the failure rate differ across product categories (chips vs. mayo
#   vs. dressings), and why might mayo fare better?

# - Does price correlate with authenticity for bottled oils? Are consumers paying
# more for genuine products?

# - How do the olive oil results compare to avocado oil results, and what does
#   that tell us about the value of industry regulation?

