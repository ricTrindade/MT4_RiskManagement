//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Button.mqh> 

//+------------------------------------------------------------------+
//| Risk Exposure Buttons Structure                                  |
//+------------------------------------------------------------------+
struct SButtonRE {

   CButton tabRiskExposure;
   CButton currencyRiskSettings;
   CButton percentageRiskSettings;
   CButton currencyTotalExposure;
   CButton percentageTotalExposure;
   CButton currencyIndivualTradeExposure;
   CButton percentageIndivualTradeExposure;
};