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
   
   //
   void createTabPSC(CAppDialog &appDialog, 
               int fontSize,
               int x1,
               int y1,
               int x2,
               int y2);
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

//+------------------------------------------------------------------+
//| createTabPSC                                                     |
//+------------------------------------------------------------------+
void CButtonPSC::createTabPSC(CAppDialog &appDialog, 
                              int fontSize,
                              int x1,
                              int y1,
                              int x2,
                              int y2) {

   tabPSC.Create(0,
                "guiControl.positionSizeCalculator.button.tabPSC",
                0,
                x1,
                y1,
                x2,
                y2);
                      
   tabPSC.Text("Position Size Calculator");
   appDialog.Add(tabPSC);
   tabPSC.FontSize(fontSize);
}
