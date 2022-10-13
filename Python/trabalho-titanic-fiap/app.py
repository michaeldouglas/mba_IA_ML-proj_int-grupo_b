"""Load Librarys"""
import os
from flask import Flask, request, render_template
from src.functions.path import get_path
from src.controllers.predict import Predict

app = Flask(__name__, template_folder=get_path(os.getenv("TEMPLATE_HTML")))


@app.route('/')
def index():
    """Index Route"""
    return render_template('index.html')


@app.route('/predict', methods=['POST'])
def predict():
    """Predict route"""
    return Predict.execute(request.json)
