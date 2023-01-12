//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/ComboBox.mqh>  

//+------------------------------------------------------------------+
//| Risk Exposure ComboBox Class                                 |
//+------------------------------------------------------------------+
class CComboBoxRE {

public :

   // Components
   CComboBox *tradeExposure;
   
   // Constructor
   CComboBoxRE();
   
   // Destructor
   ~CComboBoxRE();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CComboBoxRE::CComboBoxRE(void) {
   
   tradeExposure = new CComboBox();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CComboBoxRE::~CComboBoxRE(void) {
   
   delete tradeExposure;
}
