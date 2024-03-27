from flask import jsonify, request
import jwt
import re
from functools import wraps
from app.config import SECRET_KEY

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')

        if not token:
            return jsonify({'message': 'Token is missing'}), 401

        try:
            token = token.split()[1]
            data = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
        except:
            return jsonify({'message': 'Token is invalid'}), 401

        return f(data, *args, **kwargs)

    return decorated


def validate_details(required_fields):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            data = request.get_json()

            missing_fields = [field for field in required_fields if field not in data]
            if missing_fields:
                return jsonify({'message': f'Missing data for required field(s): {", ".join(missing_fields)}'}), 400

            if 'email' in data and not re.match(r"[^@]+@[^@]+\.[^@]+", data['email']):
                return jsonify({'message': 'Invalid email format'}), 400

            return f(*args, **kwargs)
        return decorated_function
    return decorator