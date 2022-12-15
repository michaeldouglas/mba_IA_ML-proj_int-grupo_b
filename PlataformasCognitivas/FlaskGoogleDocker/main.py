import os

from flask import Flask, request
from src.controllers.predict import Predict

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello API -"

@app.route('/predict', methods=['POST'])
def predict():
    """Predict route"""
    return Predict.execute(request.json)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 80)))