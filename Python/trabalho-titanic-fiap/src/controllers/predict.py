"""Load Librarys"""
import json
import os
import pickle
import pandas as pd
from flask import Response, jsonify


class Predict:
    """Class Titanic Predict"""

    @staticmethod
    def validate_dict(passenger: dict) -> bool:
        """Check dict exist all keys"""
        result = 0

        if 'pclass' in passenger.keys():
            result += 1
        if 'sex_male' in passenger.keys():
            result += 1
        if 'age' in passenger.keys():
            result += 1
        if 'sibsp' in passenger.keys():
            result += 1
        if 'parch' in passenger.keys():
            result += 1
        if 'fare' in passenger.keys():
            result += 1
        if 'embarked_Q' in passenger.keys():
            result += 1
        if 'embarked_S' in passenger.keys():
            result += 1

        return result == 8

    @staticmethod
    def read_data(passenger) -> any:
        """Read data"""
        model_file_name = 'files/titanic_model_randomforestclassifier.sav'
        app_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        path_model_file_name = os.path.join(app_path, model_file_name)

        loaded_model = pickle.load(open(path_model_file_name, 'rb'))

        y_pred = loaded_model.predict(pd.DataFrame(passenger, index=[1]))
        result = y_pred[0]
        return json.dumps(result, default=bool)

    @staticmethod
    def execute(passenger: dict) -> Response:
        """Execute Predict logical"""

        bool_dict = Predict.validate_dict(passenger)

        if bool_dict:
            result = Predict.read_data(passenger)

            response = {'survived': result == 'true', 'error': False}
        else:
            response = {'message': 'Invalid params!', 'error': True}

        return jsonify(response)
