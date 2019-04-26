package main

import (
	"bufio"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"math"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

func main() {
	in := flag.String("in", "", "Directory containing ISD csv files")
	lat := flag.Float64("lat", 0.0, "Latitude of target stadium")
	lon := flag.Float64("lon", 0.0, "Longitude of target stadium")
	team := flag.String("team", "", "Team abbreviation")

	flag.Parse()

	walkDir(*in, *lat, *lon, *team)
}

func walkDir(path string, lat, lon float64, team string) {
	files, err := ioutil.ReadDir(path)
	if err != nil {
		log.Fatal(err)
	}

	for _, f := range files {
		fullPath := filepath.Join(path, f.Name())
		testFile(fullPath, lat, lon, team)
	}
}

func testFile(path string, latitude, longitude float64, team string) {
	fp, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()

	latIdx := 0
	lonIdx := 0
	//nameIdx := 0

	scanner := bufio.NewScanner(fp)
	scanner.Scan()
	hdr := scanner.Text()
	hdrF := strings.Split(hdr, ",")
	for i, elem := range hdrF {
		e := strings.ReplaceAll(elem, "\"", "")
		if e == "LATITUDE" {
			latIdx = i
		}
		if e == "LONGITUDE" {
			lonIdx = i
		}
		if e == "NAME" {
			//nameIdx = i
		}
	}

	scanner.Scan()
	fL := scanner.Text()
	flF := strings.Split(fL, ",")
	lonDbl, err := strconv.ParseFloat(strings.ReplaceAll(flF[lonIdx], "\"", ""), 64)
	if err != nil {
		log.Fatal(err)
	}
	latDbl, err := strconv.ParseFloat(strings.ReplaceAll(flF[latIdx], "\"", ""), 64)
	if err != nil {
		log.Fatal(err)
	}
	if math.Abs(latitude-latDbl) < 0.2 && math.Abs(longitude-lonDbl) < 0.2 {
		//name := strings.ReplaceAll(flF[nameIdx], "\"", "")
		//dist := Distance(latDbl, lonDbl, latitude, longitude) / 1000.0 * 0.6213712
		fmt.Printf("cp %s ./2018/%s/\n", path, team)
	}
}

/*
https://gist.github.com/cdipaolo/d3f8db3848278b49db68
*/
// haversin(θ) function
func hsin(theta float64) float64 {
	return math.Pow(math.Sin(theta/2), 2)
}

// Distance function returns the distance (in meters) between two points of
//     a given longitude and latitude relatively accurately (using a spherical
//     approximation of the Earth) through the Haversin Distance Formula for
//     great arc distance on a sphere with accuracy for small distances
//
// point coordinates are supplied in degrees and converted into rad. in the func
//
// distance returned is METERS!!!!!!
// http://en.wikipedia.org/wiki/Haversine_formula
func Distance(lat1, lon1, lat2, lon2 float64) float64 {
	// convert to radians
	// must cast radius as float to multiply later
	var la1, lo1, la2, lo2, r float64
	la1 = lat1 * math.Pi / 180
	lo1 = lon1 * math.Pi / 180
	la2 = lat2 * math.Pi / 180
	lo2 = lon2 * math.Pi / 180

	r = 6378100 // Earth radius in METERS

	// calculate
	h := hsin(la2-la1) + math.Cos(la1)*math.Cos(la2)*hsin(lo2-lo1)

	return 2 * r * math.Asin(math.Sqrt(h))
}
