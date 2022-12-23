//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Label.mqh> 

//+------------------------------------------------------------------+
//| Position Size Calculator Labels Structure                        |
//+------------------------------------------------------------------+
struct SLabelPSC {

   CLabel riskPerTrade;
   CLabel entryPrice;
   CLabel stopLoss;
   CLabel riskInPoints;
   CLabel riskInCurrency;
   CLabel contractSize;
   CLabel totalUnits;
   CLabel totalLots;
   CLabel positionValue;
};