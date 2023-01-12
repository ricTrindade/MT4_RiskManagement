//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef COnDeinit_
   #define COnDeinit_

//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

//+------------------------------------------------------------------+
//| COnDeinit Class                                                  |
//+------------------------------------------------------------------+
class COnDeinit {

public: 

   string getUninitReasonText(int reasonCode);
   
};

//+------------------------------------------------------------------+
//| getUninitReasonText                                              |
//+------------------------------------------------------------------+
string COnDeinit::getUninitReasonText(int reasonCode) {

   string text="";

   switch(reasonCode) {
   
      case REASON_ACCOUNT:     text="Account was changed";break;
      case REASON_CHARTCHANGE: text="Symbol or timeframe was changed";break;
      case REASON_CHARTCLOSE:  text="Chart was closed";break;
      case REASON_PARAMETERS:  text="Input-parameter was changed";break;
      case REASON_RECOMPILE:   text="Program "+__FILE__+" was recompiled";break;
      case REASON_REMOVE:      text="Program "+__FILE__+" was removed from chart";break;
      case REASON_TEMPLATE:    text="New template was applied to chart";break;
      default:                 text="Another reason";
   }
   
   return text;
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif