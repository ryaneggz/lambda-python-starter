#!/bin/bash

# Check if the "zips" directory exists, if not, create it.
if [[ ! -d "./packages" ]]; then
  mkdir "./packages"
fi

pip install --upgrade -r requirements.txt -t packages/