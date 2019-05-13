library(tidyverse)

setwd("/Users/brian/dev/github.com/weather-effect/data/")

load(file="BallsInPlay.RData")

BallsInPlayCorrelation <- BallsInPlay %>% group_by(play_date,home_team) %>%
  summarise(density = mean(air_density),
            temp = mean(temp_celcius),
            humidity = mean(humidity_percent),
            pressure = mean(pressure_mmhg))
pairs(BallsInPlayCorrelation[,c(3:6)], lower.panel = NULL)
