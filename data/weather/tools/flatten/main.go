package main

import (
	"bufio"
	"compress/gzip"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"math"
	"os"
	"path"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

/*
Imperial contains all imperial readings
*/
type Imperial struct {
	TempHigh      float64 `json:"tempHigh"`
	TempLow       float64 `json:"tempLow"`
	TempAvg       float64 `json:"tempAvg"`
	WindspeedHigh float64 `json:"windspeedHigh"`
	WindspeedLow  float64 `json:"windspeedLow"`
	WindspeedAvg  float64 `json:"windspeedAvg"`
	WindgustHigh  float64 `json:"windgustHigh"`
	WindgustLow   float64 `json:"windgustLow"`
	WindgustAvg   float64 `json:"windgustAvg"`
	DewptHigh     float64 `json:"dewptHigh"`
	DewptLow      float64 `json:"dewptLow"`
	DewptAvg      float64 `json:"dewptAvg"`
	WindchillHigh float64 `json:"windchillHigh"`
	WindchillLow  float64 `json:"windchillLow"`
	WindchillAvg  float64 `json:"windchillAvg"`
	HeatindexHigh float64 `json:"heatindexHigh"`
	HeatindexLow  float64 `json:"heatindexLow"`
	HeatindexAvg  float64 `json:"heatindexAvg"`
	PressureMax   float64 `json:"pressureMax"`
	PressureMin   float64 `json:"pressureMin"`
	PressureTrend float64 `json:"pressurTrend"`
	PrecipRate    float64 `json:"precipRate"`
	PrecipTotal   float64 `json:"precipTotal"`
}

/*
Observation is a single observation
*/
type Observation struct {
	StationID          string    `json:"stationID"`
	Tz                 string    `json:"tz"`
	ObsTimeUtc         time.Time `json:"obsTimeUtc"`
	ObsTimeLocal       string    `json:"obsTimeLocal"`
	Epoch              int64     `json:"epoch"`
	Lat                float64   `json:"lat"`
	Lon                float64   `json:"lon"`
	SolarRadiationHigh float64   `json:"solarRadiationHigh"`
	UvHigh             float64   `json:"uvHigh"`
	WinddirAvg         float64   `json:"winddirAvg"`
	HumidityHigh       float64   `json:"humidityHigh"`
	HumidityLow        float64   `json:"humidityLow"`
	HumidityAvg        float64   `json:"humidityAvg"`
	QcStatus           float64   `json:"qcStatus"`
	IV                 Imperial  `json:"imperial"`
}

/*
ObservationSet contains an array of Observations
*/
type ObservationSet struct {
	Obs []Observation `json:"observations"`
}

var (
	inputDirectory = flag.String("dir", "", "Location of directory containing weather data")
	outputPath     string
	altitude       map[string]float64
)

func main() {
	flag.Parse()

	if len(*inputDirectory) == 0 {
		flag.Usage()
	}

	populateAltitude(*inputDirectory)
	writeOutputHeader()
	walkDir(*inputDirectory, 5)
}

func walkDir(path string, level int) {
	fp, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()
	elements, err := fp.Readdir(0)
	if err != nil {
		log.Fatal(err)
	}
	for _, element := range elements {
		if element.IsDir() == true {
			walkDir(filepath.Join(path, element.Name()), level-1)
		} else {
			if strings.HasSuffix(element.Name(), ".gz") {
				streamZip(filepath.Join(path, element.Name()))
			} else if strings.HasSuffix(element.Name(), ".json") {
				streamJSON(filepath.Join(path, element.Name()))
			}
		}
	}
}

func streamZip(path string) {
	fp, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()
	zr, err := gzip.NewReader(fp)
	if err != nil {
		log.Fatal(err)
	}
	defer zr.Close()

	var obs ObservationSet
	decoder := json.NewDecoder(zr)
	err = decoder.Decode(&obs)
	if err != nil {
		log.Fatal(err)
	}
	for _, ob := range obs.Obs {
		validateObservationTime(ob)
	}
}

func streamJSON(path string) {
	fp, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()

	var obs ObservationSet
	decoder := json.NewDecoder(fp)
	err = decoder.Decode(&obs)
	if err != nil {
		log.Fatal(err)
	}
	for _, ob := range obs.Obs {
		validateObservationTime(ob)
	}
}

func validateObservationTime(ob Observation) {
	components := strings.Split(ob.ObsTimeLocal, " ")
	timeComponents := strings.Split(components[1], ":")
	hour, err := strconv.Atoi(timeComponents[0])
	if err != nil {
		log.Fatal(err)
	}
	//Handle times that are from 10AM through 3AM
	if hour > 9 || hour < 3 {
		writeOutput(ob)
	}
}

func writeOutputHeader() {
	fmt.Printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
		"StationID", "LocalTime",
		"Humidity", "Temp", "WindDirAvg",
		"Windspeed", "PrecipitationRate", "PrecipitationTotal",
		"BarometricPressure", "AirDensitySL", "AirDensityT")
}
func writeOutput(ob Observation) {
	cTemp := fahrenheitToCelcius(ob.IV.TempAvg)
	avgPres := (ob.IV.PressureMax + ob.IV.PressureMin) / 2.0
	sp := stationPressure(cTemp, altitude[ob.StationID], avgPres)
	svp := saturationVaporPressure(cTemp)
	rhoSL := airDensity(cTemp, sp, svp, ob.HumidityAvg)
	rhoT := airDensity(cTemp, inchesToMM(avgPres), svp, ob.HumidityAvg)
	fmt.Printf("%s,%s,%v,%v,%v,%v,%v,%v,%v,%v,%v\n",
		ob.StationID, ob.ObsTimeLocal,
		ob.HumidityAvg, ob.IV.TempAvg, ob.WinddirAvg,
		ob.IV.WindspeedAvg, ob.IV.PrecipRate,
		ob.IV.PrecipTotal, avgPres, rhoSL, rhoT)
}

func fahrenheitToCelcius(fTemp float64) float64 {
	return (fTemp - 32.0) * 5.0 / 9.0
}

func inchesToMM(in float64) float64 {
	return in * 25.4
}

func feetToMeter(ft float64) float64 {
	return ft * 0.3048
}

/*
saturationVaporPressure is measured in mm Hg and this formula is described in
		*The Science of Baseball* (2019 2nd edition) by *A. Terry Bahill*
	in section 7.8 on page 181.  Temperature is in degrees Celcius.
*/
func saturationVaporPressure(cTemp float64) float64 {
	pVal := cTemp * (18.687 - (cTemp / 234.5)) / (257.14 + cTemp)
	return 4.5841 * math.Pow(math.E, pVal)
}

func airDensity(cTemp, airPres, svp, hum float64) float64 {
	h := hum / 100.0
	return 1.2929 * (273.0 / (cTemp + 273.0)) * ((airPres - (0.379 * svp * h)) / 760.0)
}

func stationPressure(cTemp, alt, bar float64) float64 {
	pVal := (-9.80665 * 0.289644 * feetToMeter(alt)) / (8.31447 * (cTemp + 273.15))
	return inchesToMM(bar) * math.Pow(math.E, pVal)
}

func populateAltitude(dir string) {
	filePath := path.Join(dir, "altitude.dat")
	fp, err := os.Open(filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()
	altitude = make(map[string]float64)

	sc := bufio.NewScanner(fp)
	for sc.Scan() {
		comp := strings.Split(sc.Text(), ",")
		fv, err := strconv.ParseFloat(comp[1], 64)
		if err != nil {
			log.Fatal(err)
		}
		altitude[comp[0]] = fv
	}
}
