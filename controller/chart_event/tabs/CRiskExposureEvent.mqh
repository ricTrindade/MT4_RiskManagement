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
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CSumTradesExposure.mqh" 
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CIndivialTradeExposure.mqh" 

//+------------------------------------------------------------------+
//| CRiskExposureEvent_ Class                                        |
//+------------------------------------------------------------------+
class CRiskExposureEvent {

public:

   void displayTab(CGuiControl &gui);

   // 'Risk Settings' Methods 
   void trackMaxTradesBMP                 (CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxTradesEdit                (CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxLotsBMP                   (CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxLotsEdit                  (CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxExposureBMP               (CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxExposureEDIT              (CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxPositionValueBMP          (CGuiControl &gui, CRiskSettings &risk_settings);
   void trackMaxPositionValueEDIT         (CGuiControl &gui, CRiskSettings &risk_settings);
   void trackPercentageRiskSettingsBUTTON (CGuiControl &gui, CRiskSettings &risk_settings);
   void trackCurrencyRiskSettingsBUTTON   (CGuiControl &gui, CRiskSettings &risk_settings);

   // 'Total Risk' Methods 
   void trackPercentageTotalExposureBUTTON (CGuiControl &gui, CSumTradesExposure &sumTrades);
   void trackCurrencyTotalExposureBUTTON   (CGuiControl &gui, CSumTradesExposure &sumTrades);

   // 'Individual Risk' Methods 
   void trackPercentageIndivualTradeExposureBUTTON (CGuiControl &gui, CIndivialTradeExposure &indTradeExposure); 
   void trackCurrencyIndivualTradeExposureBUTTON   (CGuiControl &gui, CIndivialTradeExposure &indTradeExposure); 
   void trackComboBox                              (CGuiControl &gui, CIndivialTradeExposure &indTradeExposure);
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

//+------------------------------------------------------------------+
//| trackMaxExposureBMP                                              |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackMaxExposureBMP(CGuiControl &gui, CRiskSettings &risk_settings) {

   if(gui.riskExposure.bmpButton.maxExposure.Pressed()) {
      gui.riskExposure.edit.maxExposure.ReadOnly(false);
      gui.riskExposure.edit.maxExposure.ColorBackground(clrWhite);
   }
   else {
      gui.riskExposure.edit.maxExposure.ReadOnly(true);
      gui.riskExposure.edit.maxExposure.Text("");
      risk_settings.SetMaxExpCur(-1);
      risk_settings.SetMaxExpPer(-1);
      gui.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);
   }
}

//+------------------------------------------------------------------+
//| trackMaxExposureEDIT                                             |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackMaxExposureEDIT(CGuiControl &gui, CRiskSettings &risk_settings) {

   if(gui.riskExposure.RS==1){
      
      string text  = gui.riskExposure.edit.maxExposure.Text();
      double value = StrToDouble(text);
      
      if (value <= 0) {
            
         gui.riskExposure.edit.maxExposure.Text("");
         gui.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);
         gui.riskExposure.edit.maxExposure.ReadOnly(true);
         gui.riskExposure.bmpButton.maxExposure.Pressed(false);
         risk_settings.SetMaxExpCur(-1);
         risk_settings.SetMaxExpPer(-1);
      } 
      
      else {
      
         risk_settings.SetMaxExpPer(value);
         risk_settings.SetMaxExpCur((AccountBalance()* riskSettings.GetMaxExpPer())/100);
         gui.riskExposure.edit.maxExposure.Text(DoubleToStr(riskSettings.GetMaxExpPer(),2)+" %");  
      }
      
      gui.riskExposure.bmpButton.maxExposure.Pressed(false);
      gui.riskExposure.edit.maxExposure.ReadOnly(true); 
      gui.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke); 
   
   }
   
   else if(guiControl.riskExposure.RS==2) {
         
      string text  = gui.riskExposure.edit.maxExposure.Text();
      double value = StrToDouble(text);
      
      if (value <= 0) {
            
         gui.riskExposure.edit.maxExposure.Text("");
         gui.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);
         gui.riskExposure.edit.maxExposure.ReadOnly(true);
         gui.riskExposure.bmpButton.maxExposure.Pressed(false);
         risk_settings.SetMaxExpCur(-1);
         risk_settings.SetMaxExpPer(-1);
      } 
      
      else {
         
         risk_settings.SetMaxExpCur(value);
         risk_settings.SetMaxExpPer((riskSettings.GetMaxExpCur()*100)/AccountBalance());
         gui.riskExposure.edit.maxExposure.Text(DoubleToStr(riskSettings.GetMaxExpCur(),2)+" "+AccountCurrency());
      }
      
      gui.riskExposure.bmpButton.maxExposure.Pressed(false);
      gui.riskExposure.edit.maxExposure.ReadOnly(true); 
      gui.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);  
   }
}

//+------------------------------------------------------------------+
//| trackMaxPositionValueBMP                                         |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackMaxPositionValueBMP(CGuiControl &gui, CRiskSettings &risk_settings) {

   if(gui.riskExposure.bmpButton.maxPositionValue.Pressed()) {
      gui.riskExposure.edit.maxPositionValue.ReadOnly(false);
      gui.riskExposure.edit.maxPositionValue.ColorBackground(clrWhite);
   }
   else {
      gui.riskExposure.edit.maxPositionValue.ReadOnly(true);
      gui.riskExposure.edit.maxPositionValue.Text("");
      risk_settings.SetMaxPosVal(-1);
      gui.riskExposure.edit.maxPositionValue.ColorBackground(clrWhiteSmoke);
   }
}

//+------------------------------------------------------------------+
//| trackMaxPositionValueEDIT                                        |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackMaxPositionValueEDIT(CGuiControl &gui, CRiskSettings &risk_settings) {

   string text  = gui.riskExposure.edit.maxPositionValue.Text();
   double value = StrToDouble(text);
   
   if (value <= 0) {
         
      gui.riskExposure.edit.maxPositionValue.Text("");
      gui.riskExposure.edit.maxPositionValue.ColorBackground(clrWhiteSmoke);
      gui.riskExposure.edit.maxPositionValue.ReadOnly(true);
      gui.riskExposure.bmpButton.maxPositionValue.Pressed(false);
      risk_settings.SetMaxPosVal(-1);
   }  
   else {
      risk_settings.SetMaxPosVal(value); 
      gui.riskExposure.bmpButton.maxPositionValue.Pressed(false);
      gui.riskExposure.edit.maxPositionValue.ReadOnly(true); 
      gui.riskExposure.edit.maxPositionValue.ColorBackground(clrWhiteSmoke);  
      gui.riskExposure.edit.maxPositionValue.Text(DoubleToStr(riskSettings.GetMaxPosVal(),2)+" "+AccountCurrency());
   }
}

//+------------------------------------------------------------------+
//| trackPercentageRiskSettingsBUTTON                                |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackPercentageRiskSettingsBUTTON(CGuiControl &gui, CRiskSettings &risk_settings) {

   gui.riskExposure.RS=1;
   gui.riskExposure.button.percentageRiskSettings.ColorBackground(clrLightBlue);
   gui.riskExposure.button.currencyRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
   if(risk_settings.GetMaxExpPer()>0)gui.riskExposure.edit.maxExposure.Text(DoubleToStr(risk_settings.GetMaxExpPer(),2) + " %");   
}

//+------------------------------------------------------------------+
//| trackCurrencyRiskSettingsBUTTON                                  |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackCurrencyRiskSettingsBUTTON(CGuiControl &gui, CRiskSettings &risk_settings) {

   gui.riskExposure.RS=2;
   gui.riskExposure.button.percentageRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
   gui.riskExposure.button.currencyRiskSettings.ColorBackground(clrLightBlue);
   if(risk_settings.GetMaxExpCur()>0)gui.riskExposure.edit.maxExposure.Text(DoubleToStr(risk_settings.GetMaxExpCur(),2)+" "+AccountCurrency());
}

//+------------------------------------------------------------------+
//| trackPercentageTotalExposureBUTTON                               |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackPercentageTotalExposureBUTTON(CGuiControl &gui, CSumTradesExposure &sumTrades) {

   gui.riskExposure.TE=1;
   gui.riskExposure.button.percentageTotalExposure.ColorBackground(clrLightBlue);
   gui.riskExposure.button.currencyTotalExposure.ColorBackground(C'0xF0,0xF0,0xF0');
   
   if(sumTrades.GetTotalExpAcc() == -10 || sumTrades.GetTotalExpCur() == -10) {
   
      gui.riskExposure.edit.totalExposure.FontSize(gui.GetsubFont_S());
      gui.riskExposure.edit.totalExposure.Text("Use SL in All Trades!");
   }
   else {
   
      gui.riskExposure.edit.totalExposure.FontSize(gui.GetMainFont_S());
      gui.riskExposure.edit.totalExposure.Text(DoubleToStr(sumTrades.GetTotalExpAcc(),2)+" %"); 
   }
}

//+------------------------------------------------------------------+
//| trackCurrencyTotalExposureBUTTON                                 |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackCurrencyTotalExposureBUTTON(CGuiControl &gui, CSumTradesExposure &sumTrades) {

   gui.riskExposure.TE=2;
   gui.riskExposure.button.percentageTotalExposure.ColorBackground(C'0xF0,0xF0,0xF0');
   gui.riskExposure.button.currencyTotalExposure.ColorBackground(clrLightBlue);
   
   if(sumTrades.GetTotalExpAcc() == -10 || sumTrades.GetTotalExpCur() == -10) {
   
      gui.riskExposure.edit.totalExposure.FontSize(gui.GetsubFont_S());
      gui.riskExposure.edit.totalExposure.Text("Use SL in All Trades!");
   }
      
   else {
   
      gui.riskExposure.edit.totalExposure.FontSize(gui.GetMainFont_S());
      gui.riskExposure.edit.totalExposure.Text(DoubleToStr(sumTrades.GetTotalExpCur(),2)+" " +AccountCurrency());
   }
}

//+------------------------------------------------------------------+
//| trackPercentageIndivualTradeExposureBUTTON                       |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackPercentageIndivualTradeExposureBUTTON(CGuiControl &gui, CIndivialTradeExposure &indTradeExposure) {

   gui.riskExposure.ITE=1;
   gui.riskExposure.button.percentageIndivualTradeExposure.ColorBackground(clrLightBlue);
   gui.riskExposure.button.currencyIndivualTradeExposure.ColorBackground(C'0xF0,0xF0,0xF0');
   if (indTradeExposure.GetSingularExp_Per() == -10 || indTradeExposure.GetSingularExp_Cur() == -10) {
      
      gui.riskExposure.edit.tradeExposure.FontSize(gui.GetsubFont_S());
      gui.riskExposure.edit.tradeExposure.Text("Trade with No SL!");
   }
   else {
   
      gui.riskExposure.edit.tradeExposure.FontSize(gui.GetMainFont_S());
      gui.riskExposure.edit.tradeExposure.Text(DoubleToStr(indTradeExposure.GetSingularExp_Per(),2)+" %");
   }
} 

//+------------------------------------------------------------------+
//| trackCurrencyIndivualTradeExposureBUTTON                         |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackCurrencyIndivualTradeExposureBUTTON(CGuiControl &gui, CIndivialTradeExposure &indTradeExposure) {

   gui.riskExposure.ITE=2; 
   gui.riskExposure.button.percentageIndivualTradeExposure.ColorBackground(C'0xF0,0xF0,0xF0');
   gui.riskExposure.button.currencyIndivualTradeExposure.ColorBackground(clrLightBlue);    
   if (indTradeExposure.GetSingularExp_Per() == -10 || indTradeExposure.GetSingularExp_Cur() == -10) {
   
      gui.riskExposure.edit.tradeExposure.FontSize(gui.GetsubFont_S());
      gui.riskExposure.edit.tradeExposure.Text("Trade with No SL!"); 
   }
   else {
   
      gui.riskExposure.edit.tradeExposure.FontSize(gui.GetMainFont_S());
      gui.riskExposure.edit.tradeExposure.Text(DoubleToStr(indTradeExposure.GetSingularExp_Cur(),2)+" " +AccountCurrency());
   }
}

//+------------------------------------------------------------------+
//| trackComboBox                                                    |
//+------------------------------------------------------------------+
void CRiskExposureEvent::trackComboBox(CGuiControl &gui, CIndivialTradeExposure &indTradeExposure) {

   if(indTradeExposure.GetSingularTradesValues_Risk(gui)) 
      indTradeExposure.GetSingularTradesValues_PosVal(gui);
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif