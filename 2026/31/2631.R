# --- tidytuesday::2631 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-08-04/readme.md

# setup ----

# library path
.libPaths("~/.local/share/R/x86_64-pc-linux-gnu-library/4.6")

# load
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse # https://cran.r-project.org/web/packages/tidyverse/
)

# import
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-08-04/basotho_wool.csv'
  ) |>
  clean_names()
# dictionary
# https://github.com/rfordatascience/tidytuesday/raw/refs/heads/main/data/2026/2026-08-04/readme.md

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

# This week we're exploring Lesotho's Wool Trade. The dataset comes from the UN
# Comtrade Database using the comtradr package. The country is known as
# "Lesotho", and its people are referred to as "Basotho" (pronounced
# "ba-soo-too").

# Extract from the article "The mountain men behind Lesotho’s wool wealth - More
# than 80,000 herders tend the country’s sheep and goats" by Sechaba Mokhethi
# for GroundUp News:

# For generations, Lesotho’s economy depended heavily on migrant labour to South
# African mines. But as mining jobs declined, many rural households turned back
# to livestock production. Today, wool and mohair have become one of the
# country’s most valuable agricultural exports.

# “During the 2024–2025 season alone, around M800-million entered the country
# through wool and mohair sales,” says Thinyane. That does not include the sale
# of animals for meat or breeding.

# “Our wool is sold on the international market through Port Elizabeth in South
# Africa, where the International Wool Textile Organisation testing centre is
# located,” he explains. “Before wool is sold, it is tested there. Buyers then
# compete through auctions, and prices are determined.”

# Thinyane says Lesotho is internationally known for high-quality mohair from
# Angora goats, prized in luxury fashion and textile industries for its softness
# and durability.

# But the industry’s success depends heavily on the painstaking work done by
# herders like Tšoeu who spend freezing winters and scorching summers caring for
# livestock in the remote mountains.

# Some questions you can answer:

# - Does Winter (being in the Southern hemisphere, these are the months June, July
# and August) impact Basotho wool quantity/volume exported and revenue?
# Which country imports the most Basotho wool at time on average?
