################################################################################
# Title: Most common words spoken by Aang, Katara and Sokka
# Author: @pedro_drocha
# Purpose: TidyTuesday Visualization - Week 33 - Avatar: The last airbender
# Date: 11-08-2020
################################################################################

# Packages ---------------------------------------------------------------------
library(tidyverse) # ggplot2 et. al.
library(tidytext)  # For textmining
library(stopwords) # For antijoining stopwords
library(patchwork) # for ploting
library(ggtext) # for labels in markdown
library(pdftools) # for saving the plot

# Data import ------------------------------------------------------------------
tuesdata <- tidytuesdayR::tt_load(2020, week = 33)
avatar <- tuesdata$avatar


# Tokenizing  ------------------------------------------------------------------
avatar %>% 
  filter(character != "Scene Description") %>% 
  select(-full_text, -writer,-director) %>%  
  unnest_tokens(word,character_words) %>% 
  anti_join(.,stop_words) -> avatar_tokens


# Water  -----------------------------------------------------------------------

`%notin%` <- negate(`%in%`)


avatar_tokens %>% 
  filter(book == "Water", 
         character %in% c("Aang","Katara","Sokka")) %>% 
  filter(word %notin% c("hey","guys","yeah")) %>% 
  mutate(character = str_to_upper(character)) %>% 
  group_by(character,word) %>% 
  count() %>% 
  ungroup() %>% 
  group_by(character) %>% 
  arrange(desc(n)) %>% 
  top_n(5) %>% 
  ggplot(aes(x = word, y = n, fill = character)) +
  geom_col() +
  labs(title = "**Water**") +
  facet_wrap(~character, scales = "free_x") +
  scale_fill_avatar(palette = "WaterTribe") +
  theme_avatar() +
  theme(legend.position = "None",
        axis.title = element_blank(),
        plot.title = element_markdown(hjust = .5,
                                      color ="grey20",
                                      family =  "Candara")) -> water


# Earth  -----------------------------------------------------------------------
avatar_tokens %>% 
  filter(book == "Earth", 
         character %in% c("Aang","Katara","Sokka")) %>% 
  filter(word %notin% c("hey","guys","yeah")) %>% 
  mutate(character = str_to_upper(character)) %>% 
  group_by(character,word) %>% 
  count() %>% 
  ungroup() %>% 
  group_by(character) %>% 
  arrange(desc(n)) %>% 
  top_n(5) %>% 
  ggplot(aes(x = word, y = n, fill = character)) +
  geom_col() +
  labs(title = "**Earth**") +
  facet_wrap(~character, scales = "free_x") +
  scale_fill_avatar(palette = "EarthKingdom") +
  theme_avatar() +
  theme(legend.position = "None",
        axis.title = element_blank(),
        plot.title = element_markdown(hjust = .5,
                                      color ="grey20",
                                      family =  "Candara")) -> earth
# Fire  ------------------------------------------------------------------------

avatar_tokens %>% 
  filter(book == "Fire", 
         character %in% c("Aang","Katara","Sokka")) %>% 
  filter(word %notin% c("hey","guys","yeah","gonna")) %>% 
  mutate(character = str_to_upper(character)) %>% 
  group_by(character,word) %>% 
  count() %>% 
  ungroup() %>% 
  group_by(character) %>% 
  arrange(desc(n)) %>% 
  top_n(5) %>% 
  ggplot(aes(x = word, y = n, fill = character)) +
  geom_col() +
  labs(title = "**Fire**") +
  facet_wrap(~character, scales = "free_x") +
  scale_fill_avatar() +
  theme_avatar() +
  theme(legend.position = "None",
        axis.title = element_blank(),
        plot.title = element_markdown(hjust = .5,
                                      color ="grey20",
                                      family =  "Candara")) -> fire

# Patchwork --------------------------------------------------------------------

plot <- wrap_elements(water) / wrap_elements(earth) / wrap_elements(fire) +
  plot_annotation(title = "Most common words spoken by **Aang**, **Katara** and **Sokka**",
                  subtitle = "_By book of Avatar: The Last Airbender_",
                  caption = "TidyTuesday #33  |  @pedro_drocha  |  Data: Avery Robbins") &
  theme_avatar(text.font = "Candara",
               title.size = 16, subtitle.size = 14) &
  theme(legend.position = "None",
        axis.title = element_blank(),
        plot.title = element_markdown(color = "grey20"),
        plot.subtitle = element_markdown(),
        plot.caption = element_markdown(hjust = .5))

# Saving -----------------------------------------------------------------------


ggsave("11-08-2020_Avatar/plot/11-08-2020_Avatar.pdf",
       height = 8.58,
       width = 6.11,
       plot = plot,
       device = cairo_pdf)

pdf_convert(pdf = "11-08-2020_Avatar/plot/11-08-2020_Avatar.pdf",
            filenames = "11-08-2020_Avatar/plot/11-08-2020_Avatar.png",
            format = "png", dpi = 400)

  