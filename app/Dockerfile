# ----- Build Stage -----
    FROM python:3.10-slim AS build-stage

    # Set working directory
    WORKDIR /app
    
    # Install dependencies separately (better caching)
    COPY requirements.txt .
    
    # Install Python packages securely (no cache)
    RUN pip install --upgrade pip \
        && pip install --no-cache-dir -r requirements.txt
    
    # Copy application code
    COPY . .
    
    # ----- Final Stage -----
    FROM python:3.10-slim
    
    # Create a non-root user (security best practice)
    RUN useradd --create-home appuser
    USER appuser
    
    # Set working directory
    WORKDIR /home/appuser/app
    
    # Copy installed dependencies and code from build stage
    COPY --from=build-stage /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
    COPY --from=build-stage /usr/local/bin /usr/local/bin
    COPY --from=build-stage /app .
    
    # Expose the container port
    EXPOSE 8000
    
    # Set environment variables for production (can override at runtime)
    ENV PYTHONDONTWRITEBYTECODE=1 \
        PYTHONUNBUFFERED=1 \
        DATABASE_URL=""
    
    # Run the app securely
    CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
    