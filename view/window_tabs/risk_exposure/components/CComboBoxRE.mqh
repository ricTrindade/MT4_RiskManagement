//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/ComboBox.mqh>  

//+------------------------------------------------------------------+
//| Risk Exposure ComboBox Class                                 |
//+------------------------------------------------------------------+
class CComboBoxRE {

public :

   CComboBox *tradeExposure;
   
   CComboBoxRE() {
   
      tradeExposure = new CComboBox();
   }
};