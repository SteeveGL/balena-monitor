# Use a Balena-optimized Alpine image for the Raspberry Pi
FROM balenalib/raspberrypi3-alpine:latest

# Install bash and any core tools you might need for display switching
RUN apk add --no-cache bash coreutils

# Set up the working directory inside the container
WORKDIR /usr/src/app

# Copy all the scripts from your local scheduler folder into the container
COPY check_schedule.sh .

# Ensure the script has execution permissions
RUN chmod +x check_schedule.sh

# Run your loop command
CMD ["/bin/bash", "-c", "while true; do sleep 30; ./check_schedule.sh; done"]
