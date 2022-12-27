//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/BMPbutton.mqh>  

//+------------------------------------------------------------------+
//| Risk Exposure BMPbutton Class                                    |
//+------------------------------------------------------------------+
class CBMPbuttonRE {

public:

   CBmpButton *maxTrades;
   CBmpButton *maxLots;
   CBmpButton *maxExposure;
   CBmpButton *maxPositionValue;
   
   CBMPbuttonRE() {
   
      maxTrades        = new CBmpButton;
      maxLots          = new CBmpButton;
      maxExposure      = new CBmpButton;
      maxPositionValue = new CBmpButton;
   }
};
