library(tidyverse)

setwd("/Users/brian/dev/github.com/weather-effect/data/")

load(file="AllPitchingData.RData")


#
#  Chris Sale
#

ggplot(AllPitchingData %>%
         filter(player_name == 'Chris Sale', pitch_type == 'FT') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))

ggplot(AllPitchingData %>%
         filter(player_name == 'Chris Sale', pitch_type == 'FF') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))


ggplot(AllPitchingData %>%
         filter(player_name == 'Chris Sale', pitch_type == 'CH') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))


ggplot(AllPitchingData %>%
         filter(player_name == 'Chris Sale', pitch_type == 'SL') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))

#
#  Carlos Carrasco
#

ggplot(AllPitchingData %>%
         filter(player_name == 'Carlos Carrasco', pitch_type == 'FT') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))

ggplot(AllPitchingData %>%
         filter(player_name == 'Carlos Carrasco', pitch_type == 'FF') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))


ggplot(AllPitchingData %>%
         filter(player_name == 'Carlos Carrasco', pitch_type == 'CH') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))


ggplot(AllPitchingData %>%
         filter(player_name == 'Carlos Carrasco', pitch_type == 'SL') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))

#
#  Everyone
#

ggplot(AllPitchingData %>%
         filter(pitch_type == 'SI') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.9,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))

ggplot(AllPitchingData %>%
         filter(pitch_type == 'FF') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.9,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))

ggplot(AllPitchingData %>%
         filter(pitch_type == 'FC') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.9,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))

ggplot(AllPitchingData %>%
         filter(pitch_type == 'CH') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.9,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))
