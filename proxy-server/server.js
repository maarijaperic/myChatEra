const express = require('express');
const cors = require('cors');
const axios = require('axios');
require('dotenv').config();

// Debug: Check environment variables
console.log('=== ENVIRONMENT VARIABLES DEBUG ===');
console.log('PORT:', process.env.PORT);
console.log('OPENAI_API_KEY exists:', !!process.env.OPENAI_API_KEY);
console.log('OPENAI_API_KEY length:', process.env.OPENAI_API_KEY ? process.env.OPENAI_API_KEY.length : 0);
console.log('OPENAI_API_KEY starts with:', process.env.OPENAI_API_KEY ? process.env.OPENAI_API_KEY.substring(0, 10) + '...' : 'NOT SET');
console.log('All env vars with OPENAI:', Object.keys(process.env).filter(k => k.includes('OPENAI')));
console.log('===================================');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Simple rate limiting (optional - adjust as needed)
const rateLimitMap = new Map();
const RATE_LIMIT_WINDOW = 60000; // 1 minute
const MAX_REQUESTS_PER_WINDOW = 100;

function rateLimit(req, res, next) {
  const clientId = req.ip;
  const now = Date.now();
  
  if (!rateLimitMap.has(clientId)) {
    rateLimitMap.set(clientId, { count: 1, resetTime: now + RATE_LIMIT_WINDOW });
    return next();
  }
  
  const limit = rateLimitMap.get(clientId);
  
  if (now > limit.resetTime) {
    limit.count = 1;
    limit.resetTime = now + RATE_LIMIT_WINDOW;
    return next();
  }
  
  if (limit.count >= MAX_REQUESTS_PER_WINDOW) {
    return res.status(429).json({ error: 'Too many requests. Please try again later.' });
  }
  
  limit.count++;
  next();
}

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'OpenAI Proxy Server is running' });
});

// Proxy endpoint for OpenAI API
app.post('/api/chat', rateLimit, async (req, res) => {
  try {
    const apiKey = process.env.OPENAI_API_KEY;
    
    // Debug: Check if API key is set (log first 10 chars only for security)
    console.log('[Proxy] OPENAI_API_KEY exists:', !!apiKey);
    console.log('[Proxy] OPENAI_API_KEY starts with:', apiKey ? apiKey.substring(0, 10) + '...' : 'NOT SET');
    
    if (!apiKey) {
      console.error('OPENAI_API_KEY is not set in environment variables');
      console.error('Available env vars:', Object.keys(process.env).filter(k => k.includes('OPENAI')));
      return res.status(500).json({ 
        error: 'Server configuration error. Please contact support.' 
      });
    }

    const { model, messages, temperature, max_tokens } = req.body;

    if (!model || !messages) {
      return res.status(400).json({ 
        error: 'Missing required fields: model and messages' 
      });
    }

    console.log(`[Proxy] Forwarding request to OpenAI - Model: ${model}, Messages: ${messages.length}`);

    const response = await axios.post(
      'https://api.openai.com/v1/chat/completions',
      {
        model: model || 'gpt-4o-mini',
        messages: messages,
        temperature: temperature || 0.7,
        max_tokens: max_tokens || 500,
      },
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`,
        },
        timeout: 30000, // 30 second timeout
      }
    );

    console.log(`[Proxy] OpenAI response status: ${response.status}`);

    res.json(response.data);
  } catch (error) {
    console.error('[Proxy] Error:', error.message);
    
    if (error.response) {
      // OpenAI API error
      console.error('[Proxy] OpenAI error response:', error.response.data);
      res.status(error.response.status).json({
        error: error.response.data.error?.message || 'OpenAI API error',
        details: error.response.data,
      });
    } else if (error.request) {
      // Request made but no response
      res.status(503).json({
        error: 'OpenAI API is not responding. Please try again later.',
      });
    } else {
      // Error setting up request
      res.status(500).json({
        error: 'Internal server error',
        message: error.message,
      });
    }
  }
});

// Start server
// Listen on all network interfaces (0.0.0.0) to allow access from other devices
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 OpenAI Proxy Server running on port ${PORT}`);
  console.log(`📝 Health check: http://localhost:${PORT}/health`);
  console.log(`🌐 Server accessible from network devices`);
  console.log(`🔒 Make sure OPENAI_API_KEY is set in .env file`);
});


