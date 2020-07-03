library(sf)
library(tidyverse)

# border data: https://www.tallinn.ee/est/ehitus/Tallinna-linnaosade-ja-asumite-piirid
df_TLN <- st_read("asumid/t02_41_asum.shp")

#lave out Aegna saar (sorry Aegna but you're too far and too uninhabited) 
df_TLN <- df_TLN %>%
  filter(asumi_nimi != "Aegna") %>%
  select(asumi_nimi, linnaosa_n, geometry)

# population size data: https://www.tallinn.ee/est/Tallinn-arvudes
df_TLN <- df_TLN %>%
  left_join(read_csv("pindala_ja_rahvaarv.csv"),
            by = c('asumi_nimi' = 'asum')) %>%
  mutate(pop_density = rahvaarv/pindala)

ggplot(df_TLN) +
  geom_sf(aes(fill = pop_density))
