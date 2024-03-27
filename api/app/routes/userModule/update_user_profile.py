from flask import jsonify, request
from app import app
from app.middlewares.validator import token_required, validate_details
from app.shared.queryExecution import execute_query
from app.shared.constants import SELECT,UPDATE, CHECK_ALREADY_EXISTING_EMAIL,UPDATE_PROFILE

@app.route('/update_profile', methods=['POST'])
@validate_details(['name', 'email', 'dob', 'mobile_number'])
@token_required
def updateUserProfile(data):
    try:
        details = request.get_json()
        user_id = data['id']
        new_email = details['email'].strip().lower()
        dob = details['dob']
        mobile_number = details['mobile_number']
        new_name = details['name'].strip().lower()
        value = execute_query(query_type=SELECT, query=CHECK_ALREADY_EXISTING_EMAIL,params=(new_email))
        if(value and len(value)>0):
            if value[0]:
                return jsonify({'message': 'Email id already exists'}), 409
            else:
                return jsonify({'message': 'Internal server error'}), 400
        
        execute_query(query_type= UPDATE,query=UPDATE_PROFILE, params=(new_email, new_name, dob,mobile_number, user_id))

        return jsonify({'message': 'Profile updated successfully'}), 200
    except Exception as e:
        return jsonify({'error': f'An error occurred: {str(e)}'}), 500
