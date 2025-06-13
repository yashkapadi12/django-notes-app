# FROM python:3.9

# WORKDIR /app/backend

# COPY requirements.txt /app/backend
# RUN pip install -r requirements.txt

# COPY . /app/backend

# EXPOSE 8000

# CMD python /app/backend/manage.py runserver 0.0.0.0:8000
FROM python:3.9

# Create working directory
WORKDIR /app/backend

# Create non-root user and group
RUN groupadd -r appgroup && useradd -m -r -g appgroup appuser

# Copy requirements and install dependencies
COPY requirements.txt /app/backend
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code and give ownership to appuser
COPY . /app/backend
RUN chown -R appuser:appgroup /app/backend


EXPOSE 8000

# Run Django server
CMD ["python", "/app/backend/manage.py", "runserver", "0.0.0.0:8000"]
