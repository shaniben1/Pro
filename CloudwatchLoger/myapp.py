import json

def handler(event, context):
    # Extract information from GitHub webhook payload
    try:
        payload = json.loads(event['body'])
        repo_name = payload(['repository']['name'])

 #       if 'commits' in payload:
 #           for commit in payload['commits']:
 #               changed_files.extend(commit['added'])
 #               changed_files.extend(commit['modified'])
#                changed_files.extend(commit['removed'])
        changed_files = []
        if 'commits' in payload:
            for commit in payload['commits']:
                 if 'added' in commit:
                    changed_files.extend(commit['added'])
                 if 'modified' in commit:
                     changed_files.extend(commit['modified'])
                 if 'removed' in commit:
                     changed_files.extend(commit['removed'])

            # Log changed files to CloudWatch Logs
            if changed_files:
                log_message = "Changed files:\n" + '\n'.join(changed_files)
                print(log_message)  # This will be logged in CloudWatch Logs
                print("the repository name : {}" .format(repo_name))
            else:
                print("No files have been changed.")
        else:
            print("No commit information found in payload.")

    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('Internal Server Error')
        }

    return {
        'statusCode': 200,
        'body': json.dumps('Success')
    }