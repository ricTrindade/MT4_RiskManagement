//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include "components\SBMPbuttonRE.mqh"
#include "components\SButtonRE.mqh"
#include "components\SComboBoxRE.mqh"
#include "components\SEditRE.mqh"
#include "components\SLabelRE.mqh"

//+------------------------------------------------------------------+
//| Risk Exposure tab Structure                                      |
//+------------------------------------------------------------------+
struct SRiskExposure {
   
   SButtonRE    button;
   SLabelRE     label;
   SEditRE      edit;
   SComboBoxRE  comboBox;
   SBMPbuttonRE bmpButton;
};