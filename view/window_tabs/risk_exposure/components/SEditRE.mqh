//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Edit.mqh> 

//+------------------------------------------------------------------+
//| Risk Exposure Edit Structure                                     |
//+------------------------------------------------------------------+
struct SEditRE {

   CEdit maxTrades;
   CEdit maxLots;
   CEdit maxExposure;
   CEdit maxPositionValue;
   CEdit totalTrades;
   CEdit totalLots;
   CEdit totalExposure;
   CEdit totalPositionValue;
   CEdit tradeExposure;
   CEdit tradePositionValue;
};