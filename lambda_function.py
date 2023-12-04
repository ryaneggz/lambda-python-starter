from promptengineers.repos.user import UserRepo
from promptengineers.controllers.retrieval import accumulate_loaders
from promptengineers.services.pinecone import PineconeService
from langchain.embeddings.openai import OpenAIEmbeddings

APP_ENV = 'development'

def lambda_handler(event, context):
    # TODO implement
    pinecone_keys = ['PINECONE_KEY', 'PINECONE_ENV', 'PINECONE_INDEX', 'OPENAI_API_KEY']
    loaders = accumulate_loaders(event.get('data'))
    tokens = UserRepo().find_token(
        event.get('user_id'),
        pinecone_keys
    )
    embeddings = OpenAIEmbeddings(openai_api_key=tokens.get('OPENAI_API_KEY'))
    pinecone_service = PineconeService(
        api_key=tokens.get('PINECONE_KEY'),
        env=tokens.get('PINECONE_ENV'),
        index_name=tokens.get('PINECONE_INDEX'),
    )
    result = pinecone_service.from_documents(
        loaders,
        embeddings,
        namespace=event.get('data').get('index_name')
    )
    

    # Checking if the request was successful
    if result:
        # Parsing the JSON response
        return {
            'statusCode': 200,
            'data': f"Index [{event.get('data').get('index_name')}] created successfully"
        }
    else:
        print(f"Failed to retrieve data")
        return {
            'statusCode': 500,
        }

if __name__ == '__main__' and APP_ENV == 'development':
    event = {
        "user_id": "000000000000000000000000",
        "data": {
            "index_name": "test-index",
            "loaders": [
                {
                    "type": "copy",
                    "text": "In a quiet village, a young girl discovered a mysterious, glowing stone in the forest. Each night, the stone guided her to help people in secret, solving problems while everyone slept. Over time, the village flourished, and stories of an invisible guardian spread far and wide."
                }
            ]
        }
    }

    context = {}

    response = lambda_handler(event, context)
    print(response)