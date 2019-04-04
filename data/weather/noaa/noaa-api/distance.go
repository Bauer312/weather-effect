package main

import "math"

/*
https://en.wikipedia.org/wiki/Haversine_formula
*/

func hav(theta float64) float64 {
	return (1 - math.Cos(theta)) / 2
}

/*
DistanceKM takes two coordinates and returns the distance in meters
*/
func DistanceKM(startLat, startLon, endLat, endLon float64) float64 {
	startLatRadians := startLat * math.Pi / 180
	startLonRadians := startLon * math.Pi / 180
	endLatRadians := endLat * math.Pi / 180
	endLonRadians := endLon * math.Pi / 180

	comp1 := hav(endLatRadians - startLatRadians)
	comp2 := math.Cos(startLatRadians)
	comp3 := math.Cos(endLatRadians)
	comp4 := math.Cos(endLonRadians - startLonRadians)
	comp5 := math.Sqrt(comp1 + (comp2 * comp3 * comp4))
	radius := 6371000 //Average radius

	distance := float64(2*radius) * math.Asin(comp5)

	return distance / 1000.0
}
