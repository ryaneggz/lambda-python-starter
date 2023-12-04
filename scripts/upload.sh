#!/bin/bash
# set -x ## Debugging

VERSION="0.0.23"

# Define the name of the archive
function_name='loader_lambda'
archive_name="$function_name-$VERSION.zip"

# Define the directory of the project to be zipped.
# This example assumes that the project directory is the parent directory of the scripts directory.
project_directory="$(dirname "$(dirname "$(realpath "$0")")")"

# Navigate to the project directory
cd "$project_directory" || exit 1

# Check if the "zips" directory exists, if not, create it.
if [[ ! -d "./zips" ]]; then
  mkdir "./zips"
fi

# Create a zip archive of the project directory, excluding the scripts directory and any .git directory.
# zip -r "./zips/$archive_name" . -x "scripts/*" "zips/*" ".venv/*" "__pycache__/*" "requirements.txt" ".gitignore"
# zip -r "./zips/$archive_name" lambda_function.py packages/

# Navigate to the packages directory
cd packages

# Zip the contents of the packages directory
zip -r "../zips/$archive_name" ./*

# Navigate back to the project directory
cd ..

# Add lambda_function.py to the zip
zip -g "./zips/$archive_name" lambda_function.py

## Check Size
ls -lh "./zips/$archive_name"

# Move the archive to a specific directory if needed, or just leave it in the project directory.
# mv "$archive_name" /path/to/destination_directory

echo "Project has been zipped and saved as $archive_name"

# Check if "deploy" is passed as an argument
if [[ $1 == "deploy" ]]; then
  aws lambda update-function-code \
  --function-name $function_name \
  --zip-file fileb://zips/$archive_name > /dev/null 2>&1
  echo "Lambda $function_name has been updated with $archive_name"
else
  echo "To deploy, pass 'deploy' as an argument."
fi

###################################################
### WAS USED FOR LOCAL TO TES WITH DIFFERENT KEYS
###################################################
# Check if "deploy" is passed as an argument
# if [[ $1 == "deploy" ]]; then
#   # Load the .env file
#   if [[ -f ".env" ]]; then
#     while IFS='' read -r line || [[ -n "$line" ]]; do
#       if [[ $line =~ ^[^#].*=.* ]]; then
#         export $line
#       fi
#     done < ".env"
#   else
#     echo ".env file not found!"
#     exit 1
#   fi

#   # Set AWS credentials as environment variables
#   export AWS_ACCESS_KEY_ID="$AWS_DEFAULT_ACCESS_KEY"
#   export AWS_SECRET_ACCESS_KEY="$AWS_DEFAULT_SECRET_KEY"
#   export AWS_DEFAULT_REGION="$AWS_LAMBDA_REGION"

#   # Deploy the function using AWS CLI
#   aws lambda update-function-code \
#   --function-name $function_name \
#   --zip-file fileb://zips/$archive_name > /dev/null 2>&1
#   # aws lambda update-function-code \
#   # --function-name $function_name \
#   # --zip-file fileb://zips/$archive_name
  
  
#   if [[ $? -eq 0 ]]; then
#     echo "Lambda $function_name has been updated with $archive_name"
#   else
#     echo "Failed to update Lambda function."
#     exit 1
#   fi
# else
#   echo "To deploy, pass 'deploy' as an argument."
# fi