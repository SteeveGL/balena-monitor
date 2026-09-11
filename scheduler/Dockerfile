# Use a Balena-optimized Alpine image for the Raspberry Pi 3
FROM balenalib/raspberrypi3-alpine:latest

# Install bash, coreutils, and xrandr utilities
RUN apk add --no-cache bash coreutils xrandr

# Set up the working directory inside the container
WORKDIR /usr/src/app

# Copy the script from your local scheduler folder into the container
COPY check_schedule.sh .

# Ensure the script has execution permissions
RUN chmod +x check_schedule.sh

# Run the script immediately on boot, THEN loop every 60 seconds (1 minute is safer than 5)
CMD ["/bin/bash", "-c", "while true; do ./check_schedule.sh; sleep 60; done"]
