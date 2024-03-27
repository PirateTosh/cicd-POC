from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Additional configuration can be added here

# Import routes after creating the Flask app instance
from app.routes.omegaTron import strategy_route, indicator_route
from app.routes.lTron import dynamic_stock_purchase_route
from app.routes.deltaTron import premium_route
from app.routes.userModule import sign_up
from app.routes.userModule import login
from app.routes.userModule import update_user_profile
from app.routes.userModule import user_verification
from app.routes.userModule import update_password
from app.routes.killSwitch import kill_switch_route
