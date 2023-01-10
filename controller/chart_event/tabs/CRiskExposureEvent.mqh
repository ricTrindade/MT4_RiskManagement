//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CRiskExposureEvent_
   #define CRiskExposureEvent_

//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CRiskSettings.mqh" 

//+------------------------------------------------------------------+
//| CRiskExposureEvent_ Class                                        |
//+------------------------------------------------------------------+
class CRiskExposureEvent {

public:

   void displayTab(CGuiControl &gui);
   void trackMaxTradesBMP(CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxTradesEdit(CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxLotsBMP(CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxLotsEdit(CGuiControl &gui, CRiskSettings &risk_settings);
};

//+------------------------------------------------------------------+
//| displayTab                                                       |
//+------------------------------------------------------------------+
void CRiskExposureEvent::displayTab(CGuiControl &gui) {

   if(!gui.riskExposure.label.totalTrades.IsVisible()) {
      
      //Hide positionSizeCalculator
      gui.positionSizeCalculator.hide(); 
      
      //Change the size of Window
      gui.mainWindow.windowDialog.Height(gui.riskExposure.height);
      gui.mainWindow.copyRightsLabel.Shift(0,gui.riskExposure.crShift);
      
      //Show Risk Exposure
      gui.riskExposure.show();
      gui.SetOPEN_TAB(gui.Check_Tab());
   }
}

//+------------------------------------------------------------------+
//| trackMaxTradesBMP                                                |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackMaxTradesBMP(CGuiControl &gui, CRiskSettings &risk_settings) {

   if(gui.riskExposure.bmpButton.maxTrades.Pressed()) {
      
      gui.riskExposure.edit.maxTrades.ReadOnly(false);
      gui.riskExposure.edit.maxTrades.ColorBackground(clrWhite);
   }
   else {
      gui.riskExposure.edit.maxTrades.ReadOnly(true);
      gui.riskExposure.edit.maxTrades.Text("");
      risk_settings.SetMaxTrades(-1);
      gui.riskExposure.edit.maxTrades.ColorBackground(clrWhiteSmoke);
   }
}

//+------------------------------------------------------------------+
//| trackMaxTradesEdit                                               |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackMaxTradesEdit(CGuiControl &gui, CRiskSettings &risk_settings) {

   string text  = gui.riskExposure.edit.maxTrades.Text();
   double value = StrToDouble(text);
   
   if (value <= 0) {
      
      gui.riskExposure.edit.maxTrades.Text("");
      gui.riskExposure.edit.maxTrades.ColorBackground(clrWhiteSmoke);
      gui.riskExposure.edit.maxTrades.ReadOnly(true);
      gui.riskExposure.bmpButton.maxTrades.Pressed(false);
      riskSettings.SetMaxTrades(-1);
   } 
   else {
   
      risk_settings.SetMaxTrades(value);
      gui.riskExposure.edit.maxTrades.Text(DoubleToString(riskSettings.GetMaxTrades(),0));
   } 
   
   gui.riskExposure.bmpButton.maxTrades.Pressed(false);
   gui.riskExposure.edit.maxTrades.ReadOnly(true); 
   gui.riskExposure.edit.maxTrades.ColorBackground(clrWhiteSmoke);
}

//+------------------------------------------------------------------+
//| trackMaxLotsBMP                                                  |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackMaxLotsBMP(CGuiControl &gui, CRiskSettings &risk_settings) {

   if(gui.riskExposure.bmpButton.maxLots.Pressed()) {
      gui.riskExposure.edit.maxLots.ReadOnly(false);
      gui.riskExposure.edit.maxLots.ColorBackground(clrWhite);
   }
   else {
      gui.riskExposure.edit.maxLots.ReadOnly(true);
      gui.riskExposure.edit.maxLots.Text("");
      risk_settings.SetMaxLots(-1);
      gui.riskExposure.edit.maxLots.ColorBackground(clrWhiteSmoke);
   }
}

//+------------------------------------------------------------------+
//| trackMaxLotsEdit                                                 |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackMaxLotsEdit(CGuiControl &gui, CRiskSettings &risk_settings) {

   string text  = gui.riskExposure.edit.maxLots.Text();
   double value = StringToDouble(text);
   
   if (value <= 0) {
         
      gui.riskExposure.edit.maxLots.Text("");
      gui.riskExposure.edit.maxLots.ColorBackground(clrWhiteSmoke);
      gui.riskExposure.edit.maxLots.ReadOnly(true);
      gui.riskExposure.bmpButton.maxLots.Pressed(false);
      risk_settings.SetMaxLots(-1);
   }
   else {
   
      risk_settings.SetMaxLots(value);
      gui.riskExposure.edit.maxLots.Text(DoubleToString(riskSettings.GetMaxLots(),2));
   }
   
   gui.riskExposure.bmpButton.maxLots.Pressed(false);
   gui.riskExposure.edit.maxLots.ReadOnly(true); 
   gui.riskExposure.edit.maxLots.ColorBackground(clrWhiteSmoke);
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif