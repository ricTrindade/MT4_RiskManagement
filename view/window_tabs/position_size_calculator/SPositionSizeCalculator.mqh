//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include "components\SButtonPSC.mqh"
#include "components\SEditPSC.mqh"
#include "components\SLabelPSC.mqh"

//+------------------------------------------------------------------+
//| Position Size Calculator tab Structure                           |
//+------------------------------------------------------------------+
struct SPositionSizeCalculator {

   SButtonPSC button;
   SLabelPSC  label;
   SEditPSC   edit;
};