from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict, Optional
import os
from openai import OpenAI
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize FastAPI app
app = FastAPI(title="OpenAI Proxy Server", version="1.0.0")

# CORS middleware - allow all origins (you can restrict this in production)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your Flutter app domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Get OpenAI API key from environment
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

if not OPENAI_API_KEY:
    print("⚠️  WARNING: OPENAI_API_KEY is not set in environment variables")
    client = None
else:
    print(f"✅ OPENAI_API_KEY loaded (starts with: {OPENAI_API_KEY[:10]}...)")
    # Initialize OpenAI client
    client = OpenAI(api_key=OPENAI_API_KEY)

# Request/Response models
class Message(BaseModel):
    role: str
    content: str

class ChatRequest(BaseModel):
    model: Optional[str] = "gpt-4o-mini"
    messages: List[Message]
    temperature: Optional[float] = 0.7
    max_tokens: Optional[int] = 500

class HealthResponse(BaseModel):
    status: str
    message: str

class AppVersionResponse(BaseModel):
    useFakeVersion: bool

# Health check endpoint
@app.get("/health", response_model=HealthResponse)
async def health_check():
    return {
        "status": "ok",
        "message": "OpenAI Proxy Server is running"
    }

# App version endpoint - controls whether to use fake (import) or real (web view) login
# Set USE_FAKE_VERSION environment variable to "true" to enable fake version for App Store review
@app.get("/api/app-version", response_model=AppVersionResponse)
async def get_app_version():
    use_fake_version = os.getenv("USE_FAKE_VERSION", "false").lower() == "true"
    return {
        "useFakeVersion": use_fake_version
    }

# Proxy endpoint for OpenAI API
@app.post("/api/chat")
async def chat_completion(request: ChatRequest):
    try:
        # Check if API key is set
        if not OPENAI_API_KEY or not client:
            raise HTTPException(
                status_code=500,
                detail="Server configuration error. OPENAI_API_KEY is not set."
            )

        # Validate request
        if not request.messages:
            raise HTTPException(
                status_code=400,
                detail="Missing required field: messages"
            )

        print(f"[Proxy] Forwarding request to OpenAI - Model: {request.model}, Messages: {len(request.messages)}")

        # Convert messages to OpenAI format
        openai_messages = [
            {"role": msg.role, "content": msg.content}
            for msg in request.messages
        ]

        # Call OpenAI API
        response = client.chat.completions.create(
            model=request.model,
            messages=openai_messages,
            temperature=request.temperature,
            max_tokens=request.max_tokens,
        )

        print(f"[Proxy] OpenAI response status: 200 OK")

        # Return response in format compatible with Flutter app
        return {
            "id": response.id,
            "object": response.object,
            "created": response.created,
            "model": response.model,
            "choices": [
                {
                    "index": choice.index,
                    "message": {
                        "role": choice.message.role,
                        "content": choice.message.content
                    },
                    "finish_reason": choice.finish_reason
                }
                for choice in response.choices
            ],
            "usage": {
                "prompt_tokens": response.usage.prompt_tokens,
                "completion_tokens": response.usage.completion_tokens,
                "total_tokens": response.usage.total_tokens
            }
        }

    except Exception as e:
        error_type = type(e).__name__
        print(f"[Proxy] Error ({error_type}): {e}")
        
        # Handle different OpenAI error types
        error_str = str(e).lower()
        if "authentication" in error_str or "api key" in error_str:
            raise HTTPException(
                status_code=401,
                detail=f"OpenAI API authentication error: {str(e)}"
            )
        elif "rate limit" in error_str:
            raise HTTPException(
                status_code=429,
                detail="OpenAI API rate limit exceeded. Please try again later."
            )
        elif "api" in error_str:
            raise HTTPException(
                status_code=500,
                detail=f"OpenAI API error: {str(e)}"
            )
    except Exception as e:
        print(f"[Proxy] Error: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Internal server error: {str(e)}"
        )

# Root endpoint
@app.get("/")
async def root():
    return {
        "message": "OpenAI Proxy Server",
        "version": "1.0.0",
        "endpoints": {
            "health": "/health",
            "chat": "/api/chat"
        }
    }

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 8000))
    print(f"🚀 Starting OpenAI Proxy Server on port {port}")
    print(f"📝 Health check: http://localhost:{port}/health")
    print(f"🌐 Server accessible from network devices")
    if OPENAI_API_KEY:
        print(f"🔒 OPENAI_API_KEY is set")
    else:
        print(f"⚠️  WARNING: OPENAI_API_KEY is not set!")
    
    uvicorn.run(app, host="0.0.0.0", port=port)

