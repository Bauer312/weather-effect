package main

import (
	"bytes"
	"flag"
	"fmt"
	"log"
	"os/exec"
	"time"
)

var (
	stationCode = flag.String("station", "", "The station code used by Weather Underground")
	startDate   = flag.String("start", "", "The start date in YYYYMMDD format")
	endDate     = flag.String("end", "", "The end date in YYYYMMDD format")
	cmd         = flag.String("cmd", "", "The script that pulls weather data")
)

func main() {
	flag.Parse()

	if len(*stationCode) == 0 || len(*startDate) == 0 || len(*endDate) == 0 || len(*cmd) == 0 {
		flag.Usage()
	}

	stDt, err := time.Parse("20060102", *startDate)
	if err != nil {
		log.Fatal(err)
	}
	endDt, err := time.Parse("20060102", *endDate)
	if err != nil {
		log.Fatal(err)
	}

	for {
		fmt.Printf("%s %s %s\n", *cmd, *stationCode, stDt.Format("20060102"))

		cmd := exec.Command(*cmd, *stationCode, stDt.Format("20060102"))
		var out bytes.Buffer
		cmd.Stdout = &out
		err := cmd.Run()
		if err != nil {
			log.Fatal(err)
		}

		time.Sleep(750 * time.Millisecond)
		stDt = stDt.AddDate(0, 0, 1)
		if stDt.After(endDt) {
			break
		}
	}
}
