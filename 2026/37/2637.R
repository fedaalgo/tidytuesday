# --- tidytuesday::2637 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-09-15/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-09-15/dead_sea_scrolls.csv'
  ) |>
  clean_names()

# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-09-15/readme.md

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

# This week we're exploring the Dead Sea Scrolls, seen by many as the most
# significant archaeological manuscript discovery of the 20th century. The
# dataset catalogs 809 manuscripts from the Israel Antiquities Authority's
# official Leon Levy Dead Sea Scrolls Digital Library, covering all 11 Qumran
# caves plus Masada, Wadi Murabba'at, and Nahal Hever. Each manuscript is
# classified by its biblical content, canonical status, language, material,
# paleographic period, and discovery site.

# The Dead Sea Scrolls were discovered between 1947 and 1956 in caves near the
# Dead Sea. Dating from approximately 300 BCE to 68 CE, they include the oldest
# known copies of biblical texts, sectarian community documents, and a wide
# range of Jewish religious literature from the Second Temple period. The
# collection provides direct physical evidence of what Jewish communities read,
# copied, and valued as Scripture in the centuries before and during the time of buddy Jesus.

# Researchers have assembled a collection of 981 different manuscripts from 11
# caves, which lie in the immediate vicinity of the Hellenistic Jewish
# settlement at the site of Khirbet Qumran in the eastern Judaean Desert. The
# identified texts fall into three general groups: about 40% are copies of texts
# from the canonical Hebrew scriptures; approximately 30% are texts from the
# Second Temple period that ultimately were not canonized in the Hebrew Bible,
# such as the Book of Enoch, the Book of Jubilees, the Book of Tobit, the Wisdom
# of Sirach, and Psalms 152–155.

# - Which biblical books were copied most frequently, and what does that tell us
#   about their relative importance to the Qumran community?

# - Were deuterocanonical books (Tobit, Sirach, Letter of Jeremiah) treated
#   differently from protocanonical books in terms of storage location, writing
#   material, or scribal period?

# - How do the copy counts of non-canonical works like Jubilees and 1 Enoch
#   compare to accepted biblical books?

# - What does the distribution of manuscripts across caves tell us about the
#   library's organization?

# - Is there a relationship between manuscript language (Hebrew vs Aramaic vs
#   Greek) and content category?
