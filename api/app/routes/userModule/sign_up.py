from flask import jsonify, request
from app import app
import hashlib
import uuid
from app.middlewares.validator import validate_details
from app.shared.queryExecution import execute_query
from app.shared.constants import SELECT,INSERT, CHECK_ALREADY_EXISTING_EMAIL, ADD_USER

@app.route('/signup', methods = ['POST'])
@validate_details(['name', 'email', 'password', 'dob', 'mobile_number'])
def signup():
    try:
        data = request.get_json()
        email = data['email'].lower().strip()
        password = data['password']
        name = data['name'].lower().strip()
        dob = data['dob'].strip()
        mobile_number = data['mobile_number'].strip()
        value = execute_query(query_type=SELECT, query=CHECK_ALREADY_EXISTING_EMAIL,params=(email))
        if(value and len(value)>0):
            if value[0]:
                return jsonify({'message': 'Email id already exists'}), 409
            else:
                return jsonify({'message': 'Internal server error'}), 400
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        user_guid = str(uuid.uuid4())
        execute_query(query_type=INSERT, query=ADD_USER,params=(user_guid, email, hashed_password, name, dob, mobile_number))
        return jsonify({'message': 'User created successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400
