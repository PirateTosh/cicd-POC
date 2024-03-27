from app.services.omegaTron.backtesting_service import get_backtesting_quote
from app.services.omegaTron.zerodha_service import (
    get_zerodha_quote,
    place_zerodha_order,
)
from app.services.omegaTron.fyers_service import get_fyers_quote, place_fyers_order
from app.shared.constants import (
    FYERS,
    BACKTESTING
)

def get_quote(userType, date):
    if userType == FYERS:
        return get_fyers_quote()

    elif userType == BACKTESTING:
        return get_backtesting_quote(date)

    else:
        return get_zerodha_quote()


def place_order(userType, trade_symbol, isExit):
    if userType == FYERS:
        return place_fyers_order(trade_symbol, isExit)
    else:
        return place_zerodha_order(trade_symbol, isExit)
