#!/bin/bash

# set -x ## Debugging

### Set Environment Variables
set -a # automatically export all variables
source .env.local
set +a

# Define the directory of the project to be zipped.
# This example assumes that the project directory is the parent directory of the scripts directory.
project_directory="$(dirname "$(dirname "$(realpath "$0")")")"

# Navigate to the project directory
cd "$project_directory" || exit 1

rm -rf ./test

if [[ ! -d "./test" ]]; then
  mkdir "./test"
fi

cp lambda_function.py ./test/
cp -r packages/* ./test/

## Check Size
du -sh "./test"

python ./test/lambda_function.py