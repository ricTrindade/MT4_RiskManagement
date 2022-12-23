//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/DialogMyVersion.mqh>
#include <Controls/Label.mqh>

//+------------------------------------------------------------------+
//| Main Window tab Structure                                        |
//+------------------------------------------------------------------+
struct SMainWindow {

   CAppDialog MainWindow;
   CLabel     CopyRights;
   CBmpButton Min_Max;
};