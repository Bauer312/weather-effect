package main

import (
	"compress/gzip"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
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
)

func main() {
	flag.Parse()

	if len(*inputDirectory) == 0 {
		flag.Usage()
	}

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
	fmt.Printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
		"StationID", "LocalTime",
		"SolarRadiationHigh", "UVHigh", "WindDirAvg",
		"Humidity", "QCStatus", "Temp",
		"Windspeed", "Windgust", "Dewpoint",
		"Windchill", "HeatIndex",
		"PressureMax", "PressureMin", "PressureTrend",
		"PrecipitationRate", "PrecipitationTotal")
}
func writeOutput(ob Observation) {
	fmt.Printf("%s,%s,%v,%v,%v,%v,%v,%v,%v,%v,%v,%v,%v,%v,%v,%v,%v,%v\n",
		ob.StationID, ob.ObsTimeLocal,
		ob.SolarRadiationHigh, ob.UvHigh, ob.WinddirAvg,
		ob.HumidityAvg, ob.QcStatus, ob.IV.TempAvg,
		ob.IV.WindspeedAvg, ob.IV.WindgustAvg, ob.IV.DewptAvg,
		ob.IV.WindchillAvg, ob.IV.HeatindexAvg,
		ob.IV.PressureMax, ob.IV.PressureMin, ob.IV.PressureTrend,
		ob.IV.PrecipRate, ob.IV.PrecipTotal)
}
