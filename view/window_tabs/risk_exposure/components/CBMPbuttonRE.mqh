//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/BMPbutton.mqh>  

//+------------------------------------------------------------------+
//| Risk Exposure BMPbutton Class                                    |
//+------------------------------------------------------------------+
class CBMPbuttonRE {

public:

   // Components
   CBmpButton *maxTrades;
   CBmpButton *maxLots;
   CBmpButton *maxExposure;
   CBmpButton *maxPositionValue;
   
   // Constructor
   CBMPbuttonRE();
   
   // Destructor
   ~CBMPbuttonRE();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CBMPbuttonRE::CBMPbuttonRE(void) {
   
   maxTrades        = new CBmpButton();
   maxLots          = new CBmpButton();
   maxExposure      = new CBmpButton();
   maxPositionValue = new CBmpButton();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CBMPbuttonRE::~CBMPbuttonRE(void) {
   
   delete maxTrades;
   delete maxLots;
   delete maxExposure;
   delete maxPositionValue;
}