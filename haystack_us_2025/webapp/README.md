# Car Preferences Web Application

A modern web application that helps users find the perfect car based on their preferences. The application uses GPT-4 to extract car preferences from natural language and Vespa for search rankings.

## Features

- Interactive chat interface for expressing car preferences
- Real-time preferences extraction and visual representation
- Manual preference adjustment with sliders (-5 to +5 range)
- Car search results with detailed information
- Responsive layout that works on desktop and mobile
- Session-based conversation history

## Installation

1. Set up a conda environment (recommended):
```bash
conda env create -f environment.yml
conda activate car_preferences
```

2. Create a `.env` file in the project root with your OpenAI API key:
```
OPENAI_API_KEY=your_api_key_here
```

## Running the Web Application

1. Start the Flask server:
```bash
python app.py
```

2. Open your browser and navigate to:
```
http://localhost:5000
```

## Usage

1. Type your car preferences in the chat input, for example:
   - "I want a cheap car that's fuel efficient"
   - "I'm looking for a manual transmission car, ideally an Audi A4"
   - "I need a family car with low mileage"

2. The system will analyze your preferences and:
   - Extract key preferences and assign importance weights
   - Show these preferences as colored pills above the search results
   - Display matching cars based on your preferences

3. **Manual preference adjustment**:
   - Click on any preference pill to open an adjustment slider
   - Use the slider to set your preferred weight from -5 to +5
   - Click "Apply" to update your search results with the new weight
   - Manual adjustments will be preserved in future chat interactions

4. Continue the conversation to refine your preferences and get better results.

5. Click "New Chat" to start over with a fresh conversation.

## Technical Details

- Frontend: HTML, CSS, JavaScript with Bootstrap 5
- Backend: Flask (Python)
- AI: OpenAI GPT-4o for preference extraction
- Search: Vespa for preference-based car ranking
- Authentication: mTLS for secure API communication
