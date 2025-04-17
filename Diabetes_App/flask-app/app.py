from flask import Flask, request, jsonify
from flask_cors import CORS
from tensorflow.keras.models import load_model
import numpy as np
import random


app = Flask(__name__)
CORS(app)  # Allow cross-origin requests for development

# Load your trained model
model = load_model(r"C:\Users\Kumar\Desktop\Diabetes app\app-diabetes-monitoring\flask-app\NN_deployed_in_app.h5")
# Simulated real-time concentration reading
current_concentration = random.randint(80, 120)  # Example: Random initial glucose level

@app.route('/conc_number', methods=['GET'])
def get_concentration():
    global current_concentration
    # Simulate concentration changes
    current_concentration += random.randint(-5, 5)  # Random change within a small range
# Ensure the concentration stays within a reasonable range
    current_concentration = max(80, min(current_concentration, 120))
    return jsonify({'concentration_reading': current_concentration})

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    input_data = np.array(data['input']).reshape((1, 9))  # Assumes 9 input features
    prediction = model.predict(input_data)
    prediction_value = prediction.item()
    return jsonify({'prediction': prediction_value})
# Simulate a simple email/password check
valid_email = "test@example.com"
valid_password = "password123"

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    # Validate the credentials
    if email == valid_email and password == valid_password:
        return jsonify({'success': True})
    else:
        return jsonify({'success': False, 'message': 'Invalid credentials'}), 401

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)