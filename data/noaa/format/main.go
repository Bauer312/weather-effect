package main

import (
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"log"
	"math"
	"os"
	"strconv"
	"strings"
	"time"
)

type record struct {
	stationIdx int
	dateIdx    int
	latIdx     int
	lonIdx     int
	eleIdx     int
	nameIdx    int
	typeIdx    int
	wndIdx     int
	tmpIdx     int
	dewIdx     int
	slpIdx     int
	station    string
	date       time.Time
	svDate     string
	svTime     string
	latitude   string
	longitude  string
	elevation  string
	name       string
	reportType string
	wnd        string
	wndDir     int
	wndType    string
	wndSpeed   float64
	tmp        float64
	dew        float64
	slp        float64
	hum        float64
}

func main() {
	inPath := flag.String("in", "", "Input file")
	outPath := flag.String("out", "", "Output file")
	flag.Parse()
	outFp, err := os.Create(*outPath)
	if err != nil {
		log.Fatal(err)
	}
	defer outFp.Close()
	fmt.Fprintln(outFp, "station, sv_date, sv_time,"+
		"latitude,longitude,elevation,name,report_type,"+
		"wind_direction, wind_record_type, wind_speed_meters_per_second,"+
		"temp_celcius,pressure_mmhg,humidity_percent")
	formatFile(*inPath, *outPath, outFp)
}

func formatFile(inPath, outPath string, outFp *os.File) {
	fp, err := os.Open(inPath)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()

	csvReader := csv.NewReader(fp)

	var rec record
	var prec record
	populated := false

	hdr, err := csvReader.Read()
	if err != nil {
		log.Fatal(err)
	}
	//fmt.Println(hdr)
	for i, val := range hdr {
		switch val {
		case "STATION":
			rec.stationIdx = i
		case "DATE":
			rec.dateIdx = i
		case "LATITUDE":
			rec.latIdx = i
		case "LONGITUDE":
			rec.lonIdx = i
		case "ELEVATION":
			rec.eleIdx = i
		case "NAME":
			rec.nameIdx = i
		case "REPORT_TYPE":
			rec.typeIdx = i
		case "WND":
			rec.wndIdx = i
		case "TMP":
			rec.tmpIdx = i
		case "SLP":
			rec.slpIdx = i
		case "DEW":
			rec.dewIdx = i
		}
	}
	//fmt.Println(rec)

	for {
		fields, err := csvReader.Read()
		if err == io.EOF {
			break
		} else if err != nil {
			log.Fatal(err)
		}
		rec.station = fields[rec.stationIdx]
		recDate, err := time.Parse("2006-01-02T15:04:05", fields[rec.dateIdx])
		if err != nil {
			log.Fatal(err)
		}
		rec.date = recDate.Round(10 * time.Minute)
		rec.latitude = fields[rec.latIdx]
		rec.longitude = fields[rec.lonIdx]
		rec.elevation = fields[rec.eleIdx]
		rec.name = fields[rec.nameIdx]
		rec.reportType = fields[rec.typeIdx]
		wndE := strings.Split(fields[rec.wndIdx], ",")
		tmpWndDir, err := strconv.Atoi(wndE[0])
		if err != nil {
			log.Fatal(err)
		}
		rec.wndDir = tmpWndDir
		rec.wndType = wndE[2]
		tmpWndSpeed, err := strconv.ParseFloat(wndE[3], 64)
		if err != nil {
			log.Fatal(err)
		}
		rec.wndSpeed = tmpWndSpeed / 10
		rec.wnd = fields[rec.wndIdx]
		tmp, err := strconv.ParseFloat(strings.Split(fields[rec.tmpIdx], ",")[0], 64)
		if err != nil {
			log.Fatal(err)
		}
		rec.tmp = tmp / 10
		dew, err := strconv.ParseFloat(strings.Split(fields[rec.dewIdx], ",")[0], 64)
		if err != nil {
			log.Fatal(err)
		}
		rec.dew = dew / 10
		slp, err := strconv.ParseFloat(strings.Split(fields[rec.slpIdx], ",")[0], 64)
		if err != nil {
			log.Fatal(err)
		}
		rec.slp = slp / 10
		if slp == 99999 {
			rec.slp = 0
		}
		//rec.hum = 100.0 - 5*(rec.tmp-rec.dew)
		rec.hum = 100 * (math.Pow(2.71828182845904, ((17.625*rec.dew)/(243.04+rec.dew))) / math.Pow(2.71828182845904, ((17.625*rec.tmp)/(243.04+rec.tmp))))

		rec.svDate = recDate.Format("20060102")
		rec.svTime = recDate.Format("150405")

		if populated == true {
			curDate := prec.date
			for curDate.Before(rec.date) {
				fmt.Fprintf(outFp, "%s,%s,%s,%s,%s,%s,\"%s\",%s,%d,%s,%5.1f,%6.2f,%8.1f,%5.1f\n",
					prec.station, prec.svDate, curDate.Format("150405"),
					prec.latitude, prec.longitude,
					prec.elevation, prec.name, prec.reportType,
					prec.wndDir, prec.wndType, prec.wndSpeed,
					prec.tmp, prec.slp*0.7500638, prec.hum)
				curDate = curDate.Add(time.Minute * 10)
			}

		}

		prec = rec

		populated = true
	}
}
