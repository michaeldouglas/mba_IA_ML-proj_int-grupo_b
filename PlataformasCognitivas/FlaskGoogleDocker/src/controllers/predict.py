"""Load Librarys"""
import json
import os
import pickle
import pandas as pd
from flask import Response, jsonify


class Predict:
    """Class Loan Predict"""

    @staticmethod
    def validate_dict(loans: dict) -> bool:
        """Check dict exist all keys"""
        result = 0

        if 'loan_amount' in loans.keys():
            result += 1
        if 'rate_of_interest' in loans.keys():
            result += 1
        if 'term' in loans.keys():
            result += 1
        if 'property_value' in loans.keys():
            result += 1
        if 'income' in loans.keys():
            result += 1
        if 'credit_score' in loans.keys():
            result += 1
        if 'dtir1' in loans.keys():
            result += 1
        if 'loan_type_type2' in loans.keys():
            result += 1
        if 'loan_type_type3' in loans.keys():
            result += 1
        if 'age_35-44' in loans.keys():
            result += 1
        if 'age_45-54' in loans.keys():
            result += 1
        if 'age_55-64' in loans.keys():
            result += 1
        if 'age_65-74' in loans.keys():
            result += 1
        if 'age_<25' in loans.keys():
            result += 1
        if 'age_>74' in loans.keys():
            result += 1

        return result == 15

    @staticmethod
    def read_data(loans) -> any:
        """Read data"""
        model_file_name = 'files/loan_decisiontreeclassifier.sav'
        app_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        path_model_file_name = os.path.join(app_path, model_file_name)

        loaded_model = pickle.load(open(path_model_file_name, 'rb'))

        y_pred = loaded_model.predict(pd.DataFrame(loans, index=[1]))

        result = y_pred[0]
        return json.dumps(result, default=bool)

    @staticmethod
    def execute(loans: dict) -> Response:
        """Execute Predict logical"""

        bool_dict = Predict.validate_dict(loans)

        if bool_dict:
            result = Predict.read_data(loans)

            response = {'loan': result == 'true', 'error': False}
        else:
            response = {'message': 'Invalid params!', 'error': True}

        return jsonify(response)
