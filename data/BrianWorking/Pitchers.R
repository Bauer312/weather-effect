load(file="Pitching.RData")

sale_density_movement <- redsox %>%
  filter(player_name == 'Chris Sale') %>%
  group_by(pitch_type, density_bucket) %>%
  summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2)))

z_britton_bal <- orioles %>%
  filter(player_name == 'Zack Britton') %>%
  group_by(pitch_type, density_bucket) %>%
  summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2)))

z_britton <- rbind(yankees,orioles) %>%
  group_by(density_bucket,pitch_type,home_team) %>%
  summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2)))

y_group <- yankees %>% group_by(density_bucket,pitch_type) %>%
  summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2)))
ggplot(y_group, aes(density_bucket)) + 
  geom_line(aes(y = humidity_percent / 20, colour = "humidity_percent")) +
  geom_line(aes(y = temp_celcius / 2, colour = "temp_celcius")) +
  geom_line(aes(y = air_density, colour = "air_density")) +
  geom_line(aes(y = pressure_mmhg / 50, colour = "pressure_mmhg"))

plot_pitch_movement <- function(team, pitcher, pt) {
  ggplot(team %>%
           filter(player_name == pitcher, pitch_type == pt) %>%
           group_by(density_bucket) %>%
           summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
         aes(x=density_bucket,y=Movement)) +
    geom_point() +
    geom_smooth() +
    scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
    scale_y_continuous("Movement",limits=c(0,3))
}

plot_pitch_movement(redsox,"Chris Sale","FT")


all_pitches <- rbind(orioles,nationals,athletics,indians,mets,
                      rockies,redsox,yankees,tigers,mariners,
                      braves,padres,cardinals) %>% mutate(density_bucket = case_when(air_density < 1.0 ~ 1,
                                                                             air_density < 1.05 ~ 1.05,
                                                                             air_density < 1.1 ~ 1.1,
                                                                             air_density < 1.15 ~ 1.15,
                                                                             air_density < 1.2 ~ 1.2,
                                                                             air_density >= 1.2 ~ 1.25))
c_pitcher <- all_pitches %>% group_by(player_name) %>% summarise(count = n())

all_pitches %>%
  filter(player_name == 'Carlos Carrasco') %>%
  group_by(pitch_type, density_bucket) %>%
  summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2)))


ggplot(all_pitches %>%
         filter(player_name == 'Carlos Carrasco', pitch_type == 'FT') %>%
         group_by(density_bucket) %>%
         summarize(Movement = mean(sqrt(as.numeric(pfx_x)^2 + as.numeric(pfx_z)^2))),
       aes(x=density_bucket,y=Movement)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Movement",limits=c(0,3))
