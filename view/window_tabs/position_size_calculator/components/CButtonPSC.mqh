//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Button.mqh> 
#include <Controls/DialogMyVersion.mqh>

//+------------------------------------------------------------------+
//| Position Size Calculator Buttons class                           |
//+------------------------------------------------------------------+
class CButtonPSC {

public:

   // Components 
   CButton *tabPSC;
   CButton *calculate;
   CButton *priceCustom;
   CButton *priceBid;
   CButton *priceAsk;
   
   // Constructor
   CButtonPSC();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CButtonPSC::CButtonPSC(void) {
   
   tabPSC      = new CButton();
   calculate   = new CButton();
   priceCustom = new CButton();
   priceBid    = new CButton();
   priceAsk    = new CButton();
}
