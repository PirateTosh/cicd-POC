from app.services.deltaTron.fyers_service import get_fyers_quote, place_fyers_order
from app.shared.constants import FYERS

def get_quote(userType):
    if userType == FYERS:
        return get_fyers_quote()
    # else:
    #     return get_zerodha_quote()
        

def place_order(userType, list_of_fetched_symbol, isExit):
    if userType == FYERS:
        return place_fyers_order(list_of_fetched_symbol, isExit)
    # else:
    #     return place_zerodha_order(trade_symbol, isExit)
