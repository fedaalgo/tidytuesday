# --- tidytuesday::2607 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-02-17/readme.md

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
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-02-17/dataset.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-02-17/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

df |> 
  group_by(value_label) |> 
  summarise(n = n()) |> 
  arrange(desc(n)) |> 
  print(n = Inf)

# ...

# is sheep production unique in its decline?
df |>
  filter(measure == "Total Sheep") |>
  group_by(value_label, year_ended_june) |>
  summarise(total = sum(value), .groups = "drop") |>
  group_by(value_label) |>
  mutate(indexed = total / total[which.min(year_ended_june)] * 100) |>
  ggplot(aes(x = year_ended_june, y = indexed, colour = value_label)) +
  geom_line(linewidth = 1) +
  labs(title = "Sheep production indexed to first available year",
       x = "Year", y = "Index (first year = 100)", colour = NULL) +
  theme_minimal()

# do other types of meat production show the same pattern?
df |>
  filter(measure %in% c("Total Sheep", "Total Cattle", "Total Pigs", 
                        "Total Deer", "Total goats")) |>
  group_by(value_label, year_ended_june) |>
  summarise(total = sum(value), .groups = "drop") |>
  group_by(value_label) |>
  mutate(indexed = total / total[which.min(year_ended_june)] * 100) |>
  ggplot(aes(x = year_ended_june, y = indexed, colour = value_label)) +
  geom_line(linewidth = 1) +
  labs(title = "Livestock trends indexed to first available year",
       x = "Year", y = "Index (first year = 100)", colour = NULL) +
  theme_minimal()

# which agricultural industries have shown the most production growth?
df |>
  group_by(value_label, measure) |>
  summarise(
    first_val = value[which.min(year_ended_june)],
    last_val  = value[which.max(year_ended_june)],
    .groups = "drop"
  ) |>
  mutate(pct_change = (last_val - first_val) / first_val * 100) |>
  slice_max(pct_change, n = 15) |>
  ggplot(aes(x = reorder(measure, pct_change), y = pct_change, fill = value_label)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 15 agricultural production increases (first to last year)",
       x = NULL, y = "% change", fill = NULL) +
  theme_minimal()
