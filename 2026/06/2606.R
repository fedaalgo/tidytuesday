# --- tidytuesday::2606 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2026/2026-02-10/readme.md

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
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2026/2026-02-10/schedule.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2026/2026-02-10/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# ...

# which sport disciplines have the most events scheduled?

df |> 
  group_by(discipline_code) |> 
  summarise(n =n()) |> 
  arrange(desc(n)) |> 
  knitr::kable()

# how are medal events distributed across the days of the olympics?

df |> 
  filter(is_medal_event == TRUE) |> 
  group_by(day_of_week) |> 
  summarise(n = n()) |> 
  arrange(desc(n)) |> 
  knitr::kable()

# what is the typical duration of different types of events?

## duration 
df |>
  mutate(
    duration_minutes = as.numeric(
      difftime(
        end_datetime_local,
        start_datetime_local,
        units = "mins"
      )
    )
  ) |>
  glimpse()

## duration by discipline
df |>
  mutate(
    duration_minutes = as.numeric(
      difftime(
        end_datetime_local,
        start_datetime_local,
        units = "mins"
      )
    )
  ) |>
  group_by(discipline_name) |>
  summarise(
    n_events = n(),
    median_duration = median(duration_minutes, na.rm = TRUE),
    mean_duration   = mean(duration_minutes, na.rm = TRUE),
    sd_duration     = sd(duration_minutes, na.rm = TRUE)
  ) |>
  arrange(desc(median_duration))

## medal vs non-medal events
df |>
  mutate(
    duration_minutes = as.numeric(
      difftime(
        end_datetime_local,
        start_datetime_local,
        units = "mins"
      )
    )
  ) |>
  group_by(is_medal_event) |>
  summarise(
    median_duration = median(duration_minutes, na.rm = TRUE),
    mean_duration   = mean(duration_minutes, na.rm = TRUE)
  )

## training vs competition
df |>
  mutate(
    duration_minutes = as.numeric(
      difftime(
        end_datetime_local,
        start_datetime_local,
        units = "mins"
      )
    )
  ) |>
  group_by(is_training) |>
  summarise(
    median_duration = median(duration_minutes, na.rm = TRUE)
  )

## custom event type
df |>
  mutate(
    duration_minutes = as.numeric(
      difftime(
        end_datetime_local,
        start_datetime_local,
        units = "mins"
      )
    ),
    event_type = case_when(
      is_training    ~ "Training",
      is_medal_event ~ "Medal Event",
      TRUE           ~ "Other Competition"
    )
  ) |>
  group_by(event_type) |>
  summarise(
    median_duration = median(duration_minutes, na.rm = TRUE)
  )

# which venues host the most events?

df |>
  group_by(venue_name) |>
  summarise(
    n_events = n()
  ) |>
  arrange(desc(n_events))

# how does the schedule vary by day of the week?
df |>
  mutate(
    duration_minutes = as.numeric(
      difftime(
        end_datetime_local,
        start_datetime_local,
        units = "mins"
      )
    )
  ) |>
  group_by(day_of_week) |>
  summarise(
    median_duration = median(duration_minutes, na.rm = TRUE),
    mean_duration   = mean(duration_minutes, na.rm = TRUE)
  ) |>
  arrange(desc(median_duration))

# what proportion of scheduled sessions are training versus competition?

df |>
  mutate(
    session_type = if_else(is_training, "Training", "Competition")
  ) |>
  count(session_type) |>
  mutate(
    proportion = n / sum(n)
  )
