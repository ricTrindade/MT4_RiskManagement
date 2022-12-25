//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include "components\CBMPbuttonRE.mqh"
#include "components\CButtonRE.mqh"
#include "components\CComboBoxRE.mqh"
#include "components\CEditRE.mqh"
#include "components\CLabelRE.mqh"

//+------------------------------------------------------------------+
//| Risk Exposure tab Structure                                      |
//+------------------------------------------------------------------+
struct SRiskExposure {
   
   CButtonRE    button;
   CLabelRE     label;
   CEditRE      edit;
   CComboBoxRE  comboBox;
   CBMPbuttonRE bmpButton;
};