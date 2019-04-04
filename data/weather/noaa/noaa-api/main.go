package main

import (
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"path"
	"time"
)

var (
	baseURL   = "https://www.ncdc.noaa.gov/cdo-web/api/v2/"
	tokenFile = flag.String("token", "", "File containing the token used for API access")
	request   = flag.String("request", "", "The request to be made")
	east      = flag.String("east", "", "Eastern bounds of search location")
	west      = flag.String("west", "", "Western bounds of search location")
	north     = flag.String("north", "", "Northern bounds of search location")
	south     = flag.String("south", "", "Southern bounds of search location")
)

func main() {
	flag.Parse()

	if len(*tokenFile) == 0 {
		log.Fatalf("Please supply a token file via the -token flag\n")
	}
	if len(*request) == 0 {
		log.Fatalf("Please supply a request via the -request flag\n")
	}

	//The token is required to use the API
	token, err := getToken(*tokenFile)
	if err != nil {
		log.Fatal(err)
	}

	requestURL, err := getRequestURL(token)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(requestURL)
	fetchData(requestURL, token, *request)
}

func getToken(path string) (string, error) {
	content, err := ioutil.ReadFile(path)
	if err != nil {
		return "", err
	}

	return string(content), nil
}

func getRequestURL(token string) (string, error) {
	switch *request {
	case "stations":
		return stationURL(token), nil
	default:
		return "", fmt.Errorf("Unrecognized request: %s", *request)
	}
}

func stationURL(token string) string {
	req, err := url.Parse(baseURL)
	if err != nil {
		log.Fatal(err)
	}
	req.Path = path.Join(req.Path, "stations")

	var extent string
	if len(*north) > 0 && len(*south) > 0 && len(*east) > 0 && len(*west) > 0 {
		q := req.Query()
		extent = fmt.Sprintf("%s,%s,%s,%s", *south, *west, *north, *east)
		q.Add("extent", extent)
		req.RawQuery = q.Encode()
	}
	return req.String()
}

func fetchData(url, token, outputFile string) {
	client := &http.Client{
		Timeout: 20 * time.Second,
	}
	req, err := http.NewRequest("GET", url, nil)
	req.Header.Add("token", token)
	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	// Create the file
	out, err := os.Create(outputFile)
	if err != nil {
		log.Fatal(err)
	}
	defer out.Close()

	// Write the body to file
	_, err = io.Copy(out, resp.Body)
	if err != nil {
		log.Fatal(err)
	}
}
