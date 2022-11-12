from google.colab import auth


def auth_user():
    auth.authenticate_user()
    return True
