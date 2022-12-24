//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/DialogMyVersion.mqh>
#include <Controls/Label.mqh>

//+------------------------------------------------------------------+
//| Main Window tab Structure                                        |
//+------------------------------------------------------------------+
struct SMainWindow {

   CAppDialog windowDialog;
   CLabel     copyRightsLabel;
   CBmpButton minMaxBmpButton;
};