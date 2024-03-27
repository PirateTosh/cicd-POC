from flask import request, jsonify
from app.middlewares.validator import token_required
from app import app
from app.shared.queryExecution import execute_query

from app.shared.constants import (
    UPDATE,
    TRON_NAME,
    TRON_STATUS,
    OMEGA_TRON,
    L_TRON,
    DELTA_TRON,
    UPDATE_DELTA_TRON_ACTIVE_STATUS,
    UPDATE_L_TRON_ACTIVE_STATUS,
    UPDATE_OMEGA_TRON_ACTIVE_STATUS,
    KILL_SWITCH_TOGGLED_SUCCESSFULLY,
    INVALID_KILLSWITCH_TYPE_MESSAGE
)


@app.route("/activate_killSwitch", methods=["POST"])
# @token_required
def update_kill_switch():
    try:
        details = request.get_json()
        tron_name = details[TRON_NAME]
        tron_status = details[TRON_STATUS]
        # user_id = data['id']   Need to update this while integrating this with UI
        user_id = 1
        if tron_name == OMEGA_TRON:
            execute_query(query_type=UPDATE,query=UPDATE_OMEGA_TRON_ACTIVE_STATUS,params=(tron_status,user_id))
        elif tron_name == DELTA_TRON:
            execute_query(query_type=UPDATE,query=UPDATE_DELTA_TRON_ACTIVE_STATUS,params=(tron_status,user_id))
        elif tron_name == L_TRON:
            execute_query(query_type=UPDATE,query=UPDATE_L_TRON_ACTIVE_STATUS,params=(tron_status,user_id))
        else:
            print(INVALID_KILLSWITCH_TYPE_MESSAGE)
            return INVALID_KILLSWITCH_TYPE_MESSAGE

        return KILL_SWITCH_TOGGLED_SUCCESSFULLY

    except Exception as e:
        print({"error": format(str(e))})
        return jsonify({"error": format(str(e))}), 500
    
