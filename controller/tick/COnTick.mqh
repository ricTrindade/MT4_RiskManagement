//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef COnTick_
   #define COnTick_

//+------------------------------------------------------------------+
//| Include External Resources                                       |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CPositionSizeCalculator.mqh"

//+------------------------------------------------------------------+
//| Expert tick Class                                                |
//+------------------------------------------------------------------+
class COnTick {

public:

   // Methods 
   void trackPriceButtonsOnPSC(CGuiControl &gui, CPositionSizeCalculator &psc);   
};

//+------------------------------------------------------------------+
//| trackPriceButtonsOnPSC - Method's Body                           |
//+------------------------------------------------------------------+
void COnTick::trackPriceButtonsOnPSC(CGuiControl &gui, CPositionSizeCalculator &psc) {

   if (psc.track_BidAsk(gui) == 2) {
      gui.positionSizeCalculator.edit.entryPrice.Text((string)Bid);
      gui.positionSizeCalculator.edit.entryPrice.Color(clrTomato);
      gui.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
      gui.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
   }
   else if (psc.track_BidAsk(gui) == 3) {
      gui.positionSizeCalculator.edit.entryPrice.Text((string)Ask);
      gui.positionSizeCalculator.edit.entryPrice.Color(clrMediumSeaGreen);
      gui.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
      gui.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
   }
   else if (psc.track_BidAsk(gui) == 3) { //Calculate button has been pressed 
      gui.positionSizeCalculator.edit.entryPrice.Text(gui.positionSizeCalculator.edit.entryPrice.Text()); 
   }
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif