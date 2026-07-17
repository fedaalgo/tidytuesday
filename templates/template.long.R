# --- tidytuesday::yyww --- #
# https://github.com/rfordatascience/tidytuesday/tree/master/data/2024/...

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
  ggraph, # https://cran.r-project.org/web/packages/ggraph/
  igraph, # https://cran.r-project.org/web/packages/igraph/
  janitor, # https://cran.r-project.org/web/packages/janitor/
  skimr, # https://cran.r-project.org/web/packages/skimr/
  stopwords, # https://cran.r-project.org/web/packages/stopwords/
  styler, # https://cran.r-project.org/web/packages/styler/
  tidytext, # https://cran.r-project.org/web/packages/tidytext/
  tidyverse, # https://cran.r-project.org/web/packages/tidyverse/
  wordcloud2  # https://cran.r-project.org/web/packages/wordcloud2/
)

# import
df <-
  fread(
    'link.csv'
  ) |>
  clean_names()

# understand ----

# names
df |> 
  slice(0) |> 
  glimpse()

# glimpse & skim
df |>
  glimpse() |>
  skim()

# tokenize
stopwords_en.us <-
  data.frame(word = stopwords(language = "en")) |>
  rbind(data.frame(
    word = c(
      ""
    )
  )
)

stopwords_es.sv <-
  data.frame(word = stopwords(language = "es")) |>
  rbind(data.frame(
    word = c(
      "dar",
      "dos",
      "pueden"
    )
  )
)

df |>
  unnest_tokens(output = word, input = abstract) |>
  anti_join(stopwords_en.us, by = "word") |>
  anti_join(stopwords_es.sv, by = "word") |>
  filter(nchar(word) >= 3) |> 
  group_by(word) |>
  summarise(n = n()) |>
  arrange(desc(n))

# visualise ----

# wordcloud
df |>
  unnest_tokens(output = word, input = abstract) |>
  anti_join(stopwords_en.us, by = "word") |>
  anti_join(stopwords_es.sv, by = "word") |>
  filter(nchar(word) >= 3) |> 
  group_by(word) |>
  summarise(n = n()) |>
  arrange(desc(n)) |> 
  wordcloud2(
    backgroundColor = "#ffffff",
    color = "#9d0006",
    fontFamily = 'Arial',
    rotateRatio = 0,
    shape = 'circle'
)

# bi-gram
df |> 
  select(abstract) |> 
  unnest_ngrams(word, abstract, n = 2) |> 
  group_by(word) |> 
  filter(nchar(word) >= 3) |> 
  summarise(n = n()) |> 
  arrange(desc(n))

## objects
df_bigrams <- 
  df |> 
  select(abstract) |> 
  filter(!is.na(abstract)) |>
  filter(str_trim(abstract) != "") |>
  unnest_ngrams(word, abstract, n = 2)

df_bigrams_sep <- 
  df_bigrams |> 
  separate(word, c("word1", "word2"), sep = " ") |>
  filter(!is.na(word1) & !is.na(word2))

df_bigrams_filtered <- df_bigrams_sep |>
  filter(!word1 %in% stopwords_es.sv$word) |>
  filter(!word2 %in% stopwords_es.sv$word) |> 
  filter(!word1 %in% stopwords_en.us$word) |>
  filter(!word2 %in% stopwords_en.us$word)

df_bigram_counts <- df_bigrams_filtered |> 
  count(word1, word2, sort = TRUE)

## bi-gram graph
df_bigram_graph <- df_bigram_counts |> 
  filter(n >= 2) |> 
  graph_from_data_frame()

df_bigram_graph

a <- grid::arrow(type = 'closed', length = unit(.15, 'inches'))

set.seed(8080)

ggraph(df_bigram_graph, layout = "fr") +
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
    title = "bi-grama general",
    subtitle = " ",
    caption = "la saturación de las flechas indica el nivel de recurrencia"
  ) +
  theme(text = element_text(family = 'Consolas'),
        plot.title = element_text(face = 'bold')
)

# ...
