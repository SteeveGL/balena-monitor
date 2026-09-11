# balena-monitor

A solution for monitoring and managing the display state of an embedded device using containerization. This project allows for scheduling display power on and off based on defined time intervals.

## 🚀 Features
*   **Containerized:** Uses Docker for portable deployment.
*   **Time Scheduling:** Automatically manages display power cycles.
*   **Flexible Configuration:** Supports environment variable overrides for timing and display output.

## 🔧 Prerequisites
Before running `balena-monitor`, ensure you have the following installed:
*   Docker
*   Docker Compose

## 📦 Installation and Setup
1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/SteeveGL/balena-monitor.git
    cd balena-monitor
    ```
2.  **Build and Run:**
    Use `docker-compose` to build the scheduler image and start the services.
    ```bash
    docker-compose up --build -d
    ```

## ⚙️ Configuration
The behavior of the containers is controlled by environment variables, especially within the `scheduler` service.

### Environment Variables
*   **`SCHEDULE_OFF_TIME`**: The time (HH:MM) when the display should be turned off. (Default: `23:00`)
*   **`SCHEDULE_ON_TIME`**: The time (HH:MM) when the display should be turned on. (Default: `06:30`)
*   **`SCHEDULE_PRIMARY_DISPLAY`**: The exact name of the display output on the device (e.g., `HDMI-1`, `DP-1`). This **must** be verified using `xrandr` on the host system. (Default: `HDMI-1`)
*   **`scheduler: DISPLAY`**: Set to `host` in `docker-compose.yml` to correctly expose the host's display environment to the scheduler container.

## 🗒️ How it works
The `scheduler` container runs a shell script that checks the current time against the configured schedule. If the time matches, it uses the `xrandr` command to either turn the specified display output on or off.
