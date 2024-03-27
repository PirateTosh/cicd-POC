from app import app
from flask import request, jsonify
from app.middlewares.validator import validate_details
import hashlib
from app.shared.queryExecution import execute_query
from app.shared.constants import SELECT,UPDATE, CHECK_PASSWORD,UPDATE_PASSWORD


@app.route('/update_password', methods=['POST'])
@validate_details(['password', 'email'])
def update_password():
    try:
        email = request.json.get('email')
        new_password = request.json.get('password')
        value = execute_query(query_type=SELECT,query=CHECK_PASSWORD, params=(email))
        if not (value and len(value) > 0):
            return jsonify({"message": "Email not found"}), 409
        hashed_password = hashlib.sha256(new_password.encode()).hexdigest()
        value = execute_query(query_type=UPDATE,query=UPDATE_PASSWORD, params=(email, hashed_password))
        return jsonify({'message': 'Password updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 400