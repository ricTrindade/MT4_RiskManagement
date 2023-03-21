//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

//+------------------------------------------------------------------+
//| CTestInitializer Initialiser class                               |
//+------------------------------------------------------------------+
class CTestInitializer {

public:

   void create(CGuiControl &gui);
};

//+------------------------------------------------------------------+
//| create Method Defenition                                         |
//+------------------------------------------------------------------+
void CTestInitializer::create(CGuiControl &gui) {
   
   // Pointer to main window
   CAppDialog *window = gui.mainWindow.windowDialog;
}