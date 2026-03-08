# --- tidytuesday::2609 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-03-03/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.5", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  styler, # https://cran.r-project.org/web/packages/styler/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
dfa <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-03/clutch_size_cleaned.csv'
  ) |>
  clean_names()

dfb <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-03-03/tortoise_body_condition_cleaned.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-03-03/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

dfb |> 
  ggplot(aes(
    x = straight_carapace_length_mm,
    y = body_mass_grams,
    colour = season)
  ) +
  geom_point(alpha = 0.35) +
  facet_wrap( . ~ season)

dfb |> 
  group_by(season) |> 
  summarise(n = n()) |> 
  arrange(desc(n)) |> 
  ggplot(aes(x = season, y = n)) +
  geom_col()

# ...

# In an exceptionally dense island population of Hermann's tortoises 
# in Lake Prespa in North Macedonia, sexually coercive males 
# dramatically overnumber females, inflict severe copulatory injuries 
# and put them at risk of fatal falls from the island plateau's sheer 
# rock faces. Harassed females are emaciated, reproduce less frequently,
# produce smaller clutches and have lower annual survival rates compared 
# to females from a neighbouring mainland population. Sixteen years of 
# capture-recapture data reveal an ongoing extinction event and predict
# that the last island female will die in 2083. 

# do recaptures happen more often in spring or summer?

# does it seem easier to recapture male or female tortoises?

# what are the differences among tortoises from the mainland 
# vs the ones from the island in terms of body mass or carapace length?
