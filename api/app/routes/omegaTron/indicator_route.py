import json
from flask import jsonify
from app import app
from app.services.omegaTron.indicator_service import get_indicators


@app.route("/get_adx_rsi", methods=["POST"])
def fetch_ADX_RSI_Indicator():
    try:
        response_data = get_indicators()
        return jsonify(response_data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
