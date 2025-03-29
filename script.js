const express = require('express');
const fs = require('fs');
const path = require('path');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;
const ITEMS_FILE = path.join(__dirname, 'items.json');
const RESPONSES_FILE = path.join(__dirname, 'responses.json');

if (!fs.existsSync(RESPONSES_FILE)) {
    fs.writeFileSync(RESPONSES_FILE, JSON.stringify({}, null, 2));
}

// Enable CORS middleware
app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', 'http://localhost:8080'); // Your frontend origin
    res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    next();
});

app.use(bodyParser.json());

if (!fs.existsSync(ITEMS_FILE)) {
    const initialsent = {
        items: ['Hello today is ___ January', 'February', 'March' , "more", "things", "to", "show", "afgrgr", "gsrg", "fsg"], 
        taken: []
    };
    fs.writeFileSync(ITEMS_FILE, JSON.stringify(initialsent, null, 2));
}

app.get('/get-item', (req, res) => {
    const data = JSON.parse(fs.readFileSync(ITEMS_FILE));
    const availableItems = data.items.filter(item => !data.taken.includes(item));
    var selectedItem 
    if (availableItems.length === 0 ) {
        return res.json({ 
            message: "no more items available",
            item: null,
            error: null,
            itemId: null
        });
    }
    
    const randomIndex = Math.floor(Math.random() * availableItems.length);
    selectedItem = availableItems[randomIndex];
    const itemId = data.items.indexOf(selectedItem); 
    
    // Mark item as taken
    data.taken.push(selectedItem);
    fs.writeFileSync(ITEMS_FILE, JSON.stringify(data, null, 2));

    res.json({ 
        item: selectedItem,
        error: null,
        message: "item assigned",
        itemId: itemId
    });
});

app.get('/all-items', (req, res) => {
    const data = JSON.parse(fs.readFileSync(ITEMS_FILE));
    res.json(data);
});

app.post('/save-response', (req, res) => {
    try {
        const { itemId, word1, word2 } = req.body;
        const responses = JSON.parse(fs.readFileSync(RESPONSES_FILE));
        
        const existingResponse = responses[itemId] || {};
        
        if (word1 !== undefined) existingResponse.word1 = word1;
        if (word2 !== undefined) existingResponse.word2 = word2;
        
        responses[itemId] = existingResponse;
        fs.writeFileSync(RESPONSES_FILE, JSON.stringify(responses, null, 2));
        
        res.json({ success: true });
    } catch (error) {
        console.error('Save error:', error);
        res.status(500).json({ error: "Failed to save response" });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
