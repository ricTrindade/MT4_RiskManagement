//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CMainWindowEvent_
   #define CMainWindowEvent_

//+------------------------------------------------------------------+
//| Include External Resources                                       |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

//+------------------------------------------------------------------+
//| CMainWindowEvent Class                                           |
//+------------------------------------------------------------------+
class CMainWindowEvent {

public:

   // Methods
   void activate(CGuiControl  &gui,
                 const int    id,
                 const long   &lparam,
                 const double &dparam,
                 const string &sparam);   
   
   void minMax(CGuiControl  &gui);          
};

//+------------------------------------------------------------------+
//| activate - Method's Body                                         |
//+------------------------------------------------------------------+
void CMainWindowEvent::activate(CGuiControl  &gui,
                                const int    id,
                                const long   &lparam,
                                const double &dparam,
                                const string &sparam) {

   gui.mainWindow.windowDialog.OnEvent(id,lparam,dparam,sparam);
}

//+------------------------------------------------------------------+
//| minMax - Method's Body                                            |
//+------------------------------------------------------------------+
void CMainWindowEvent::minMax(CGuiControl  &gui) {

   if(!gui.mainWindow.minMaxBmpButton.Pressed()) gui.WindowMax();
   else gui.WindowMin();
}  

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif