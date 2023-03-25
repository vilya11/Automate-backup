#!/bin/bash
#pass=1234
openssl aes-256-cbc -salt -in SecretKey.txt -out secretKey.enc -k 1234