//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/DialogMyVersion.mqh>
#include <Controls/Label.mqh>

//+------------------------------------------------------------------+
//| Main Window tab Class                                            |
//+------------------------------------------------------------------+
class CMainWindow {

public:

   CAppDialog *windowDialog;
   CLabel     *copyRightsLabel;
   CBmpButton *minMaxBmpButton;
   
   CMainWindow() {
      
      windowDialog    = new CAppDialog();
      copyRightsLabel = new CLabel();
      minMaxBmpButton = new CBmpButton();
   }
};