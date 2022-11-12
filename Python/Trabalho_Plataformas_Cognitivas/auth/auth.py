def auth():
    from google.colab import auth
    auth.authenticate_user()
    return True


resultAuth = auth()

if(resultAuth):
    print('Authenticated')