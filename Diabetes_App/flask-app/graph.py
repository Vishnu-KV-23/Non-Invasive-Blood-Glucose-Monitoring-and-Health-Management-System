import requests
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import time

# Flask server URL (updated to match your IP and port)
BASE_URL = "http://192.168.231.185:5001/conc_number"

# Initialize lists to store the data
timestamps = []
concentration_readings = []

# Function to fetch data from the Flask API
def fetch_data():
    try:
        response = requests.get(BASE_URL, timeout=5)
        response.raise_for_status()
        data = response.json()
        if "concentration_reading" in data:
            return data["concentration_reading"]
        else:
            print("Invalid response format")
            return None
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")
        return None

# Function to update the graph
def update(frame):
    # Fetch the latest reading
    concentration = fetch_data()
    if concentration is not None:
        # Update the data lists
        timestamps.append(time.time())  # Current time as x-axis
        concentration_readings.append(concentration)

        # Keep only the last 20 readings for a clean graph
        if len(timestamps) > 20:
            timestamps.pop(0)
            concentration_readings.pop(0)

        # Clear the plot and redraw
        plt.cla()
        plt.plot(timestamps, concentration_readings, marker='o', label="Concentration")
        plt.xlabel("Time (s)")
        plt.ylabel("Concentration Reading")
        plt.title("Real-Time Glucose Concentration Readings")
        plt.legend(loc="upper left")
        plt.tight_layout()

# Initialize the graph
fig = plt.figure(figsize=(10, 5))
ani = FuncAnimation(fig, update, interval=1000)  # Update every second

# Display the graph
plt.show()
