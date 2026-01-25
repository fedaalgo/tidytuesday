# --- tidytuesday::2546 --- #
# https://github.com/rfordatascience/tidytuesday/blob/main/data/2025/2025-11-18/readme.md

# setup ----

# library path
.libPaths(c("~/.local/share/R/x86_64-pc-linux-gnu-library/4.5", .libPaths()))

# packages
pacman::p_load(
  data.table, # https://cran.r-project.org/web/packages/data.table/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  ggraph, # https://cran.r-project.org/web/packages/ggraph/
  igraph, # https://cran.r-project.org/web/packages/igraph/
  likert, # https://cran.r-project.org/web/packages/likert/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  styler, # https://cran.r-project.org/web/packages/styler/
  stopwords, # https://cran.r-project.org/web/packages/stopwords/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse, # https://cran.r-project.org/web/packages/tidyverse/
  wordcloud2 # https://cran.r-project.org/web/packages/wordcloud2/
)

# import
df <-
  fread(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-11-18/holmes.csv'
  ) |>
  clean_names()
# dictionary
# https://raw.githubusercontent.com/rfordatascience/tidytuesday/refs/heads/main/data/2025/2025-11-18/readme.md

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# sample
set.seed(8080)
df_sample <- as.data.table(df)[sample(.N, 1000)]

# stopwords ----
stopwords_en <-
  data.frame(word = stopwords(language = 'en')) |>
  rbind(data.frame(
    word = c(
      ""
    )
  )
)

# tokenize
df_sample |> 
  unnest_tokens(output = word, input = text) |>
  anti_join(stopwords_en, by = "word") |>
  filter(str_length(word) >= 5) |>
  group_by(word) |>
  summarise(n = n()) |>
  arrange(desc(n))

# visualise

# wordcloud ----

df_sample |> 
  unnest_tokens(output = word, input = text) |>
  anti_join(stopwords_en, by = "word") |>
  filter(str_length(word) >= 5) |>
  group_by(word) |>
  summarise(n = n()) |>
  arrange(desc(n)) |> 
  wordcloud2(
    backgroundColor = "#444444",
    color = "#fbd558",
    fontFamily = 'Arial',
    rotateRatio = 0
)

# bi-gram ----

df_sample |> 
  select(text) |> 
  unnest_ngrams(word, text, n = 2) |> 
  group_by(word) |> 
  summarise(n = n()) |> 
  arrange(desc(n)) |> 
  filter(str_length(word) > 3)

df_sample_bigrams <- 
  df_sample |> 
  select(text) |> 
  filter(!is.na(text)) |>
  filter(str_trim(text) != "") |>
  unnest_ngrams(word, text, n = 2)

df_sample_bigrams_sep <- 
  df_sample_bigrams |> 
  separate(word, c("word1", "word2"), sep = " ") |>
  filter(!is.na(word1) & !is.na(word2))

df_sample_bigrams_filtered <- df_sample_bigrams_sep |>
  filter(!word1 %in% stopwords_en$word) |>
  filter(!word2 %in% stopwords_en$word)

df_sample_bigram_counts <- df_sample_bigrams_filtered |> 
  count(word1, word2, sort = TRUE)

## bi-gram graph
df_sample_bigram_graph <- df_sample_bigram_counts |> 
  filter(n >= 2) |> 
  graph_from_data_frame()

df_sample_bigram_graph

a <- grid::arrow(type = 'closed', length = unit(.15, 'inches'))

set.seed(8080)

ggraph(df_sample_bigram_graph, layout = "fr") +
  geom_edge_link(
    aes(edge_alpha = n),
    show.legend = FALSE,
    arrow = a,
    end_cap = circle(.07, 'inches')
  ) +
  geom_node_point(color = "#000000",
                  alpha = 0.85,
                  size = 3) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  labs(
    title = "",
    subtitle = " ",
    caption = ""
  ) +
  theme(text = element_text(family = 'Consolas'),
        plot.title = element_text(face = 'bold')
)

# ...
