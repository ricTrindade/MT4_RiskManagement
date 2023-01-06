//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Button.mqh> 

//+------------------------------------------------------------------+
//| Risk Exposure Buttons Class                                      |
//+------------------------------------------------------------------+
class CButtonRE {

public:

   // Components
   CButton *tabRiskExposure;
   CButton *currencyRiskSettings;
   CButton *percentageRiskSettings;
   CButton *currencyTotalExposure;
   CButton *percentageTotalExposure;
   CButton *currencyIndivualTradeExposure;
   CButton *percentageIndivualTradeExposure;
   
   // Constructor
   CButtonRE();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CButtonRE::CButtonRE(void) {
   
   tabRiskExposure                 = new CButton();
   currencyRiskSettings            = new CButton();
   percentageRiskSettings          = new CButton();
   currencyTotalExposure           = new CButton();
   percentageTotalExposure         = new CButton();
   currencyIndivualTradeExposure   = new CButton();
   percentageIndivualTradeExposure = new CButton();
}