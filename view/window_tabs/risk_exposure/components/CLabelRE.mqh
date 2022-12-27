//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Label.mqh> 

//+------------------------------------------------------------------+
//| Risk Exposure Labels Class                                   |
//+------------------------------------------------------------------+
class CLabelRE {

public:

   // Components
   CLabel *maxInt;
   CLabel *maxTrades;
   CLabel *maxLots;
   CLabel *maxExposure;
   CLabel *maxPositionValue;
   CLabel *totalExposure_int;
   CLabel *totalTrades;
   CLabel *totalLots;
   CLabel *totalExposure;
   CLabel *totalPositionValue;
   CLabel *tradeSelect_int;
   CLabel *tradeSelect;
   CLabel *tradeExposure;
   CLabel *tradePositionValue;
   
   // Constructor
   CLabelRE();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CLabelRE::CLabelRE(void) {
   
   maxInt             = new CLabel();
   maxTrades          = new CLabel();
   maxLots            = new CLabel();
   maxExposure        = new CLabel();
   maxPositionValue   = new CLabel();
   totalExposure_int  = new CLabel();
   totalTrades        = new CLabel();
   totalLots          = new CLabel();
   totalExposure      = new CLabel();
   totalPositionValue = new CLabel();
   tradeSelect_int    = new CLabel();
   tradeSelect        = new CLabel();
   tradeExposure      = new CLabel();
   tradePositionValue = new CLabel();  
}