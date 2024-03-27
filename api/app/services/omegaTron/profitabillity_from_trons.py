from app.database.lTron_db import calculate_profit_loss
from app.shared.constants import SELECT,OMEGA_TRON_PROFIT,DELTA_TRON_PROFIT
from app.shared.queryExecution import execute_query
import decimal

def calculate_profit(user_id):
    try:
        result_omega_tron = execute_query(query_type=SELECT, query=OMEGA_TRON_PROFIT,params= (user_id,))
        result_delta_tron = execute_query(query_type=SELECT, query=DELTA_TRON_PROFIT,params= (user_id,))
        l_tron_profit_loss = calculate_profit_loss("NSE", user_id)
        if result_omega_tron and result_delta_tron:
            profit = result_omega_tron[0]
            omega_profit_percentage = profit * 100
            delta_profit = result_delta_tron[0]
            delta_profit_percentage = delta_profit * 100
            profit = {
                "omegaTron": decimal.Decimal(omega_profit_percentage),
                "l_tron": decimal.Decimal(l_tron_profit_loss),
                "delta_tron": decimal.Decimal(delta_profit_percentage),
                "total_profit" : ((decimal.Decimal(omega_profit_percentage) + decimal.Decimal(l_tron_profit_loss) + decimal.Decimal(delta_profit_percentage)) /3 )
            }
            return profit
        else:
            return 0

    except Exception as e:
        return {"error": str(e)}
