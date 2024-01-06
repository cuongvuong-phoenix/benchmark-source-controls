#! /usr/bin/bash

wrk -H 'Connection: keep-alive' --connections 64 --threads 16 --duration 15 --timeout 1 http://127.0.0.1:3000/ping