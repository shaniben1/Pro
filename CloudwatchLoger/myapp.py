import json





def handler(event, context):
    # Print the entire event object to see the structure
    print("Received event:", json.dumps(event))

    # Check if the event contains a body
    if 'body' in event:
        # Parse the body from JSON to Python dictionary
        body = json.loads(event['body'])
        print("Received payload:", json.dumps(body))
    else:
        print("No payload found in the event body")

    return {
        'statusCode': 200,
        'body': json.dumps('Payload printed successfully')
    }






