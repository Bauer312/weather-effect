if (!require(tidyverse)) install.packages('tidyverse')
library(tidyverse)


mass = 5.125  #oz
circumfrence = 9.125 #inches

# Input
# x0 y0 z0  (ft)   corner of home plate z-axis = height y-axis = line between home plate and 2nd base  x-axis perpendicular to other axis
# sign  IF(batterhand="R",1,-1)
# phi = direction (deg)
# theta = launch angle (deg)
# pressure = pressure (mmg)
# elev = elevation (ft)
# temp = temperature (C)
# RH = relative humidity (%)
# v0 = exit speed (ft/s)
# phiwind = angle of wind (deg) runs along y-axis   need to account for which direction stadium is facing and use to get wind direction
# vwind = velocity of wind (mph)
# hwind = height of wind (ft)  was going to assume 0

# initial
dt
SVP = 4.5841*EXP((18.687-temp/234.5)*temp/(257.14+temp))
beta = 0.0001217
rho1 = 1.2929*(273/(temp + 273)*(pressure*EXP(-beta*elev) - 0.3783*RH*SVP/100)/760)
rho = rho1*0.06261
const = 0.07182*rho*(5.125/mass)*(circ/9.125)^2
# phi = ATAN2(y,x)*180/PI()

tau = 10000

# spin
wb = -763 + 120*theta + 21*phi*sign
ws = -sign*849 - 94*phi
wg = 0
omega = SQRT(wb^2 + ws^2)*PI()/30
romega = (circ/2/PI())*omega/12

# velocities
v0x = 1.467*v0*COS(theta*PI()/180)*SIN(phi*PI()/180)
v0y = 1.467*v0*COS(theta*PI()/180)*COS(phi*PI()/180)
v0z = 1.467*v0*SIN(theta*PI()/180)
#v0 = v0*1.467

v0xw = vwind*1.467*SIN(phiwind*PI()/180)
v0yw = vwind*1.467*COS(phiwind*PI()/180)
v0w = SQRT((v0x-v0xw)^2+(v0y-v0yw)^2+v0z^2)

# coefficients
cd0 = .3008
cl0 = .583
cl1 = 2.333
cl2 = 1.120
spin = SQRT(wb^2+ws^2)
cdspin = 0.0292
Cd = cd0 + cdspin*(spin/1000)*EXP(-dt/(tau*146.7/v0w))
S = (romega/v0w)*EXP(-dt/(tau*146.7/v0w))
Cl = cl2*S/(cl0+cl1*S)

# angular acceleration
w = omega*EXP(-dt/tau)*30/PI()
wx = (wb*COS(phi*PI()/180) - ws*SIN(theta*PI()/180)*SIN(phi*PI()/180) + wg*v0x/v0)*PI()/30
wy = (-wb*SIN(phi*PI()/180) - ws*SIN(theta*PI()/180)*COS(phi*PI()/180) + wg*v0y/v0)*PI()/30
wz = (ws*COS(theta*PI()/180) + wg*v0z/v0)*PI()/30

# acceleration
adragx = -const*Cd*v0w*(v0x - v0xw)
adragx = -const*Cd*v0w*(v0y - v0yw)
adragx = -const*Cd*v0w*v0z

aMag0x = const*(Cl/omega)*v0w*(wy*v0z - wz*(v0y - v0yw))
aMag0y = const*(Cl/omega)*v0w*(wz*(v0x - v0xw) - wx*v0z)
aMag0z = const*(Cl/omega)*v0w*(wx*(v0y - v0yw) - wy*(v0x - v0xw))

a0x = adrag0x + aMag0x
a0y = adrag0y + aMag0y
a0z = adrag0z + aMag0z - 32.174



# final ##############################


# velocities
vx = v0x + a0x*dt
vy = v0y + a0y*dt
vz = v0z + a0z*dt
v = SQRT(vx^2 + vy^2 + vz^2)

vxw = vwind*1.467*SIN(phiwind*PI()/180)
vyw = vwind*1.467*COS(phiwind*PI()/180)
vw = SQRT((vx-vxw)^2+(vy-vyw)^2+vz^2)

# coefficients
spin = SQRT(wb^2+ws^2)
cdspin = 0.0292
Cd = cd0 + cdspin*(spin/1000)*EXP(-dt/(tau*146.7/vw))
S = (romega/vw)*EXP(-dt/(tau*146.7/vw))
Cl = cl2*S/(cl0+cl1*S)

# acceleration
adragx = -const*Cd*vw*(vx - vxw)
adragx = -const*Cd*vw*(vy - vyw)
adragx = -const*Cd*vw*vz

aMagx = const*(Cl/omega)*vw*(wy*vz - wz*(vy - vyw))
aMagy = const*(Cl/omega)*vw*(wz*(vx - vxw) - wx*vz)
aMagz = const*(Cl/omega)*vw*(wx*(vy - vyw) - wy*(vx - vxw))

ax = adragx + aMagx
ay = adragy + aMagy
az = adragz + aMagz - 32.174

# location
x = x0 + v0x*dt + 0.5*ax*dt*dt
y = y0 + v0y*dt + 0.5*ay*dt*dt
z = z0 + v0z*dt + 0.5*az*dt*dt
# Hang Time = 
Distance = SQRT(x^2 + y^2)