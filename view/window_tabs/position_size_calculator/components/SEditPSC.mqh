//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Edit.mqh> 

//+------------------------------------------------------------------+
//| Position Size Calculator Edit Structure                          |
//+------------------------------------------------------------------+
struct SEditPSC {

   CEdit riskPerTrade;
   CEdit entryPrice;
   CEdit stopLoss;
   CEdit riskInPoints;
   CEdit riskInCurrency;
   CEdit contractSize;
   CEdit totalUnits;
   CEdit totalLots;
   CEdit positionValue;
};