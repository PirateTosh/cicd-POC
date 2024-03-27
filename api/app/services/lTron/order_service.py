from app.services.lTron.dynamic_stock_purchase_service import place_fyers_order
from app.shared.constants import FYERS

def place_order(userType, trade_symbol, no_of_shares, shouldBuyShares):
    if userType == FYERS:
        return place_fyers_order(trade_symbol, no_of_shares, shouldBuyShares)
