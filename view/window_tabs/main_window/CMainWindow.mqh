//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/DialogMyVersion.mqh>
#include <Controls/Label.mqh>

//+------------------------------------------------------------------+
//| Main Window tab Class                                            |
//+------------------------------------------------------------------+
class CMainWindow {

   int    width;
   int    mainFont_S;      
   int    subFont_S;
   
public:

   // Components 
   CAppDialog *windowDialog;
   CLabel     *copyRightsLabel;
   CBmpButton *minMaxBmpButton;
   
   // Constructor
   CMainWindow();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMainWindow::CMainWindow() {

   windowDialog    = new CAppDialog();
   copyRightsLabel = new CLabel();
   minMaxBmpButton = new CBmpButton();
}

