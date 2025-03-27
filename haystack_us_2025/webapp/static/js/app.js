document.addEventListener('DOMContentLoaded', function() {
    // Elements
    const chatContainer = document.getElementById('chat-container');
    const userInput = document.getElementById('user-input');
    const sendBtn = document.getElementById('send-btn');
    const resetBtn = document.getElementById('reset-btn');
    const loadingOverlay = document.getElementById('loading-overlay');
    const resultsContainer = document.getElementById('results-container');
    const preferencesPillContainer = document.getElementById('preferences-pill-container');
    const preferencesPills = document.getElementById('preferences-pills');
    
    // Templates
    const messageTemplate = document.getElementById('message-template');
    const carCardTemplate = document.getElementById('car-card-template');
    
    // Event Listeners
    sendBtn.addEventListener('click', sendMessage);
    resetBtn.addEventListener('click', resetConversation);
    userInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });
    
    // Initialize any existing messages from session
    function initializeMessages() {
        // If we're using server-side rendering and messages are pre-loaded,
        // we could populate them here
    }
    
    // Send message function
    async function sendMessage() {
        const message = userInput.value.trim();
        if (!message) return;
        
        // Add user message to chat
        addMessage(message, true);
        userInput.value = '';
        
        // Show loading
        loadingOverlay.classList.remove('d-none');
        
        try {
            const response = await fetch('/api/chat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ message }),
            });
            
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            
            const data = await response.json();
            
            // Hide loading
            loadingOverlay.classList.add('d-none');
            
            // Add assistant response
            addMessage(data.response, false);
            
            // Display preferences if available
            if (data.preferences) {
                displayPreferences(data.preferences);
            }
            
            // Display search results if available
            if (data.search_results) {
                displaySearchResults(data.search_results);
            } else {
                // Show initial state if no results
                resultsContainer.innerHTML = `
                <div class="initial-state">
                    <div class="text-center p-5">
                        <i class="fas fa-car-side fa-4x mb-3"></i>
                        <h3>Looking for your perfect car?</h3>
                        <p>Tell me about your preferences, and I'll help you find matching cars.</p>
                        <p class="text-muted">For example: "I want a cheap car that's fuel efficient"</p>
                    </div>
                </div>`;
            }
        } catch (error) {
            console.error('Error:', error);
            
            // Hide loading
            loadingOverlay.classList.add('d-none');
            
            // Add error message
            addMessage('Sorry, there was an error processing your request. Please try again.', false);
        }
    }
    
    // Add message to chat
    function addMessage(content, isUser) {
        const messageNode = messageTemplate.content.cloneNode(true);
        const messageDiv = messageNode.querySelector('.message');
        const messageContent = messageNode.querySelector('.message-content');
        
        messageDiv.classList.add(isUser ? 'user' : 'assistant');
        messageContent.textContent = content;
        
        chatContainer.appendChild(messageNode);
        
        // Scroll to bottom
        chatContainer.scrollTop = chatContainer.scrollHeight;
    }
    
    // Display preferences as pills
    function displayPreferences(preferences) {
        preferencesPills.innerHTML = '';
        
        Object.entries(preferences).forEach(([key, value]) => {
            const pill = document.createElement('div');
            pill.className = 'preference-pill';
            
            const valueStr = value >= 0 ? `+${value}` : value;
            const label = key.charAt(0).toUpperCase() + key.slice(1);
            
            pill.innerHTML = `${label} <span class="preference-weight">${valueStr}</span>`;
            preferencesPills.appendChild(pill);
        });
        
        preferencesPillContainer.classList.remove('d-none');
    }
    
    // Display search results
    function displaySearchResults(results) {
        // Clear previous results
        resultsContainer.innerHTML = '';
        
        if (!results || !results.root || !results.root.children || results.root.children.length === 0) {
            resultsContainer.innerHTML = `
            <div class="text-center p-5">
                <i class="fas fa-search fa-3x mb-3 text-muted"></i>
                <h3>No matching cars found</h3>
                <p>Try adjusting your preferences to see more results.</p>
            </div>`;
            return;
        }
        
        // Create and append car cards
        results.root.children.forEach(hit => {
            const fields = hit.fields || {};
            
            const cardNode = carCardTemplate.content.cloneNode(true);
            const card = cardNode.querySelector('.car-card');
            
            // Set card content
            card.querySelector('.car-title').textContent = `${fields.make || 'Unknown'} ${fields.model || 'Unknown'}`;
            card.querySelector('.car-price').textContent = fields.price ? `$${fields.price}` : 'Price unknown';
            
            const details = card.querySelector('.car-details');
            if (fields.year) {
                const yearSpan = document.createElement('span');
                yearSpan.className = 'car-year';
                yearSpan.innerHTML = `<i class="fas fa-calendar-alt"></i> ${fields.year}`;
                details.appendChild(yearSpan);
            }
            
            if (fields.mileage) {
                const mileageSpan = document.createElement('span');
                mileageSpan.className = 'car-mileage';
                mileageSpan.innerHTML = `<i class="fas fa-road"></i> ${fields.mileage} mi`;
                details.appendChild(mileageSpan);
            }
            
            if (fields.transmission) {
                const transSpan = document.createElement('span');
                transSpan.className = 'car-transmission';
                transSpan.innerHTML = `<i class="fas fa-cog"></i> ${fields.transmission}`;
                details.appendChild(transSpan);
            }
            
            if (fields.fuelType) {
                const fuelSpan = document.createElement('span');
                fuelSpan.className = 'car-fuel';
                fuelSpan.innerHTML = `<i class="fas fa-gas-pump"></i> ${fields.fuelType}`;
                details.appendChild(fuelSpan);
            }
            
            if (fields.mpg) {
                const mpgSpan = document.createElement('span');
                mpgSpan.className = 'car-mpg';
                mpgSpan.innerHTML = `<i class="fas fa-tachometer-alt"></i> ${fields.mpg} MPG`;
                details.appendChild(mpgSpan);
            }
            
            resultsContainer.appendChild(cardNode);
        });
    }
    
    // Reset conversation
    async function resetConversation() {
        try {
            await fetch('/api/reset', {
                method: 'POST'
            });
            
            // Clear chat
            chatContainer.innerHTML = '';
            
            // Clear results
            resultsContainer.innerHTML = `
            <div class="initial-state">
                <div class="text-center p-5">
                    <i class="fas fa-car-side fa-4x mb-3"></i>
                    <h3>Looking for your perfect car?</h3>
                    <p>Tell me about your preferences, and I'll help you find matching cars.</p>
                    <p class="text-muted">For example: "I want a cheap car that's fuel efficient"</p>
                </div>
            </div>`;
            
            // Hide preferences
            preferencesPillContainer.classList.add('d-none');
            preferencesPills.innerHTML = '';
            
        } catch (error) {
            console.error('Error resetting conversation:', error);
        }
    }
    
    // Initialize
    initializeMessages();
}); 