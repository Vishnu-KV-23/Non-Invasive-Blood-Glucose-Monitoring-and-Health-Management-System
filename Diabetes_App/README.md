# Diabetes Prediction

A fully-connected neural network was implemented using various human condition features. A dataset encompassing diverse age groups, including both diabetic and non-diabetic individuals was introduced with superficial body including Blood Glucose Level (BGL), Diastolic and Systolic Blood Pressure, Heart Rate, Body Temperature, SPO2, Sweating and Shivering.

After carefully analyzing the data, it was noticed that out of 16,969 records there were only 328 nondiabetic records with the rest being diabetic. This leaves us with more than 98% of data belonging to one class, such bias in a binary classification approach either being Diabetic or Non-Diabetic could lead to severely and significantly wrong predictions of the model.

As a result, we decided to apply SMOTE (Synthetic Minority Oversampling Technique) which generates new instances of the minority class. SMOTE works by selecting examples that are close in the feature space and is proved to be effective in similar research related to diabetic mellitus prediction as shown here. Their results showed that classification after they applied different resampling techniques, including SMOTE, reached better results than on the original imbalanced dataset.

The shown network was run for 10 epochs, with each epoch running on a batch size of 64. The activation functions used were ReLU as shown in the figure with the Loss function being Binary Cross-entropy. Accuracy achieved on the test set was 94.62%.

Features
Authentication (UI-based implementation)
Monitor the reading from the Continuous Glucose Monitor (CGM) device or potentially any other sensor (UI-based implementation)
Manage your dates with potential caretakers (UI-based implementation)
Predict your current Diabetic status by providing BGL, age, temperature and a set of other features.
How to Install
Clone repo and navigate the project:

git clone https://github.com/moayadeldin/app-diabetes-monitoring

cd app-diabetes-monitoring

You need to have Flutter installed in your device in order to run the application properly, if not you can follow with their documentation here

To use the Diabetes Prediction feature, you need to install Flask API on your device and the required packages:

cd flask-app

pip install -r requirements.txt

To run the app and in a different terminal, run the following to put the Diabetes Prediction feature to work::

flutter run

cd flask-app

python app.py
