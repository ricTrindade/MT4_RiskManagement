//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef COnTimer_
   #define COnTimer_

//+------------------------------------------------------------------+
//| Include External Resources                                       |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh"
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CRiskSettings.mqh"
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CSumTradesExposure.mqh"
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CIndivialTradeExposure.mqh"

//+------------------------------------------------------------------+
//| Expert Timer Class                                               |
//+------------------------------------------------------------------+
class COnTimer {

public:

   // Methods
   void trackInputByUserOnRiskExposure(CGuiControl &gui, CRiskSettings &risk_settings, CSumTradesExposure &sumTrades);
   void calculateTotalTrades(CGuiControl &gui, CSumTradesExposure &sumTrades);
   void calculateTotals(CGuiControl &gui, CSumTradesExposure &sumTrades);
   void addTradesToComboBox(CGuiControl &gui, CSumTradesExposure &sumTrades, CIndivialTradeExposure &indivialTrade);
};

//+------------------------------------------------------------------+
//| trackInputByUserOnRiskExposure - Method's Body                   |
//+------------------------------------------------------------------+
void COnTimer::trackInputByUserOnRiskExposure(CGuiControl &gui, CRiskSettings &risk_settings, CSumTradesExposure &sumTrades){
   
   //Number of Trades   
   if (sumTrades.GetTotalTrades() > risk_settings.GetMaxTrades() && 
       risk_settings.GetMaxTrades() != -1) {
      gui.riskExposure.edit.totalTrades.ColorBackground(clrTomato);
   }
   else gui.riskExposure.edit.totalTrades.ColorBackground(clrWhiteSmoke);
   
   //Number of Lots
   if (sumTrades.GetTotalLots() > risk_settings.GetMaxLots() && 
       risk_settings.GetMaxLots() != -1) {
      gui.riskExposure.edit.totalLots.ColorBackground(clrTomato);
   }
   else gui.riskExposure.edit.totalLots.ColorBackground(clrWhiteSmoke);
   
   //Exposure in Currency or Account %
   if(gui.riskExposure.TE ==1) {
      if ((sumTrades.GetTotalExpAcc() > risk_settings.GetMaxExpPer() && 
          risk_settings.GetMaxExpPer() != -1) ||
          ((risk_settings.GetMaxExpPer() != -1) && (sumTrades.GetTotalExpAcc() == -10))) {
         gui.riskExposure.edit.totalExposure.ColorBackground(clrTomato);
      }
      else gui.riskExposure.edit.totalExposure.ColorBackground(clrWhiteSmoke);
   }
   
   if(gui.riskExposure.TE == 2) {
      if ((sumTrades.GetTotalExpCur() > risk_settings.GetMaxExpCur() && 
          risk_settings.GetMaxExpCur() != -1) ||
          ((risk_settings.GetMaxExpCur() != -1) && (sumTrades.GetTotalExpAcc() == -10))) {
         gui.riskExposure.edit.totalExposure.ColorBackground(clrTomato);
      }
      else gui.riskExposure.edit.totalExposure.ColorBackground(clrWhiteSmoke);
   }
   //Exposure in Position Size
   if (sumTrades.GetTotalPosVal() > risk_settings.GetMaxPosVal() && 
       risk_settings.GetMaxPosVal() != -1) {
      gui.riskExposure.edit.totalPositionValue.ColorBackground(clrTomato);
   }
   else gui.riskExposure.edit.totalPositionValue.ColorBackground(clrWhiteSmoke);
}

//+------------------------------------------------------------------+
//| calculateTotalTrades - Method's Body                             |
//+------------------------------------------------------------------+
void COnTimer::calculateTotalTrades(CGuiControl &gui, CSumTradesExposure &sumTrades) {

   sumTrades.SetTotalTrades(OrdersTotal());
   gui.riskExposure.edit.totalTrades.Text((string)sumTrades.GetTotalTrades());
}

//+------------------------------------------------------------------+
//| calculateTotalLots - Method's Body                               |
//+------------------------------------------------------------------+
void COnTimer::calculateTotals(CGuiControl &gui, CSumTradesExposure &sumTrades) {

   //Calculate total Lots 
   double Total_lots = 0.0;
   
   //Get Total Lots
   for(int i=0; i < OrdersTotal(); i++) {
      
      if(OrderSelect(i, SELECT_BY_POS))
         Total_lots += OrderLots();
   }
   
   sumTrades.SetTotalLots(Total_lots);
   gui.riskExposure.edit.totalLots.Text(DoubleToStr(sumTrades.GetTotalLots(),2));
   
   //Calculate Risk in Currency or Account Percentage 
   sumTrades.TotalExpAccAndCurr(gui);
   
   //Calculate Position Size value  
   sumTrades.Total_PosVal(gui);
}

//+------------------------------------------------------------------+
//| addTradesToComboBox - Method's Body                              |
//+------------------------------------------------------------------+
void COnTimer::addTradesToComboBox(CGuiControl &gui, CSumTradesExposure &sumTrades, CIndivialTradeExposure &indivialTrade) {

   if(sumTrades.IsNewTrade()) { 
         
      gui.riskExposure.comboBox.tradeExposure.ItemsClear();
      gui.riskExposure.edit.tradeExposure.Text("");
      gui.riskExposure.edit.tradePositionValue.Text("");
                 
      indivialTrade.AddToCB_Singular_Trades(gui);
   }
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif