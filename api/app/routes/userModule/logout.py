from flask import jsonify, request, make_response
from app import app

@app.route('/logout', methods=['GET'])
def logout_get():
    access_token = request.cookies.get('JWT_TOKEN')

    if not access_token:
        return jsonify({'message': 'You are already logged out.'}), 200

    resp = make_response(jsonify({'message': 'Logged out successfully'}))
    resp.set_cookie('JWT_TOKEN', '', max_age=1)
    
    return resp
