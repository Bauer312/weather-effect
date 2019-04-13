package main

import (
	"encoding/csv"
	"errors"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
)

/*
	For any Baseball Savant file, count the number of records, the number
	that have the sv_id as null, the number of balls in play, and the
	number of balls in play that have an sv_id of null.
*/

var (
	globalRecordCount     int
	globalNullCount       int
	globalInPlayCount     int
	globalInPlayNullCount int
)

func main() {
	filePath := flag.String("f", "", "File to process")
	dirPath := flag.String("d", "", "Directory to process")
	flag.Parse()
	if len(*filePath) == 0 && len(*dirPath) == 0 {
		flag.Usage()
	}

	// On or the other, but choose directory over file if both are present...
	if len(*dirPath) > 0 {
		walkDir(*dirPath, 5)
		fmt.Println("Totals")
		fmt.Printf("\tRecords: %d\t\tNull Records: %d\n", globalRecordCount, globalNullCount)
		fmt.Printf("\tInPlay: %d\t\tNull InPlay: %d\n", globalInPlayCount, globalInPlayNullCount)
	} else {
		readFile(*filePath)
	}
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
			readFile(filepath.Join(path, element.Name()))
		}
	}
}

func readFile(path string) {
	fp, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()

	svID := -1
	pitchType := -1

	csvReader := csv.NewReader(fp)
	header, err := csvReader.Read()
	if err != nil {
		log.Fatal(err)
	}

	for i, element := range header {
		switch element {
		case "sv_id":
			svID = i
		case "type":
			pitchType = i
		}
	}

	if svID == -1 || pitchType == -1 {
		log.Fatal(errors.New("Cannot find all needed header records"))
	}

	recordCount := 0
	inPlay := 0
	nullSVID := 0
	nullInPlay := 0

	for {
		record, err := csvReader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}

		recordCount++
		if record[svID] == "null" {
			nullSVID++
		}

		if record[pitchType] == "X" {
			inPlay++
			if record[svID] == "null" {
				nullInPlay++
			}
		}
	}

	fmt.Printf("\tFile: %s\n", path)
	fmt.Printf("\t\tRecords: %d\t\tNull Records: %d\n", recordCount, nullSVID)
	fmt.Printf("\t\tInPlay: %d\t\tNull InPlay: %d\n", inPlay, nullInPlay)
	globalInPlayCount += inPlay
	globalInPlayNullCount += nullInPlay
	globalRecordCount += recordCount
	globalNullCount += nullSVID
}
