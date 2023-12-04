import os
import sys
import json
import requests

from promptengineers.repos.user import UserRepo

APP_ENV = 'development'

def lambda_handler(event, context):
    # TODO implement
    pinecone_keys = ['PINECONE_KEY', 'PINECONE_ENV', 'PINECONE_INDEX', 'OPENAI_API_KEY']
    tokens = UserRepo().find_token(
        event.get('user_id'),
        pinecone_keys
    )

    # Checking if the request was successful
    if tokens:
        # Parsing the JSON response
        return {
            'statusCode': 200,
            'body': tokens
        }
    else:
        print(f"Failed to retrieve data")
        return {
            'statusCode': 500,
        }

if __name__ == '__main__' and APP_ENV == 'development':
    event = {
        'user_id': '000000000000000000000000'
    }

    context = {}

    response = lambda_handler(event, context)
    print(response)