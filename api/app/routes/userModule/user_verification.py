import random
import string
from flask import request, jsonify
from app import app
otp_store = {}
from app.shared.sendEmail import send_email
from app.middlewares.validator import validate_details 

# Generate a random numeric OTP
def generate_otp():
    return ''.join(random.choices(string.digits, k=6))

# Send OTP via email
def send_otp_email(email, otp):
    emailReceiver = email
    subject = 'OTP verfication'
    body = f"Your verification code is {otp}.\n Do not share this with anyone else"
    return send_email(emailReceiver, subject, body)
    
# Route to send OTP
@app.route('/send_otp', methods=['POST'])
@validate_details(['email'])
def send_otp():
    data = request.get_json()
    email = data.get('email')

    if not email:
        return jsonify({'error': 'Email not provided'}), 400

    otp = generate_otp()
    otp_store[email] = otp
    if send_otp_email(email, otp):
        return jsonify({'message': 'OTP sent successfully'}), 200
    else:
        return jsonify({'error': 'Failed to send OTP'}), 500

@app.route('/check_otp', methods=['POST'])
@validate_details(['email', 'otp'])
def check_otp():
    data = request.get_json()
    email = data.get('email').lower().strip()
    user_otp = data.get('otp').strip()

    if not email or not user_otp:
        return jsonify({'error': 'Email or OTP not provided'}), 400

    if email in otp_store and otp_store[email] == user_otp:
        del otp_store[email]
        return jsonify({'message': 'OTP verification successful'}), 200
    else:
        return jsonify({'error': 'Invalid OTP'}), 401
