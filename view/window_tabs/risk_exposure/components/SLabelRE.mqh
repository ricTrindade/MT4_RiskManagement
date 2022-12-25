//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Label.mqh> 

//+------------------------------------------------------------------+
//| Risk Exposure Labels Structure                                   |
//+------------------------------------------------------------------+
struct SLabelRE {

   CLabel maxInt;
   CLabel maxTrades;
   CLabel maxLots;
   CLabel maxExposure;
   CLabel maxPositionValue;
   CLabel totalExposure_int;
   CLabel totalTrades;
   CLabel totalLots;
   CLabel totalExposure;
   CLabel totalPositionValue;
   CLabel tradeSelect_int;
   CLabel tradeSelect;
   CLabel tradeExposure;
   CLabel tradePositionValue;
};