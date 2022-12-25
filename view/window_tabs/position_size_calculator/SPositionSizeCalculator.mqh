//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include "components\CButtonPSC.mqh"
#include "components\CEditPSC.mqh"
#include "components\CLabelPSC.mqh"

//+------------------------------------------------------------------+
//| Position Size Calculator tab Structure                           |
//+------------------------------------------------------------------+
struct SPositionSizeCalculator {

   CButtonPSC button;
   CLabelPSC  label;
   CEditPSC   edit;
};