# Use the official Python image as the base image
FROM public.ecr.aws/lambda/python:3.9

# Set the working directory inside the container
WORKDIR /app

# Copy the local code to the container's working directory
COPY . /app

# Install dependencies
RUN pip install --upgrade pip
RUN pip install flask

# Expose the port Flask is running on
EXPOSE 5000

# Set environment variables (optional)
ENV FLASK_APP=app.py

# Command to run the application
CMD ["flask", "run", "--host=0.0.0.0"]
