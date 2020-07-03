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

x_cent <- mean(c(531228.4, 552564.1))
y_cent <- mean(c(6579473, 6595898))
marg <- 10000

ggplot(df_TLN) +
  geom_sf(aes(fill = pop_density), 
          colour = NA) +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_rect(fill = "#242424"),
        plot.background = element_rect(fill = "#242424"),
        legend.background = element_rect(fill = "#242424"),
        legend.position = c(.85, .2),
        legend.title = element_text(colour = "White"),
        legend.text = element_text(colour = "White"),
        plot.title = element_text(colour = "White")) + 
  scale_fill_gradient(low = "#121212",
                       high = "#AF1B3F",
                      name = bquote(''*'People per ' ~ km^2*'')) +
  xlim(x_cent - marg, x_cent + marg) +
  ylim(y_cent - marg, y_cent + marg) 

ggsave("TALLINN.png",
       width = 8, height = 8)
