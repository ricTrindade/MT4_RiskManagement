//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Edit.mqh> 

//+------------------------------------------------------------------+
//| Risk Exposure Edit Class                                         |
//+------------------------------------------------------------------+
class CEditRE {

public:

   CEdit *maxTrades;
   CEdit *maxLots;
   CEdit *maxExposure;
   CEdit *maxPositionValue;
   CEdit *totalTrades;
   CEdit *totalLots;
   CEdit *totalExposure;
   CEdit *totalPositionValue;
   CEdit *tradeExposure;
   CEdit *tradePositionValue;
   
   CEditRE() {
   
      maxTrades          = new CEdit();
      maxLots            = new CEdit();
      maxExposure        = new CEdit();
      maxPositionValue   = new CEdit();
      totalTrades        = new CEdit();
      totalLots          = new CEdit();
      totalExposure      = new CEdit();
      totalPositionValue = new CEdit();
      tradeExposure      = new CEdit();
      tradePositionValue = new CEdit();
   }
};