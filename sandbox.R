# Starting to explore the data 

# Data is from Kaggle https://www.kaggle.com/therohk/million-headlines

library(data.table)
library(tidyverse)
library(ggplot2)
library(tidytext)

raw.data = fread('abcnews-date-text.csv')
head(raw.data)
df = raw.data
df$publish_date = as.Date(as.character(df$publish_date),'%Y%m%d')

text_df = df %>%
  unnest_tokens(word, headline_text)

nrow(text_df) # 6902242 ~ roughly 6.9 Million words!
