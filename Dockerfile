# Use a lightweight Python image
FROM python:slim

# Copy the requirements file and install dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn pymysql cryptography

# Copy the app and other necessary files
COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./

# Make sure boot.sh is executable
RUN chmod a+x boot.sh

# Set environment variable for Flask app
ENV FLASK_APP microblog.py

# Compile translations (if applicable)
RUN flask translate compile

# Expose the port Flask will run on
EXPOSE 5000

# Set the entry point to boot.sh for starting the app
ENTRYPOINT ["./boot.sh"]
