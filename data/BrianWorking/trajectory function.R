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




# hwind = height of wind (ft)   assumed as 0


p <- pi

traj <- function(x0,y0,z0,v0,sign,theta,r,phi1,temp,pressure,RH,elev,vwind,phiwind){
  #g = 9.80665 # m/s2  gravity
  mass = 5.125 # mass of baseball
  circ = 9.125 # circumference of base
  #R = 0.03683  # baseball radius in meters
  #cd = .35     # drag coefficient
  # v = initial velocity
  # h = height above plate ball is hit
  # th = angle of hit
  # den = air density
  
	dt = 0
	phi = 0
	SVP = 4.5841*exp((18.687-temp/234.5)*temp/(257.14+temp))
	beta = 0.0001217
	rho1 = 1.2929*(273/(temp + 273)*(pressure*exp(-beta*elev) - 0.3783*RH*SVP/100)/760)
	rho = rho1*0.06261
	const = 0.07182*rho*(5.125/mass)*(circ/9.125)^2

	tau = 10000

	# spin
	wb = -763 + 120*theta + 21*phi*sign
	ws = -sign*849 - 94*phi
	wg = 0
	omega = sqrt(wb^2 + ws^2)*pi/30
	romega = (circ/2/pi)*omega/12

	# velocities
	v0x = 1.467*v0*cos(theta*pi/180)*sin(phi*pi/180)
	v0y = 1.467*v0*cos(theta*pi/180)*cos(phi*pi/180)
	v0z = 1.467*v0*sin(theta*pi/180)
	#v0 = v0*1.467

	v0xw = vwind*1.467*sin(phiwind*pi/180)
	v0yw = vwind*1.467*cos(phiwind*pi/180)
	v0w = sqrt((v0x-v0xw)^2+(v0y-v0yw)^2+v0z^2)

	# coefficients
	cd0 = .3008
	cl0 = .583
	cl1 = 2.333
	cl2 = 1.120
	spin = sqrt(wb^2+ws^2)
	cdspin = 0.0292
	Cd = cd0 + cdspin*(spin/1000)*exp(-dt/(tau*146.7/v0w))
	S = (romega/v0w)*exp(-dt/(tau*146.7/v0w))
	Cl = cl2*S/(cl0+cl1*S)

	# angular acceleration
	w = omega*exp(-dt/tau)*30/pi
	wx = (wb*cos(phi*pi/180) - ws*sin(theta*pi/180)*sin(phi*pi/180) + wg*v0x/v0)*pi/30
	wy = (-wb*sin(phi*pi/180) - ws*sin(theta*pi/180)*cos(phi*pi/180) + wg*v0y/v0)*pi/30
	wz = (ws*cos(theta*pi/180) + wg*v0z/v0)*pi/30

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
	r = sqrt(x^2 + y^2)
	phi = phi1  #ATAN2(y,x)*180/pi
	dt = (-y0*sin(phi)*tan(phi) + r*sin^2(phi) + x0*cos(phi)*tan(phi) - r*cos(phi)*tan(phi)*sin(phi)) / (tan(phi)*(v0y*sin(phi) - v0*cos(phi)))

	# spin
	wb = -763 + 120*theta + 21*phi*sign
	ws = -sign*849 - 94*phi
	wg = 0
	omega = sqrt(wb^2 + ws^2)*pi/30
	romega = (circ/2/pi)*omega/12

	# velocities
	vx = v0x + a0x*dt
	vy = v0y + a0y*dt
	vz = v0z + a0z*dt
	v = sqrt(vx^2 + vy^2 + vz^2)
	
	vxw = vwind*1.467*sin(phiwind*pi/180)
	vyw = vwind*1.467*cos(phiwind*pi/180)
	vw = sqrt((vx-vxw)^2+(vy-vyw)^2+vz^2)

	# coefficients
	spin = sqrt(wb^2+ws^2)
	cdspin = 0.0292
	Cd = cd0 + cdspin*(spin/1000)*exp(-dt/(tau*146.7/vw))
	S = (romega/vw)*exp(-dt/(tau*146.7/vw))
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
	#x = x0 + v0x*dt + 0.5*ax*dt*dt
	#y = y0 + v0y*dt + 0.5*ay*dt*dt
	z = z0 + v0z*dt + 0.5*az*dt*dt
	
}
