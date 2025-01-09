# Base image
FROM  nvcr.io/nvidia/pytorch:22.07-py3

# Set up environment variables to reduce image size
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /

# Copy dependency files first for better caching
COPY requirements.txt requirements.txt
COPY pyproject.toml pyproject.toml

# Install dependencies with pip cache enabled
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt

# Install your project with pip cache enabled (assuming it's a local package)
RUN --mount=type=cache,target=/root/.cache/pip pip install . --no-deps

# Copy the rest of the application files
COPY src/ src/
COPY data/ data/

# Set the entry point for the container
ENTRYPOINT ["python", "-u", "src/tester/train.py"]
