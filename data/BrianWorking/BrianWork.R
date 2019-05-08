library(tidyverse)

setwd("/Users/brian/dev/github.com/weather-effect/data/BrianWorking/")
#setwd("F:\\Baseball")

#ip_selected_teams <- read_csv("selected_home_teams.csv")
#ip_selected_teams %>% saveRDS("ip_selected_teams.rds")
ip_selected_teams <- readRDS("ip_selected_teams.rds")

ip_func <- function(team_name,tz_offset) {
  ip_selected_teams %>% filter(home_team == team_name) %>%
    mutate(play_minutes = floor(as.numeric(play_time) / 1000)*1000, 
           sv_date = as.numeric(play_date),
           month = floor((as.numeric(play_date) - 20180000)/100),
           hour = floor(as.numeric(play_time)/10000)+tz_offset)
}

ip_bal <- ip_func("BAL",-4)
ip_bos <- ip_func("BOS",-4)
ip_nyy <- ip_func("NYY",-4)
ip_oak <- ip_func("OAK",-7)
ip_cle <- ip_func("CLE",-4)
ip_det <- ip_func("DET",-4)
ip_sea <- ip_func("SEA",-7)
ip_nym <- ip_func("NYM",-4)
ip_was <- ip_func("WSH",-4)
ip_col <- ip_func("COL",-6)
ip_tex <- ip_func("TEX",-5)
ip_atl <- ip_func("ATL",-4)
ip_sd <- ip_func("SD",-7)
ip_sf <- ip_func("SF",-7)
ip_stl <- ip_func("STL",-5)
ip_min <- ip_func("MIN",-5)
ip_mia <- ip_func("MIA",-4)
ip_phi <- ip_func("PHI",-4)
ip_lad <- ip_func("LAD",-7)
ip_cws <- ip_func("CWS",-5)
ip_chc <- ip_func("CHC",-5)
ip_hou <- ip_func("HOU",-5)
ip_kc <- ip_func("KC",-5)

wx_bal <- read_csv("BaltimoreNOAA.csv")  # MARYLAND SCIENCE CENTER ==> 0.591354 miles from stadium
wx_bos <- read_csv("BostonNOAA.csv")  # BOSTON ==> 4.594463 miles from stadium
wx_nyy <- read_csv("NewYorkYankeesNOAA.csv")  # NY CITY CENTRAL PARK ==> 4.133639 miles from stadium
wx_cle <- read_csv("ClevelandNOAA.csv")  # CLEVELAND BURKE LAKEFRONT AIRPORT ==> 1.501178 miles from stadium
wx_det <- read_csv("DetroitNOAA.csv")  # DETROIT CITY AIRPORT ==> 5.228701 miles from stadium
wx_oak <- read_csv("OaklandNOAA.csv")  # OAKLAND METROPOLITAN INTERNATIONAL AIRPORT ==> 2.369784 miles from stadium
wx_sea <- read_csv("SeattleNOAA.csv")  # SEATTLE BOEING FIELD ==> 4.477955 miles from stadium
wx_tex <- read_csv("TexasNOAA.csv")  # GRAND PRAIRIE MUNICIPAL AIRPORT ==> 4.212210 miles from stadium
wx_atl <- read_csv("AtlantaNOAA.csv")  # MARIETTA DOBBINS AFB ==> 3.358851 miles from stadium
wx_nym <- read_csv("NewYorkMetsNOAA.csv")  # LA GUARDIA AIRPORT ==> 2.360826 miles from stadium
wx_was <- read_csv("WashingtonNOAA.csv")  # WASHINGTON REAGAN NATIONAL AIRPORT ==> 2.291573 miles from stadium
wx_col <- read_csv("ColoradoNOAA.csv")  # DENVER CENTENNIAL AIRPORT ==> 15.002200 miles from airport
wx_sd <- read_csv("SanDiegoNOAA.csv")  # SAN DIEGO INTERNATIONAL AIRPORT ==> 2.386480 miles from airport
wx_stl <- read_csv("StLouisNOAA.csv")  # CAHOKIA ST LOUIS DOWNTOWN AIRPORT ==> 4.031299 miles from stadium
wx_min <- read_csv("MinnesotaNOAA.csv")  # MINNEAPOLIS CRYSTAL AIRPORT ==> 6.607058 miles from stadium
wx_mia <- read_csv("MiamiNOAA.csv")  # MIAMI INTERNATIONAL AIRPORT ==> 6.092389 miles from stadium
wx_phi <- read_csv("PhiladelphiaNOAA.csv")  # PHILADELPHIA INTERNATIONAL AIRPORT ==> 3.917441 miles from stadium
wx_lad <- read_csv("LosAngelesDodgersNOAA.csv")  # LOS ANGELES DOWNTOWN USC ==> 4.532504 miles from stadium

fm15 <- function(wx_orig) {
  wx_orig %>% filter(report_type == "FM-15", humidity_percent > 0, humidity_percent < 100) %>%
    mutate(play_minutes = as.numeric(sv_time))
}
wx2_sf <- read_csv("sf.csv") %>% filter(Humidity > 0) %>%
  mutate(play_minutes = floor(as.numeric(sv_id_tm) / 1000)*1000,
         pressure_mmhg = BarometricPressure_mmHg * 25.4,
         sv_date = sv_id_dt, humidity_percent = Humidity,
         temp_celcius = Temp_C, wind_direction = WindDirAvg,
         wind_speed_meters_per_second = Windspeed * 0.44704)
wx2_kc <- read_csv("kc.csv") %>% filter(Humidity > 0) %>%
  mutate(play_minutes = floor(as.numeric(sv_id_tm) / 1000)*1000,
         pressure_mmhg = BarometricPressure_mmHg * 25.4,
         sv_date = sv_id_dt, humidity_percent = Humidity,
         temp_celcius = Temp_C, wind_direction = WindDirAvg,
         wind_speed_meters_per_second = Windspeed * 0.44704)
wx2_cws <- read_csv("whitesox.csv") %>% filter(Humidity > 0) %>%
  mutate(play_minutes = floor(as.numeric(sv_id_tm) / 1000)*1000,
         pressure_mmhg = BarometricPressure_mmHg * 25.4,
         sv_date = sv_id_dt, humidity_percent = Humidity,
         temp_celcius = Temp_C, wind_direction = WindDirAvg,
         wind_speed_meters_per_second = Windspeed * 0.44704)
wx2_chc <- read_csv("cubs.csv") %>% filter(Humidity > 0) %>%
  mutate(play_minutes = floor(as.numeric(sv_id_tm) / 1000)*1000,
         pressure_mmhg = BarometricPressure_mmHg * 25.4,
         sv_date = sv_id_dt, humidity_percent = Humidity,
         temp_celcius = Temp_C, wind_direction = WindDirAvg,
         wind_speed_meters_per_second = Windspeed * 0.44704)
wx2_col2 <- read_csv("den.csv") %>% filter(Humidity > 0) %>%
  mutate(play_minutes = floor(as.numeric(sv_id_tm) / 1000)*1000,
         pressure_mmhg = BarometricPressure_mmHg * 25.4,
         sv_date = sv_id_dt, humidity_percent = Humidity,
         temp_celcius = Temp_C, wind_direction = WindDirAvg,
         wind_speed_meters_per_second = Windspeed * 0.44704)
wx2_hou <- read_csv("hou.csv") %>% filter(Humidity > 0) %>%
  mutate(play_minutes = floor(as.numeric(sv_id_tm) / 1000)*1000,
         pressure_mmhg = BarometricPressure_mmHg * 25.4,
         sv_date = sv_id_dt, humidity_percent = Humidity,
         temp_celcius = Temp_C, wind_direction = WindDirAvg,
         wind_speed_meters_per_second = Windspeed * 0.44704)


wx2_bal <- fm15(wx_bal)
wx2_bos <- fm15(wx_bos)
wx2_nyy <- fm15(wx_nyy)
wx2_cle <- fm15(wx_cle)
wx2_det <- fm15(wx_det)
wx2_oak <- fm15(wx_oak)
wx2_sea <- fm15(wx_sea)
wx2_tex <- fm15(wx_tex)
wx2_atl <- fm15(wx_atl)
wx2_nym <- fm15(wx_nym)
wx2_was <- fm15(wx_was)
wx2_col <- fm15(wx_col)
wx2_sd <- fm15(wx_sd)
wx2_stl <- fm15(wx_stl)
wx2_min <- fm15(wx_min)
wx2_mia <- fm15(wx_mia)
wx2_phi <- fm15(wx_phi)
wx2_lad <- fm15(wx_lad)

join_wx <- function(team_plays,team_wx) {
  team_plays %>%
    left_join(team_wx,by=c("sv_date"="sv_date","play_minutes"="play_minutes")) %>%
    filter(pressure_mmhg > 0)
}
join_wx2 <- function(team_plays,team_wx) {
  team_wx %>%
    left_join(team_plays,by=c("sv_date"="sv_date","play_minutes"="play_minutes")) %>%
    filter(pressure_mmhg > 0)
}

bal_wx <- join_wx(ip_bal,wx2_bal)
bal_wx_all <- join_wx2(ip_bal,wx2_bal) %>%
  mutate(elevation_ft = 36) %>%
  filter(humidity_percent < 100 & humidity_percent > 0)

bos_wx <- join_wx(ip_bos,wx2_bos)
bos_wx_all <- join_wx2(ip_bos,wx2_bos) %>%
  mutate(elevation_ft = 16) %>%
  filter(humidity_percent < 100 & humidity_percent > 0)

nyy_wx <- join_wx(ip_nyy,wx2_nyy)
nyy_wx_all <- join_wx2(ip_nyy,wx2_nyy) %>%
  mutate(elevation_ft = 33) %>%
  filter(humidity_percent < 100 & humidity_percent > 0)

cle_wx <- join_wx(ip_cle,wx2_cle)
cle_wx_all <- join_wx2(ip_cle,wx2_cle) %>%
  mutate(elevation_ft = 653) %>%
  filter(humidity_percent < 100 & humidity_percent > 0)

det_wx <- join_wx(ip_det,wx2_det)
oak_wx <- join_wx(ip_oak,wx2_oak)
sea_wx <- join_wx(ip_sea,wx2_sea)
tex_wx <- join_wx(ip_tex,wx2_tex)
atl_wx <- join_wx(ip_atl,wx2_atl)
nym_wx <- join_wx(ip_nym,wx2_nym)
was_wx <- join_wx(ip_was,wx2_was)
col_wx <- join_wx(ip_col,wx2_col)
sd_wx <- join_wx(ip_sd,wx2_sd)
stl_wx <- join_wx(ip_stl,wx2_stl)
min_wx <- join_wx(ip_min,wx2_min)
mia_wx <- join_wx(ip_mia,wx2_mia)
phi_wx <- join_wx(ip_phi,wx2_phi)
lad_wx <- join_wx(ip_lad,wx2_lad)
sf_wx <- join_wx(ip_sf,wx2_sf)
kc_wx <- join_wx(ip_kc,wx2_kc)
cws_wx <- join_wx(ip_cws,wx2_cws)
chc_wx <- join_wx(ip_chc,wx2_chc)
hou_wx <- join_wx(ip_hou,wx2_hou)


svp <- function(temp_celcius) {
  4.5841 * (2.71828 ^ (((18.687 - (temp_celcius/234.5)) * temp_celcius) / (257.14 + temp_celcius)))
}

air_pressure <- function(temp_celcius,bp_mmHg_sea_level,altitude_ft) {
  bp_mmHg_sea_level * (2.71828 ^ ((-9.80665*0.0289644*altitude_ft*0.3048)/(8.31447*(temp_celcius+273.15))))
}

air_density <- function(temp_celcius,air_pressure_mmHg,svp_mmHg,humidity_percent) {
  1.2929 * (273/(temp_celcius+273)) * ((air_pressure_mmHg - (0.379 * svp_mmHg * humidity_percent / 100))/760)
}

bal_wx2 <- bal_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
bal_wx2_all <- bal_wx_all %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))

was_wx2 <- was_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
oak_wx2 <- oak_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
cle_wx2 <- cle_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
cle_wx2_all <- cle_wx_all %>% mutate(air_density = air_density(temp_celcius,
                                                               air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                               svp(temp_celcius),humidity_percent))

nym_wx2 <- nym_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
col_wx2 <- col_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
bos_wx2 <- bos_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
bos_wx2_all <- bos_wx_all %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
nyy_wx2 <- nyy_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
nyy_wx2_all <- nyy_wx_all %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
det_wx2 <- det_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
sea_wx2 <- sea_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
tex_wx2 <- tex_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
atl_wx2 <- atl_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
sd_wx2 <- sd_wx %>% mutate(air_density = air_density(temp_celcius,
                                                     air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                     svp(temp_celcius),humidity_percent))
stl_wx2 <- stl_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
min_wx2 <- min_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
mia_wx2 <- mia_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
phi_wx2 <- phi_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
lad_wx2 <- lad_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
chc_wx2 <- chc_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
cws_wx2 <- cws_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
hou_wx2 <- hou_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
sf_wx2 <- sf_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))
kc_wx2 <- kc_wx %>% mutate(air_density = air_density(temp_celcius,
                                                       air_pressure(temp_celcius,pressure_mmhg,elevation_ft),
                                                       svp(temp_celcius),humidity_percent))

final_columns <- function(joined_table) {
  joined_table %>% select(pitch_type,game_date,batter,stand,pitcher,player_name,events,
                          description,home_team,away_team,hit_location,bb_type,inning,
                          inning_topbot,hit_distance_sc,launch_speed,launch_angle,
                          launch_speed_angle,at_bat_number,pitch_number,pitch_name,
                          plate_x,plate_z,humidity_percent,des,
                          play_date,month,hour,play_time,stadium,elevation_ft,
                          wind_direction, wind_speed_meters_per_second,
                          pressure_mmhg,temp_celcius,air_density)
}
final_columns_test <- function(joined_table) {
  joined_table %>% select(pitch_type,game_date,sv_date,batter,stand,pitcher,player_name,events,
                          description,home_team,away_team,hit_location,bb_type,inning,
                          inning_topbot,hit_distance_sc,launch_speed,launch_angle,
                          launch_speed_angle,at_bat_number,pitch_number,pitch_name,
                          plate_x,plate_z,humidity_percent,des,
                          play_date,month,hour,play_time,stadium,elevation_ft,
                          wind_direction, wind_speed_meters_per_second,
                          pressure_mmhg,temp_celcius,air_density)
}

KC <- final_columns(kc_wx2)
MIA <- final_columns(mia_wx2)
BAL <- final_columns(bal_wx2)
BAL_ALL <- final_columns_test(bal_wx2_all)
BOS <- final_columns(bos_wx2)
BOS_ALL <- final_columns(bos_wx2_all)
NYY <- final_columns(nyy_wx2)
NYY_ALL <- final_columns(nyy_wx2_all)
CLE <- final_columns(cle_wx2)
CLE_ALL <- final_columns(cle_wx2_all)
DET <- final_columns(det_wx2)
OAK <- final_columns(oak_wx2)
SEA <- final_columns(sea_wx2)
TEX <- final_columns(tex_wx2)
ATL <- final_columns(atl_wx2)
NYM <- final_columns(nym_wx2)
WAS <- final_columns(was_wx2)
COL <- final_columns(col_wx2)
SD <- final_columns(sd_wx2)
STL <- final_columns(stl_wx2)
MIN <- final_columns(min_wx2)
PHI <- final_columns(phi_wx2)
LAD <- final_columns(lad_wx2)
SF <- final_columns(sf_wx2)
CWS <- final_columns(cws_wx2)
CHC <- final_columns(chc_wx2)
HOU <- final_columns(hou_wx2)
save(KC, MIA,BAL,BOS,NYY,CLE,DET,OAK,SEA,ATL,
     NYM,WAS,COL,SD,STL,MIN,PHI,LAD,SF,CWS,CHC,HOU,
     file="../Teams.RData")

# Input
# corner of home plate z-axis = height y-axis = line between home plate and 2nd base  x-axis perpendicular to other axis 
# x0		= (ft)   horizontal distance from center of home plate
# y0		= (ft)   distance from corner of home plate on y-axis   may assume middle of plate or half length of home plate
# z0		= (ft)   vertical distance from ground
# v0 		= (ft/s) exit speed
# sign  	= 1 if righty and -1 if lefty
# theta 	= (deg) launch angle
# r 		= (ft) total disatance traveled by by ball from home plate that you want to know the height (z) at 
# phi 	= (deg) the angle between the y-axis (line from 2nd base to home) and the line from the final location and home plate
# temp 	= (C) temperature
# pressure 	= (mmg) barometric pressure
# RH 		= (%) relative humidity
# elev 	= (ft) elevation
# vwind 	= (mph) velocity of wind
# phiwind 	= (deg) angle of wind  runs along y-axis   need to account for which direction stadium is facing and use to get wind direction

# traj <- function(x0,y0,z0,v0,sign,theta,r,phi1,temp,pressure,RH,elev,vwind,phiwind){

all_wx2 <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                 COL,BOS,NYY,DET,SEA,KC,
                 CHC,ATL,SD,STL,MIN,HOU,
                 MIA,PHI,LAD,CWS) %>%
  filter(air_density > 0 & air_density < 5,
         as.numeric(hit_distance_sc) > 200,
         humidity_percent > 0 & humidity_percent < 101,
         bb_type != 'ground_ball') %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_angle = as.numeric(launch_angle),
         l_speed = as.numeric(launch_speed))

all_traj100 <- all_wx2 %>% mutate(traj100 = traj(plate_x,2,plate_z,l_speed,
                                  case_when(stand == 'R' ~ 1, stand == 'L' ~ -1),
                                  l_angle,100,0,temp_celcius,pressure_mmhg,
                                  humidity_percent,elevation_ft,0,0))



all_wx2_nohit <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                       COL,BOS,NYY,DET,SEA,KC,
                       CHC,ATL,SD,STL,MIN,HOU,
                       MIA,PHI,LAD,CWS) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         bb_type != 'ground_ball') %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_angle = as.numeric(launch_angle),
         l_speed = as.numeric(launch_speed))

data_nostl <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                    COL,BOS,NYY,DET,SEA,KC,
                    CHC,ATL,SD,MIN,HOU,
                    MIA,PHI,LAD,CWS) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         bb_type != 'ground_ball',
         as.numeric(hit_distance_sc) > 250) %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_angle = as.numeric(launch_angle),
         l_speed = as.numeric(launch_speed)) %>%
  filter(l_angle > 0,distance > 0)
data_stl <- STL %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         bb_type != 'ground_ball',
         as.numeric(hit_distance_sc) > 250) %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_angle = as.numeric(launch_angle),
         l_speed = as.numeric(launch_speed)) %>%
  filter(l_angle > 0,distance > 0)

#all_wx2 %>% write_csv("all_wx2.csv")

july_afternoon <- all_wx2_nohit %>% filter(month == 7, hour > 11 & hour < 16) %>% group_by(home_team) %>% summarise(avg = median(air_density))

july_cmp <- all_wx2_nohit %>% filter(month == 7) %>% group_by(home_team) %>% summarise(ad = mean(air_density), at = mean(temp_celcius))
pairs(july_cmp[,c(2:3)], lower.panel = NULL)
all_cmp <- all_wx2_nohit %>% group_by(play_date,home_team) %>%
  summarise(density = mean(air_density),
            temp = mean(temp_celcius),
            humidity = mean(humidity_percent),
            pressure = mean(pressure_mmhg))
pairs(all_cmp[,c(3:6)], lower.panel = NULL)


august_afternoon <- all_wx2_nohit %>% filter(month == 8, hour > 11 & hour < 16) %>% group_by(home_team) %>% summarise(avg = median(air_density))
july_evening <- all_wx2_nohit %>% filter(month == 7, hour > 16 & hour < 21) %>% group_by(home_team) %>% summarise(avg = median(air_density))
august_evening <- all_wx2_nohit %>% filter(month == 8, hour > 16 & hour < 21) %>% group_by(home_team) %>% summarise(avg = median(air_density))

avg_density <- all_wx2_nohit %>% group_by(home_team,month,hour) %>% summarise(avg = median(air_density))

marine_layer <- all_wx2 %>% filter(humidity_percent > 80,temp_celcius < 21.1) %>% mutate(la = floor(l_angle / 10),ls = floor(l_speed / 10))
no_marine_layer <- all_wx2 %>% filter(humidity_percent < 80 | temp_celcius > 21.1) %>% mutate(la = floor(l_angle / 10),ls = floor(l_speed / 10))

ml_gp <- marine_layer %>% group_by(la,ls) %>% summarise(avg = median(distance))
nml_gp <- no_marine_layer %>% group_by(la,ls) %>% summarise(avg = median(distance))

# Model without St Louis
data_stl$est <- predict(lm( distance ~ l_angle+l_speed+air_density, data=data_nostl, x=TRUE ), data_stl)



# Predict Home Run Distance in St Louis
data_nostl <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                    COL,BOS,NYY,DET,SEA,KC,
                    CHC,ATL,SD,MIN,HOU,
                    MIA,PHI,LAD,CWS) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         events == 'home_run') %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_angle = as.numeric(launch_angle),
         l_speed = as.numeric(launch_speed)) %>%
  filter(l_angle > 0,distance > 0)
data_stl <- STL %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         events == 'home_run') %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_angle = as.numeric(launch_angle),
         l_speed = as.numeric(launch_speed)) %>%
  filter(l_angle > 0,distance > 0)
data_stl$est <- predict(lm( distance ~ l_angle+l_speed+air_density, data=data_nostl, x=TRUE ), data_stl)
diff_stl <- data_stl %>% mutate(diff = abs(est - distance))
pairs(data_stl[,c(47:51)], lower.panel = NULL)






# Predict Home Run Distance in 2/5 of stadium
data_model <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                    COL,DET,SEA,KC,
                    CHC,MIN,HOU,
                    MIA,LAD,CWS,STL) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         events == 'home_run') %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_a = as.numeric(launch_angle),
         l_s = as.numeric(launch_speed),
         l_sa = as.numeric(launch_speed_angle)) %>%
  filter(l_a > 0,distance > 0)
data_control <- rbind(BOS,NYY,PHI,SD,ATL) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         events == 'home_run') %>%
  mutate(distance = as.numeric(hit_distance_sc),
         l_a = as.numeric(launch_angle),
         l_s = as.numeric(launch_speed),
         l_sa = as.numeric(launch_speed_angle)) %>%
  filter(l_a > 0,distance > 0)
data_control$est <- predict(lm( distance ~ l_a+l_s+l_sa+air_density, data=data_control, x=TRUE ), data_control)
diff_control <- data_control %>% mutate(diff = abs(est - distance), density_bucket = case_when(air_density <= 0.95 ~ 0.95,
                                                                                                    air_density <= 1.0 ~ 1,
                                                                                                    air_density <= 1.05 ~ 1.05,
                                                                                                    air_density <= 1.1 ~ 1.1,
                                                                                                    air_density <= 1.15 ~ 1.15,
                                                                                                    air_density <= 1.2 ~ 1.2,
                                                                                                    air_density <= 1.25 ~ 1.25,
                                                                                                    air_density >= 1.25 ~ 1.3))
ggplot(diff_control, aes(x=air_density,y=diff)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(1.1,1.3)) +
  scale_y_continuous("Model diff from MLB",limits=c(0,50))


diff_control %>%
  ggplot(aes(x = density_bucket)) + 
  geom_segment(size = 1, color = "grey20", aes(
    xend = id,
    y = jump, 
    yend = chute)) +
  geom_segment(lty = 1, size = 0.25, color = "grey40", aes(
    xend = id,
    y = chute, 
    yend = 0)) +
  facet_wrap(~section, scales = "free_x", ncol = 1) + 
  labs(title = "", x = "", y = "", color = "") + 
  scale_x_continuous(breaks = seq(0, 500, 25)) + 
  theme(
    panel.background = element_rect(fill = "#FFFFFF"), 
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "none",
    axis.text = element_blank())





# Home Runs per game by air density
all_hr <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                COL,BOS,NYY,DET,SEA,KC,
                CHC,ATL,SD,STL,MIN,HOU,
                MIA,PHI,LAD,CWS) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         events == 'home_run') %>%
  mutate(density_bucket = case_when(air_density <= 0.95 ~ 0.95,
                                    air_density <= 1.0 ~ 1,
                                    air_density <= 1.05 ~ 1.05,
                                    air_density <= 1.1 ~ 1.1,
                                    air_density <= 1.15 ~ 1.15,
                                    air_density <= 1.2 ~ 1.2,
                                    air_density <= 1.25 ~ 1.25,
                                    air_density >= 1.25 ~ 1.3))
avg_per_game <- all_hr %>% group_by(density_bucket,home_team,game_date) %>% summarise(hrs = length(game_date)) %>% group_by(density_bucket) %>% summarise(hr_per_game = mean(hrs))
hrg_cor <- avg_per_game %>% summarise(correlation = cor(density_bucket,hr_per_game))
ggplot(avg_per_game, aes(x=density_bucket,y=hr_per_game)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.95,1.3)) +
  scale_y_continuous("Home Runs per Game",limits=c(0,4))



# Average fly ball distance by air density
all_fly_ball <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                      COL,BOS,NYY,DET,SEA,KC,
                      CHC,ATL,SD,STL,MIN,HOU,
                      MIA,PHI,LAD,CWS) %>%
  mutate(distance = as.numeric(hit_distance_sc)) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         distance > 0,
         bb_type == 'fly_ball') %>% mutate(density_bucket = case_when(air_density < 1.0 ~ 1,
                                                                      air_density < 1.05 ~ 1.05,
                                                                      air_density < 1.1 ~ 1.1,
                                                                      air_density < 1.15 ~ 1.15,
                                                                      air_density < 1.2 ~ 1.2,
                                                                      air_density >= 1.2 ~ 1.25))
avg_fly_ball <- all_fly_ball %>% group_by(density_bucket) %>% summarise(avg_fb_distance = mean(distance))

fb_cor <- all_fly_ball %>% summarise(correlation = cor(density_bucket,distance))

ggplot(all_fly_ball, aes(x=air_density,y=distance)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.95,1.3)) +
  scale_y_continuous("Fly Ball Distance",limits=c(175,525))

# Average line drive distance by air density
all_line_drive <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                        COL,BOS,NYY,DET,SEA,KC,
                        CHC,ATL,SD,STL,MIN,HOU,
                        MIA,PHI,LAD,CWS) %>%
  mutate(distance = as.numeric(hit_distance_sc)) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         distance > 0,
         bb_type == 'line_drive') %>% mutate(density_bucket = case_when(air_density < 1.0 ~ 1,
                                                                        air_density < 1.05 ~ 1.05,
                                                                        air_density < 1.1 ~ 1.1,
                                                                        air_density < 1.15 ~ 1.15,
                                                                        air_density < 1.2 ~ 1.2,
                                                                        air_density >= 1.2 ~ 1.25))
avg_line_drive <- all_line_drive %>% group_by(density_bucket) %>% summarise(avg_ld_distance = mean(distance))

ld_cor <- all_line_drive %>% summarise(correlation = cor(density_bucket,distance))

ggplot(all_line_drive, aes(x=air_density,y=distance)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.95,1.3)) +
  scale_y_continuous("Line Drive Distance",limits=c(25,500))

# Average home run distance by air density
all_home_run <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                      COL,BOS,NYY,DET,SEA,KC,
                      CHC,ATL,SD,STL,MIN,HOU,
                      MIA,PHI,LAD,CWS) %>%
  mutate(distance = as.numeric(hit_distance_sc)) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         distance > 0,
         events == 'home_run') %>% mutate(density_bucket = case_when(air_density < 1.0 ~ 1,
                                                                     air_density < 1.05 ~ 1.05,
                                                                     air_density < 1.1 ~ 1.1,
                                                                     air_density < 1.15 ~ 1.15,
                                                                     air_density < 1.2 ~ 1.2,
                                                                     air_density >= 1.2 ~ 1.25))

hr_cor <- all_home_run %>% summarise(correlation = cor(density_bucket,distance))

ggplot(all_home_run, aes(x=air_density,y=distance)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.95,1.3)) +
  scale_y_continuous("Home Run Distance",limits=c(200,550))

avg_home_run <- all_home_run %>% group_by(density_bucket) %>% summarise(avg_hr_distance = mean(distance))

density_bucket <- avg_per_game %>% left_join(avg_home_run) %>% 
  left_join(avg_fly_ball) %>% left_join(avg_line_drive)

ggplot(density_bucket, aes(density_bucket, hr_per_game)) + 
  geom_line()
ggplot(density_bucket, aes(density_bucket, avg_hr_distance)) + 
  geom_line()
ggplot(density_bucket, aes(density_bucket, avg_fb_distance)) + 
  geom_line()
ggplot(density_bucket, aes(density_bucket, avg_ld_distance)) + 
  geom_line()

# Average hard-hit fly ball distance by air density
all_fly_ball_hh <- rbind(BAL,WAS,OAK,CLE,NYM,SF,
                         COL,BOS,NYY,DET,SEA,KC,
                         CHC,ATL,SD,STL,MIN,HOU,
                         MIA,PHI,LAD,CWS) %>%
  mutate(distance = as.numeric(hit_distance_sc)) %>%
  filter(air_density > 0 & air_density < 5,
         humidity_percent > 0 & humidity_percent < 101,
         distance > 0, as.numeric(launch_speed) > 95,
         bb_type == 'fly_ball') %>% mutate(density_bucket = case_when(air_density < 1.0 ~ 1,
                                                                      air_density < 1.05 ~ 1.05,
                                                                      air_density < 1.1 ~ 1.1,
                                                                      air_density < 1.15 ~ 1.15,
                                                                      air_density < 1.2 ~ 1.2,
                                                                      air_density >= 1.2 ~ 1.25))
avg_fly_ball_hh <- all_fly_ball_hh %>% group_by(density_bucket) %>% summarise(avg_fb_distance = mean(distance))

fb_cor_hh <- all_fly_ball_hh %>% summarise(correlation = cor(density_bucket,distance))

ggplot(all_fly_ball_hh, aes(x=air_density,y=distance)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous("Air Density",limits=c(0.95,1.3)) +
  scale_y_continuous("Fly Ball Distance",limits=c(175,525))

b_order <- BAL %>%
  select(play_date,play_time,humidity_percent,pressure_mmhg,temp_celcius,air_density) %>%
  arrange(play_date,play_time)


plot_avg_density <- function(team) {
  ggplot(team %>% group_by(play_date) %>% summarise(m = mean(air_density)), aes(as.Date(as.character(play_date),'%Y%m%d'), m)) + 
    geom_point() +
    geom_smooth()
}
plot_avg_density_test <- function(team) {
  ggplot(team %>% filter(sv_date > '20180401',sv_date < '20181001'), aes(as.Date(as.character(sv_date),'%Y%m%d'), air_density)) +
    geom_point() +
    geom_smooth()
}

plot_sd_density <- function(team) {
  ggplot(team %>% group_by(play_date) %>% summarise(s = sd(air_density)), aes(as.Date(as.character(play_date),'%Y%m%d'), s)) + 
    geom_point() +
    geom_smooth()
}

# plot_avg_density()
plot_avg_density(BAL)
plot_avg_density_test(BAL_ALL)
plot_avg_density(STL)
plot_avg_density(CHC)
plot_avg_density(HOU)
plot_avg_density(SEA)
plot_avg_density(SD)
plot_avg_density(KC)
plot_avg_density(MIA)
plot_avg_density(BOS)
plot_avg_density(NYY)
plot_avg_density(CLE)
plot_avg_density(DET)
plot_avg_density(OAK)
plot_avg_density(ATL)
plot_avg_density(NYM)
plot_avg_density(WAS)
plot_avg_density(COL)
plot_avg_density(MIN)
plot_avg_density(PHI)
plot_avg_density(LAD)
plot_avg_density(SF)
plot_avg_density(CWS)

# plot_sd_density()
plot_sd_density(BAL)
plot_sd_density(STL)
plot_sd_density(CHC)
plot_sd_density(HOU)
plot_sd_density(SEA)
plot_sd_density(SD)
plot_sd_density(KC)
plot_sd_density(MIA)
plot_sd_density(BOS)
plot_sd_density(NYY)
plot_sd_density(CLE)
plot_sd_density(DET)
plot_sd_density(OAK)
plot_sd_density(ATL)
plot_sd_density(NYM)
plot_sd_density(WAS)
plot_sd_density(COL)
plot_sd_density(MIN)
plot_sd_density(PHI)
plot_sd_density(LAD)
plot_sd_density(SF)
plot_sd_density(CWS)

ggplot(BAL, aes(play_date)) + 
  geom_line(aes(y = humidity_percent / 20, colour = "humidity_percent")) +
  geom_line(aes(y = temp_celcius / 2, colour = "temp_celcius")) +
  geom_line(aes(y = air_density, colour = "air_density")) +
  geom_line(aes(y = pressure_mmhg / 50, colour = "pressure_mmhg"))


