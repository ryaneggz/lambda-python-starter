import os
import sys
import json
import requests

APP_ENV = 'development'

def lambda_handler(event, context):
    # TODO implement
    response = requests.get(event.get('url'))

    # Checking if the request was successful
    if response.status_code == 200:
        # Parsing the JSON response
        data = response.json()
        return {
            'statusCode': response.status_code,
            'body': data
        }
    else:
        print(f"Failed to retrieve data: {response.status_code}")
        return {
            'statusCode': response.status_code,
            'body': response.json()
        }

if __name__ == '__main__' and APP_ENV == 'development':
    event = {
        'url': 'https://jsonplaceholder.typicode.com/todos/1'
    }

    context = {}

    response = lambda_handler(event, context)
    print(response)