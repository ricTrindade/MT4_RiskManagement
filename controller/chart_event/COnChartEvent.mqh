//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef COnChartEvent_
   #define COnChartEvent_

//+------------------------------------------------------------------+
//| Include 'Tabs' Classes                                           |
//+------------------------------------------------------------------+
#include "tabs\CMainWindowEvent.mqh" 
#include "tabs\CPositionSizeCalculatorEvent.mqh" 
#include "tabs\CRiskExposureEvent.mqh" 

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class                           |
//+------------------------------------------------------------------+
class COnChartEvent {

public:

   // Tabs
   CMainWindowEvent             *mainWindow;
   CPositionSizeCalculatorEvent *positionSizeCalculator;
   CRiskExposureEvent           *riskExposure;
   
   // Constructor
   COnChartEvent();
   
   // Destructor
   ~COnChartEvent();
   
   // Methods
   void trackOBJ(CGuiControl &gui, const string &sparam);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
COnChartEvent::COnChartEvent() {

   mainWindow             = new CMainWindowEvent();
   positionSizeCalculator = new CPositionSizeCalculatorEvent();
   riskExposure           = new CRiskExposureEvent();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
COnChartEvent::~COnChartEvent() {

   delete mainWindow;
   delete positionSizeCalculator;
   delete riskExposure;
}

//+------------------------------------------------------------------+
//| trackOBJ                                                         |
//+------------------------------------------------------------------+
void COnChartEvent::trackOBJ(CGuiControl &gui, const string &sparam) {

   gui.SetOBJ_CONTROL(ObjectGetString(0,sparam,OBJPROP_TEXT));
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif