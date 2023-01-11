//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CPositionSizeCalculatorEvent_
   #define CPositionSizeCalculatorEvent_

//+------------------------------------------------------------------+
//| Include External Resources                                       |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CPositionSizeCalculator.mqh"

//+------------------------------------------------------------------+
//| CPositionSizeCalculatorEvent_ Class                              |
//+------------------------------------------------------------------+
class CPositionSizeCalculatorEvent {

public:

   // 'PriceButton' Methods
   void trackPriceCustom (CGuiControl &gui);
   void trackPriceBid    (CGuiControl &gui);
   void trackPriceAsk    (CGuiControl &gui);

   // Calculate Method
   void trackCalculateBUTTON(CGuiControl &gui, CPositionSizeCalculator &psc);
   void displayTab(CGuiControl &gui);
};

//+------------------------------------------------------------------+
//| displayTab - Method's Body                                       |
//+------------------------------------------------------------------+
void CPositionSizeCalculatorEvent::displayTab(CGuiControl &gui) {

   if(!gui.positionSizeCalculator.label.riskPerTrade.IsVisible()) {
      
      //Hide Risk Exposure
      gui.riskExposure.hide(); 
      
      //Change the size of Window
      gui.mainWindow.windowDialog.Height(gui.positionSizeCalculator.height);
      gui.mainWindow.copyRightsLabel.Shift(0,gui.positionSizeCalculator.crShift);
      
      //Show positionSizeCalculator
      gui.positionSizeCalculator.show();
      gui.SetOPEN_TAB(guiControl.Check_Tab());
   }
}

//+------------------------------------------------------------------+
//| trackPriceCustom - Method's Body                                 |
//+------------------------------------------------------------------+
void CPositionSizeCalculatorEvent::trackPriceCustom(CGuiControl &gui) {

   if(gui.positionSizeCalculator.edit.entryPrice.ReadOnly() == true){
      gui.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhite);
      gui.positionSizeCalculator.edit.entryPrice.ReadOnly(false);
      gui.positionSizeCalculator.edit.entryPrice.Color(clrBlack);
      
      //Empty Info of positionSizeCalculator
      gui.positionSizeCalculator.edit.riskInPoints.Text("");
      gui.positionSizeCalculator.edit.riskInPoints.Text("");
      gui.positionSizeCalculator.edit.totalUnits.Text("");
      gui.positionSizeCalculator.edit.totalLots.Text("");
      gui.positionSizeCalculator.edit.positionValue.Text("");
   }
   else {
      gui.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
      gui.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
      gui.positionSizeCalculator.edit.entryPrice.Text("");
      
      //Empty Info of positionSizeCalculator
      gui.positionSizeCalculator.edit.riskInPoints.Text("");
      gui.positionSizeCalculator.edit.riskInPoints.Text("");
      gui.positionSizeCalculator.edit.totalUnits.Text("");
      gui.positionSizeCalculator.edit.totalLots.Text("");
      gui.positionSizeCalculator.edit.positionValue.Text("");
   } 
}

//+------------------------------------------------------------------+
//| trackPriceBid - Method's Body                                    |
//+------------------------------------------------------------------+
void CPositionSizeCalculatorEvent::trackPriceBid(CGuiControl &gui) {

   gui.positionSizeCalculator.edit.entryPrice.Text((string)Bid);
   gui.positionSizeCalculator.edit.entryPrice.Color(clrTomato);
   gui.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
   gui.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
   
   //Empty Info of positionSizeCalculator
   gui.positionSizeCalculator.edit.riskInPoints.Text("");
   gui.positionSizeCalculator.edit.riskInPoints.Text("");
   gui.positionSizeCalculator.edit.totalUnits.Text("");
   gui.positionSizeCalculator.edit.totalLots.Text("");
   gui.positionSizeCalculator.edit.positionValue.Text("");
}

//+------------------------------------------------------------------+
//| trackPriceAsk - Method's Body                                    |
//+------------------------------------------------------------------+
void CPositionSizeCalculatorEvent::trackPriceAsk(CGuiControl &gui) {

   gui.positionSizeCalculator.edit.entryPrice.Text((string)Ask);
   gui.positionSizeCalculator.edit.entryPrice.Color(clrMediumSeaGreen);
   gui.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
   gui.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
   
   //Empty Info of positionSizeCalculator
   gui.positionSizeCalculator.edit.riskInPoints.Text("");
   gui.positionSizeCalculator.edit.riskInPoints.Text("");
   gui.positionSizeCalculator.edit.totalUnits.Text("");
   gui.positionSizeCalculator.edit.totalLots.Text("");
   gui.positionSizeCalculator.edit.positionValue.Text("");
}

//+------------------------------------------------------------------+
//| trackCalculateBUTTON - Method's Body                             |
//+------------------------------------------------------------------+
void CPositionSizeCalculatorEvent::trackCalculateBUTTON(CGuiControl &gui, CPositionSizeCalculator &psc) {

   if(psc.Calculate_Lot(gui)) {
      
      psc.Calculate_PosVal(gui);
   }
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif