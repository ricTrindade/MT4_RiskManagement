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

   // Tab Settings
   int width;

   // Components 
   CAppDialog *windowDialog;
   CLabel     *copyRightsLabel;
   CBmpButton *minMaxBmpButton;
   
   // Constructor
   CMainWindow();
   
   // Destructor
   ~CMainWindow();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMainWindow::CMainWindow(void) {

   windowDialog    = new CAppDialog();
   copyRightsLabel = new CLabel();
   minMaxBmpButton = new CBmpButton();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMainWindow::~CMainWindow(void) {

   delete windowDialog;
   delete copyRightsLabel;
   delete minMaxBmpButton;
}

