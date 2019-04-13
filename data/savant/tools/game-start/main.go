package main

import (
	"encoding/csv"
	"errors"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
)

/*
	For any Baseball Savant file, return the home team, away team, and
	sv_id for all plays in which the at_bat_number and pitch_number
	are both 1.  This indicates the first pitch of the first at-bat
	of each game.
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
		//readDir(*dirPath)
	} else {
		readFile(*filePath)
	}
}

func readDir(path string) {
	dp, err := os.Open(path)
	if err != nil {

	}
	defer dp.Close()
}

func readFile(path string) {
	fp, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer fp.Close()

	svID := -1
	gameDate := -1
	atBatNum := -1
	pitchNum := -1
	homeTeam := -1
	awayTeam := -1
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
		case "game_date":
			gameDate = i
		case "at_bat_number":
			atBatNum = i
		case "pitch_number":
			pitchNum = i
		case "home_team":
			homeTeam = i
		case "away_team":
			awayTeam = i
		case "type":
			pitchType = i
		}
	}

	if pitchNum == -1 || svID == -1 || awayTeam == -1 || homeTeam == -1 || atBatNum == -1 || gameDate == -1 || pitchType == -1 {
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

		if record[atBatNum] == "1" && record[pitchNum] == "1" && record[svID] != "null" {
			fmt.Printf("%s,%s,%s,%s\n",
				record[gameDate], record[svID], record[homeTeam], record[awayTeam])
		}
	}

	fmt.Fprintf(os.Stderr, "Records: %d\t\tNull Records: %d\t\tNull in Play: %d\n", recordCount, nullSVID, nullInPlay)
}
