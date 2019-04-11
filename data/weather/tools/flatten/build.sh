#!/usr/bin/env bash

go build -o flatten main.go
GOOS="windows" GOARCH="amd64" go build -o flatten.exe main.go
