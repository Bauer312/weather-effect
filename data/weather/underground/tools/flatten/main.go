package main

import (
	"compress/gzip"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"path/filepath"
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
	inputDirectory string
	outputPath     string
)

func main() {
	inputDirectory = os.Args[1]
	walkDir(inputDirectory, 5)
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
		writeOutput(ob)
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
		writeOutput(ob)
	}
}

func writeOutputHeader() {
	fmt.Printf("%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n",
		"StationID", "Timezone", "UTCTime", "LocalTime",
		"Epoch", "Latitude", "Longitude",
		"SolarRadiationHigh", "UVHigh", "WindDirAvg",
		"HumidityHigh", "HumidityLow", "HumidityAvg",
		"QCStatus", "TempHigh", "TempLow", "TempAvg",
		"WindspeedHigh", "WindspeedLow", "WindspeedAvg",
		"WindgustHigh", "WindgustLow", "WindgustAvg",
		"DewpointHigh", "DewpointLow", "DewpointAvg")
}
func writeOutput(ob Observation) {
	fmt.Printf("%s|%s|%s|%s|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v|%v\n",
		ob.StationID, ob.Tz, ob.ObsTimeUtc, ob.ObsTimeLocal,
		ob.Epoch, ob.Lat, ob.Lon,
		ob.SolarRadiationHigh, ob.UvHigh, ob.WinddirAvg,
		ob.HumidityHigh, ob.HumidityLow, ob.HumidityAvg,
		ob.QcStatus,
		ob.IV.TempHigh, ob.IV.TempLow, ob.IV.TempAvg,
		ob.IV.WindspeedHigh, ob.IV.WindspeedLow, ob.IV.WindspeedAvg,
		ob.IV.WindgustHigh, ob.IV.WindgustLow, ob.IV.WindgustAvg,
		ob.IV.DewptHigh, ob.IV.DewptLow, ob.IV.DewptAvg)
	//fmt.Println(ob)
}
