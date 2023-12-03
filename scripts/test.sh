#!/bin/bash

# set -x ## Debugging

# Define the directory of the project to be zipped.
# This example assumes that the project directory is the parent directory of the scripts directory.
project_directory="$(dirname "$(dirname "$(realpath "$0")")")"

# Navigate to the project directory
cd "$project_directory" || exit 1

if [[ ! -d "./test" ]]; then
  mkdir "./test"
fi

cp lambda_function.py ./test/
cp -r packages/* ./test/

python ./test/lambda_function.py