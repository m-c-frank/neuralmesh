# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the requirements file into the container at /usr/src/app
# Adjust the path to the requirements.txt file relative to the root of the repository
COPY scripts/requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application's source code from your host to your image filesystem.
# Adjust the paths for any other files or directories you need to copy from the scripts directory or elsewhere
COPY . .

# The rest of your Dockerfile commands...

