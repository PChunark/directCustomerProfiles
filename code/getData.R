library(tidyverse)
library(fs)
library(readxl)
library(openxlsx)

# Rearrange file names each month
file_path <- 
  tibble(filename = list.files("rawData/",
                                          pattern = "Coincident",
                                          full.names = F)) %>% 
  mutate(filepath = paste0("rawData/", filename)) %>% 
  separate(col = filename, into = c("name1","file"), sep = "_") %>% 
  separate(col = file, into = c("month","filetype"), sep = " ") %>%
  separate(col = filetype, into = c("year","filetypes"), sep = ".x") %>% 
  mutate(month = factor(month, levels = month.name)) %>% 
  arrange(year, month) %>% 
  pull(filepath)

# get data from a "Data Direct" sheet
data1 <-
  file_path %>%
  map(function(path){
    read_excel(path, 
               sheet = "Data Direct",
               skip = 3
               )  
  }%>% 
  select(1:9) %>% 
  drop_na()
  )

# Combine monthly data to yearly data
data2 <-
  data1 %>% reduce(full_join, by = c(colnames(.)))

plot.ts(ts(data2, frequency = 48))
plot.ts(log(ts(data2, frequency = 48)))

data3 <-
  data2 %>% 
  pi
