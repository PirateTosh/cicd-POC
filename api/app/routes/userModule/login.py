from flask import jsonify, request
import jwt
import hashlib
from datetime import datetime, timedelta
from app import app
from app.config import SECRET_KEY
from app.middlewares.validator import validate_details
from app.shared.queryExecution import execute_query
from app.shared.constants import SELECT, LOGIN_QUERY

@app.route('/login', methods=['POST'])
@validate_details(['email','password'])
def login():
    try:
        data = request.get_json()
        email = data['email'].lower().strip()
        password = data['password']
        
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        user_data = execute_query(query_type=SELECT,query=LOGIN_QUERY,params=(email, hashed_password))
        if user_data:
            user_dict = {
                'id': user_data[0],
                'user_id': user_data[1],
                'email': user_data[3],
                'password': user_data[4],
                'name': user_data[5]
            }
            token_payload = {
                'id': user_dict['id'],
                'exp': datetime.utcnow() + timedelta(days=1)
            }
            token = jwt.encode(token_payload, SECRET_KEY, algorithm='HS256')
            response_data = {
                'token': token,
                'user': user_dict
            }
            
            return jsonify(response_data), 200
        else:
            return jsonify({'message': 'Invalid email or password'}), 401
    except Exception as e:
        return jsonify({'error': str(e)}), 400
