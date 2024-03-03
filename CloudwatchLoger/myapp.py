import json
import urllib.request  # library to send requests and get json

def handler(event, context):
    # Print the entire event object to see the structure
    print("Received event:", json.dumps(event))

    # Check if the event contains a body
    if 'body' in event:
        # action = closed merge_at !=null
        # Parse the body from JSON to Python dictionary
        body_dict = json.loads(event['body'])
        action = body_dict['action']
        merged = body_dict['pull_request']['merged']

        if action == 'closed' and merged:
            sha = body_dict['pull_request']['head']['sha']
            repo_name = body_dict['pull_request']['head']['repo']['name']

            # Extract commits_url from the event body
            commits_url = body_dict['repository']['commits_url']
            commits_url = commits_url[:-6]  # Remove "{/sha}" from the end of URL
            url = f'{commits_url}/{sha}'
            print(url)

            # Send GET request using urllib
            req = urllib.request.Request(url)
            with urllib.request.urlopen(req) as response:
                resp = response.read().decode('utf-8')

            resp_json = json.loads(resp)
            files = resp_json['files']

            print(f'Repository {repo_name} was changed:')
            for file in files:
                print(f"{file['filename']} was {file['status']}")
        else:
            print('pull request is not closed yet')
    else:
        print("No payload found in the event body")

    return {
        'statusCode': 200,
        'body': json.dumps('Payload printed successfully')
    }

