library(tidyverse)
library(fs)
library(readxl)
library(openxlsx)

file_path <- 
  tibble(filename = list.files("rawData/",
                                          pattern = "*2023",
                                          full.names = F)) %>% 
  mutate(filepath = paste0("rawData/", filename)) %>% 
  separate(col = filename, into = c("name1","file"), sep = "_") %>% 
  separate(col = file, into = c("month","filetype"), sep = " ") %>% 
  mutate(month = factor(month, levels = month.name)) %>% 
  arrange(month) %>% 
  pull(filepath)

data1 <-
  file_path %>%
  map(function(path){
    read_excel(path, 
               sheet = "Data Direct",
               skip = 3,
               # range = cell_cols("A:AE"),
               col_names = T,
               .name_repair = "minimal")  #Choose column 1 to 30 
    
  } %>% drop_na()
  )