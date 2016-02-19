from functools import wraps
from flask import request, jsonify


def check_auth(username, password):
    """This function is called to check if a username /
    password combination is valid.
    """
    request.user = username
    return True


def authenticate():
    """Sends a 401 response that enables basic auth"""
    return jsonify(error='Authentication required'), 401, \
        {'WWW-Authenticate': 'Basic realm="Login Required"'}


def basic_auth_required(func):
    @wraps(func)
    def decorated(*args, **kwargs):
        auth = request.authorization
        if not auth or not check_auth(auth.username, auth.password):
            return authenticate()
        return func(*args, **kwargs)
    return decorated
