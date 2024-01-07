#! /usr/bin/bash

wrk -H 'Connection: keep-alive' --connections 64 --threads 16 --duration 15 --timeout 1 "http://127.0.0.1:3000/get_git_program/%2Fhome%2Fbimbal%2FDevelopment%2Fplayground%2Fbenchmark-source-controls%2F.repo/505130931b37ed91d80b32dfdd0f26b7de228c92"
wrk -H 'Connection: keep-alive' --connections 256 --threads 16 --duration 15 --timeout 1 "http://127.0.0.1:3000/get_git_program/%2Fhome%2Fbimbal%2FDevelopment%2Fplayground%2Fbenchmark-source-controls%2F.repo/505130931b37ed91d80b32dfdd0f26b7de228c92"
wrk -H 'Connection: keep-alive' --connections 512 --threads 16 --duration 15 --timeout 1 "http://127.0.0.1:3000/get_git_program/%2Fhome%2Fbimbal%2FDevelopment%2Fplayground%2Fbenchmark-source-controls%2F.repo/505130931b37ed91d80b32dfdd0f26b7de228c92"