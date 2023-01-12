//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef COnChartEvent_
   #define COnChartEvent_

//+------------------------------------------------------------------+
//| Include External Resources                                       |
//+------------------------------------------------------------------+
#include "tabs\CMainWindowEvent.mqh" 
#include "tabs\CPositionSizeCalculatorEvent.mqh" 
#include "tabs\CRiskExposureEvent.mqh" 

//+------------------------------------------------------------------+
//| Include External Resources                                       |
//+------------------------------------------------------------------+
class COnChartEvent {

public:

   // Application Tabs
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
//| Constructor's Body                                               |
//+------------------------------------------------------------------+
COnChartEvent::COnChartEvent() {

   mainWindow             = new CMainWindowEvent();
   positionSizeCalculator = new CPositionSizeCalculatorEvent();
   riskExposure           = new CRiskExposureEvent();
}

//+------------------------------------------------------------------+
//| Destructor's Body                                                |
//+------------------------------------------------------------------+
COnChartEvent::~COnChartEvent() {

   delete mainWindow;
   delete positionSizeCalculator;
   delete riskExposure;
}

//+------------------------------------------------------------------+
//| trackOBJ - Method's Body                                         |
//+------------------------------------------------------------------+
void COnChartEvent::trackOBJ(CGuiControl &gui, const string &sparam) {

   gui.SetOBJ_CONTROL(ObjectGetString(0,sparam,OBJPROP_TEXT));
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif