library(tidyverse)

setwd("/Users/brian/dev/github.com/weather-effect/data/")

load(file="BallsInPlay.RData")

#
#  Correlation Between Weather Measurements
#

BallsInPlayCorrelation <- BallsInPlay %>% group_by(play_date,home_team) %>%
  summarise(density = mean(air_density),
            temp = mean(temp_celcius),
            humidity = mean(humidity_percent),
            pressure = mean(pressure_mmhg))
pairs(BallsInPlayCorrelation[,c(3:6)], lower.panel = NULL)


#
#  Mean intragame air density
#

plot_avg_density <- function(data_set) {
  ggplot(data_set %>%
           group_by(game_date) %>%
           summarise(density = mean(air_density)), aes(game_date, density)) + 
    geom_point() +
    geom_smooth()
}

plot_avg_density(BallsInPlay %>% filter(home_team == "STL"))
plot_avg_density(BallsInPlay %>% filter(home_team == "SEA"))
plot_avg_density(BallsInPlay %>% filter(home_team == "BAL"))
plot_avg_density(BallsInPlay %>% filter(home_team == "MIA"))
plot_avg_density(BallsInPlay %>% filter(home_team == "COL"))
plot_avg_density(BallsInPlay %>% filter(home_team == "BOS"))

#
#  Average hard-hit fly ball distance
#

HardHitFlyBalls <- BallsInPlay %>%
  mutate(distance = as.numeric(hit_distance_sc)) %>%
  filter(distance > 0, as.numeric(launch_speed) > 95,
         bb_type == 'fly_ball') %>%
  mutate(density_bucket = case_when(air_density < 1.0 ~ 1,
                                    air_density < 1.05 ~ 1.05,
                                    air_density < 1.1 ~ 1.1,
                                    air_density < 1.15 ~ 1.15,
                                    air_density < 1.2 ~ 1.2,
                                    air_density >= 1.2 ~ 1.25))

ggplot(HardHitFlyBalls, aes(x=air_density,y=distance)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.95,1.3)) +
  scale_y_continuous("Fly Ball Distance",limits=c(175,525))

#
#  Average home run distance
#

HomeRuns <- BallsInPlay %>%
  mutate(distance = as.numeric(hit_distance_sc)) %>%
  filter(events == 'home_run') %>%
  mutate(density_bucket = case_when(air_density < 1.0 ~ 1,
                                    air_density < 1.05 ~ 1.05,
                                    air_density < 1.1 ~ 1.1,
                                    air_density < 1.15 ~ 1.15,
                                    air_density < 1.2 ~ 1.2,
                                    air_density >= 1.2 ~ 1.25))

ggplot(HomeRuns, aes(x=air_density,y=distance)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.95,1.3)) +
  scale_y_continuous("Fly Ball Distance",limits=c(175,525))


#
#  Home Runs per game by air density
#

HomeRunsPerGame <- HomeRuns %>% 
  group_by(density_bucket,home_team,game_date) %>% summarise(hrs = length(game_date)) %>% 
  group_by(density_bucket) %>% summarise(hr_per_game = mean(hrs))
ggplot(HomeRunsPerGame, aes(x=density_bucket,y=hr_per_game)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.95,1.3)) +
  scale_y_continuous("Home Runs per Game",limits=c(0,4))


#
#  Predict Home Run Distance
#

ModelGroup <- list("BAL","WAS","OAK","CLE","NYM","SF","COL",
                   "DET","SEA","KC","CHC",
                   "MIN","LAD","CWS","STL")
ControlGroup <- list("BOS","NYY","PHI","SD","ATL")

ModelBallsInPlay <- BallsInPlay %>% filter(home_team %in% ModelGroup) %>%
  filter(events == 'home_run') %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_a = as.numeric(launch_angle),
         l_s = as.numeric(launch_speed),
         l_sa = as.numeric(launch_speed_angle)) %>%
  filter(l_a > 0,distance > 0)

ControlBallsInPlay <- BallsInPlay %>% filter(home_team %in% ControlGroup) %>%
  filter(events == 'home_run') %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_a = as.numeric(launch_angle),
         l_s = as.numeric(launch_speed),
         l_sa = as.numeric(launch_speed_angle)) %>%
  filter(l_a > 0,distance > 0)

PredictionModel <- lm(distance ~ l_a+l_s+l_sa+air_density,
                      data=ModelBallsInPlay, x=TRUE )

ControlBallsInPlay$est <- predict(PredictionModel, ControlBallsInPlay)

DistanceDiff <- ControlBallsInPlay %>% 
  mutate(diff = abs(est - distance),
         density_bucket = case_when(air_density <= 0.95 ~ 0.95,
                                    air_density <= 1.0 ~ 1,
                                    air_density <= 1.05 ~ 1.05,
                                    air_density <= 1.1 ~ 1.1,
                                    air_density <= 1.15 ~ 1.15,
                                    air_density <= 1.2 ~ 1.2,
                                    air_density <= 1.25 ~ 1.25,
                                    air_density >= 1.25 ~ 1.3))

ggplot(DistanceDiff, aes(x=air_density,y=diff)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Model diff from MLB",limits=c(0,50))

#
# What would happen if all Fenway Park hits had happened on
#   June 10th in Colorado (air density of 0.9478296)?
#
AllBallsInPlay <- BallsInPlay %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_a = as.numeric(launch_angle),
         l_s = as.numeric(launch_speed),
         l_sa = as.numeric(launch_speed_angle)) %>%
  filter(l_a > 0,distance > 250)
PredictionModel <- lm(distance ~ l_a+l_s+l_sa+air_density,
                      data=AllBallsInPlay, x=TRUE )
BostonBallsInPlay <- AllBallsInPlay %>%
  filter(home_team == "BOS") %>%
  mutate(air_density = 0.9478296)

BostonBallsInPlay$est <- predict(PredictionModel, BostonBallsInPlay)
BostonDistanceDiff <- BostonBallsInPlay %>% 
  mutate(diff = abs(est - distance))

ggplot(BostonBallsInPlay, aes(x=distance,y=est)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Original Distance",limits=c(250,500)) +
  scale_y_continuous("Model Distance",limits=c(250,500))
