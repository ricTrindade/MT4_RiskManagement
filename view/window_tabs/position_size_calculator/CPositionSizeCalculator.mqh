//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include "components\CButtonPSC.mqh"
#include "components\CEditPSC.mqh"
#include "components\CLabelPSC.mqh"

//+------------------------------------------------------------------+
//| Position Size Calculator tab class                               |
//+------------------------------------------------------------------+
class CPositionSizeCalculatorTab {

   int height;
   int crShift;

public:

   // Components
   CButtonPSC *button;
   CLabelPSC  *label;
   CEditPSC   *edit;
   
   // Constructor
   CPositionSizeCalculatorTab();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPositionSizeCalculatorTab::CPositionSizeCalculatorTab() {

   button = new CButtonPSC();
   label  = new CLabelPSC();
   edit   = new CEditPSC();
}


