package main

import (
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"
)

/*
Combine all the team CSV files into a single file that covers the entire season for all teams.
*/

func main() {
	inputDir := flag.String("in", "", "Input directory containing data files")
	outputFile := flag.String("out", "", "Output File")

	flag.Parse()

	if len(*inputDir) == 0 || len(*outputFile) == 0 {
		flag.Usage()
	}

	outFP, err := os.Create(*outputFile)
	if err != nil {
		log.Fatal(err)
	}
	defer outFP.Close()

	walkDir(*inputDir, outFP, 5, true)
}

func walkDir(path string, output *os.File, level int, printHeader bool) {
	fp, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()
	elements, err := fp.Readdir(0)
	if err != nil {
		log.Fatal(err)
	}

	rowCount := 0
	for _, element := range elements {
		if element.IsDir() == true {
			walkDir(filepath.Join(path, element.Name()), output, level-1, printHeader)
		} else {
			if strings.HasSuffix(element.Name(), ".csv") {
				rowCount += processCSVFile(filepath.Join(path, element.Name()), output, printHeader)
				printHeader = false
			}
		}
	}
	fmt.Printf("Total rows: %d\n", rowCount)
}

func processCSVFile(path string, output *os.File, printHeader bool) int {
	fp, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()

	cR := csv.NewReader(fp)
	//cR.ReuseRecord = true

	cW := csv.NewWriter(output)

	svIdx := -1

	header, err := cR.Read()
	if err != nil {
		log.Fatal(err)
	}
	for i, val := range header {
		if val == "sv_id" {
			svIdx = i
		}
	}
	if printHeader == true {
		header[39] = "sv_date"
		header[40] = "sv_time"
		cW.Write(header)
	}

	rowCount := 0

	for {
		record, err := cR.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}

		if record[21] == "X" {
			rowCount++
			if record[svIdx] == "null" {
				record[39] = "null"
				record[40] = "null"
			} else {
				comp := strings.Split(record[svIdx], "_")
				record[39] = "20" + comp[0]
				record[40] = comp[1]
			}

			cW.Write(record)

		}
	}

	cW.Flush()

	return rowCount
}

func outputDataRecord(svDt, svTm string, record []string) {
	fmt.Println(svDt, svTm,
		record[0], record[2], record[3],
		record[4], record[5], record[6], record[7],
		record[8], record[9], record[10], record[14],
		record[15], record[16], record[17], record[18],
		record[19], record[20], record[21], record[22],
		record[23], record[24], record[25],
		record[27], record[28], record[29])
}
