//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Button.mqh> 

//+------------------------------------------------------------------+
//| Risk Exposure Buttons Class                                      |
//+------------------------------------------------------------------+
class CButtonRE {

public:

   CButton *tabRiskExposure;
   CButton *currencyRiskSettings;
   CButton *percentageRiskSettings;
   CButton *currencyTotalExposure;
   CButton *percentageTotalExposure;
   CButton *currencyIndivualTradeExposure;
   CButton *percentageIndivualTradeExposure;
   
   CButtonRE() {
   
      tabRiskExposure                 = new CButton;
      currencyRiskSettings            = new CButton;
      percentageRiskSettings          = new CButton;
      currencyTotalExposure           = new CButton;
      percentageTotalExposure         = new CButton;
      currencyIndivualTradeExposure   = new CButton;
      percentageIndivualTradeExposure = new CButton;
   }
};