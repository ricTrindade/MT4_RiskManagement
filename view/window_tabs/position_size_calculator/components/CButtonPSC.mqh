//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Button.mqh> 

//+------------------------------------------------------------------+
//| Position Size Calculator Buttons class                           |
//+------------------------------------------------------------------+
class CButtonPSC {

public:

   CButton *tabPSC;
   CButton *calculate;
   CButton *priceCustom;
   CButton *priceBid;
   CButton *priceAsk;
   
   CButtonPSC() {
   
      tabPSC      = new CButton();
      calculate   = new CButton();
      priceCustom = new CButton();
      priceBid    = new CButton();
      priceAsk    = new CButton();
   }
};

