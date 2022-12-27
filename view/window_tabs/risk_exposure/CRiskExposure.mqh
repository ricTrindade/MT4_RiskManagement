//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include "components\CBMPbuttonRE.mqh"
#include "components\CButtonRE.mqh"
#include "components\CComboBoxRE.mqh"
#include "components\CEditRE.mqh"
#include "components\CLabelRE.mqh"

//+------------------------------------------------------------------+
//| Risk Exposure tab class                                          |
//+------------------------------------------------------------------+
class CRiskExposure {

   int height;
   int crShift;
   
   /*Currency or Account Button*/
   int RS;
   int TE;
   int ITE;

public:

   // Components
   CButtonRE    *button;
   CLabelRE     *label;
   CEditRE      *edit;
   CComboBoxRE  *comboBox;
   CBMPbuttonRE *bmpButton;
   
   // Constructor
   CRiskExposure();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CRiskExposure::CRiskExposure() {

   button    = new CButtonRE();
   label     = new CLabelRE();
   edit      = new CEditRE();
   comboBox  = new CComboBoxRE();
   bmpButton = new CBMPbuttonRE();
}
