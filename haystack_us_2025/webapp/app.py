from flask import Flask, render_template, request, jsonify, session
import os
import json
from openai import OpenAI
from dotenv import load_dotenv
import requests

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.secret_key = os.urandom(24)  # For session management

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# Vespa API settings
VESPA_API_URL = "https://dbe4de4d.b0d2b4c8.z.vespa-app.cloud/search/"
CERT_PATH = "/Users/radu/.vespa/training1.haystack.default/data-plane-public-cert.pem"
KEY_PATH = "/Users/radu/.vespa/training1.haystack.default/data-plane-private-key.pem"

def load_system_prompt():
    """Load the system prompt from file"""
    with open(os.path.join(os.path.dirname(__file__), "system_prompt.txt"), "r") as f:
        return f.read()

def extract_json_from_response(response):
    """Extract JSON data from the OpenAI response"""
    try:
        json_str = response.split("===")[1].strip()
        if json_str.startswith("JSON"):
            json_str = json_str[4:].strip()
        return json.loads(json_str)
    except Exception as e:
        print(f"Error parsing JSON: {e}")
        return None

def query_vespa(preferences):
    """Query Vespa with user preferences"""
    # Convert preferences to Vespa feature format
    features = []
    for key, value in preferences.items():
        if key in ['make', 'model']:
            # Handle make/model specially
            features.append(f"{{features:{key.lower()}}}:{value}")
        else:
            features.append(f"{{features:{key}}}:{value}")
    
    # Construct the query
    query = {
        "yql": "select * from product where true",
        "hits": 10,
        "ranking": "rank_cars",
        "presentation.summary": "attributes",
        "ranking.features.query(user_preferences)": '{' + ','.join(features) + '}',
        "trace.level": 0
    }
    
    try:
        # Use mTLS certificates for authentication
        response = requests.post(
            VESPA_API_URL, 
            json=query,
            cert=(CERT_PATH, KEY_PATH)
        )
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error querying Vespa: {e}")
        if hasattr(e, 'response') and hasattr(e.response, 'text'):
            print(f"Response body: {e.response.text}")
        return None

@app.route('/')
def index():
    """Render the main page"""
    # Initialize a new session if needed
    if 'messages' not in session:
        session['messages'] = []
    return render_template('index.html', messages=session['messages'])

@app.route('/api/chat', methods=['POST'])
def chat():
    """Handle chat messages"""
    data = request.json
    user_message = data.get('message', '')
    
    # Initialize or get conversation history
    if 'messages' not in session:
        session['messages'] = []
        
    # Add user message to history
    session['messages'].append({"role": "user", "content": user_message})
    
    # Prepare messages for OpenAI
    openai_messages = [
        {"role": "system", "content": load_system_prompt()}
    ] + session['messages']
    
    try:
        # Get response from OpenAI
        response = client.chat.completions.create(
            model="gpt-4o",  # Using a better model as requested
            messages=openai_messages,
            temperature=0.7,
        )
        
        # Extract assistant's response
        assistant_response = response.choices[0].message.content
        
        # Add assistant response to session history
        session['messages'].append({"role": "assistant", "content": assistant_response})
        session.modified = True  # Ensure session is saved
        
        # Extract JSON preferences if present
        json_data = extract_json_from_response(assistant_response)
        
        # Query Vespa if we have preferences
        search_results = None
        if json_data:
            search_results = query_vespa(json_data)
        
        return jsonify({
            'response': assistant_response,
            'preferences': json_data,
            'search_results': search_results
        })
        
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/api/reset', methods=['POST'])
def reset_conversation():
    """Reset the conversation history"""
    session['messages'] = []
    return jsonify({'status': 'success'})

if __name__ == '__main__':
    app.run(debug=True) 