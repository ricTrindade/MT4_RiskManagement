//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files\OANDA - MetaTrader\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

//+------------------------------------------------------------------+
//| Include Some Components                                          |
//+------------------------------------------------------------------+
#include "C:\Program Files\OANDA - MetaTrader\MQL4\Experts\MT4_RiskManagement\model\CRiskSettings.mqh" 
#include "C:\Program Files\OANDA - MetaTrader\MQL4\Experts\MT4_RiskManagement\model\CSumTradesExposure.mqh" 
#include "C:\Program Files\OANDA - MetaTrader\MQL4\Experts\MT4_RiskManagement\model\CIndivialTradeExposure.mqh"

//+------------------------------------------------------------------+
//| Risk Exposure Initialiser class                                  |
//+------------------------------------------------------------------+
class CRiskExposureInitializer {

public:

   void create(CGuiControl            &gui, 
               CRiskSettings          &riskOptions, 
               CSumTradesExposure     &sumTrades, 
               CIndivialTradeExposure &individualTrade);
};

//+------------------------------------------------------------------+
//| create Method Defenition                                         |
//+------------------------------------------------------------------+
void CRiskExposureInitializer::create(CGuiControl            &gui, 
                                      CRiskSettings          &riskOptions, 
                                      CSumTradesExposure     &sumTrades, 
                                      CIndivialTradeExposure &individualTrade) {

   //-------------------------
   //Button - gui.riskExposure.button.tabRiskExposure
   //-------------------------
   gui.riskExposure.button.tabRiskExposure.Create(0,"gui.riskExposure.button.tabRiskExposure",0,0,0,gui.ScaledPixel(175),gui.ScaledPixel(25));
   gui.riskExposure.button.tabRiskExposure.Text("Risk Exposure");
   gui.riskExposure.button.tabRiskExposure.FontSize(gui.GetMainFont_S());
   gui.mainWindow.windowDialog.Add(gui.riskExposure.button.tabRiskExposure);
   gui.riskExposure.button.tabRiskExposure.Shift(gui.ScaledPixel(195),gui.ScaledPixel(5));
   
   //--------------------------------------------------------
   // Risk Settings
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label
   //-------------------------
   gui.riskExposure.label.maxInt.Create(0,"gui.riskExposure.label.maxInt",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.maxInt);
   gui.riskExposure.label.maxInt.Text("Risk Settings");
   gui.riskExposure.label.maxInt.Shift(gui.ScaledPixel(145),gui.ScaledPixel(45));
   gui.riskExposure.label.maxInt.Color(clrMediumBlue);
   gui.riskExposure.label.maxInt.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //MAX Settings Trades
   //-------------------------
   //Label
   gui.riskExposure.label.maxTrades.Create(0,"gui.riskExposure.label.maxTrades",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.maxTrades);
   gui.riskExposure.label.maxTrades.Text("MAX # Trades");
   gui.riskExposure.label.maxTrades.Shift(gui.ScaledPixel(5),gui.ScaledPixel(72));
   gui.riskExposure.label.maxTrades.FontSize(gui.GetMainFont_S());
   
   //edit
   gui.riskExposure.edit.maxTrades.Create(0,"gui.riskExposure.edit.maxTrades",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.maxTrades);
   gui.riskExposure.edit.maxTrades.Shift(gui.ScaledPixel(255),gui.ScaledPixel(70));
   gui.riskExposure.edit.maxTrades.ReadOnly(true);
   gui.riskExposure.edit.maxTrades.ColorBackground(clrWhiteSmoke);
   gui.riskExposure.edit.maxTrades.FontSize(gui.GetMainFont_S());
   if (riskOptions.GetMaxTrades() != -1) gui.riskExposure.edit.maxTrades.Text((string)riskOptions.GetMaxTrades());
   
   //bmp
   gui.riskExposure.bmpButton.maxTrades.Create(0,"gui.riskExposure.bmpButton.maxTrades",0,0,0,0,0);
   gui.riskExposure.bmpButton.maxTrades.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                              "::Include\\Controls\\res\\CheckBoxOn.bmp");
   gui.mainWindow.windowDialog.Add(gui.riskExposure.bmpButton.maxTrades); 
   gui.riskExposure.bmpButton.maxTrades.Shift(gui.ScaledPixel(230),gui.ScaledPixel(75));
   
   //-------------------------
   //MAX Settings Lots
   //-------------------------
   //Label
   gui.riskExposure.label.maxLots.Create(0,"gui.riskExposure.label.maxLots",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.maxLots);
   gui.riskExposure.label.maxLots.Text("MAX Lots");
   gui.riskExposure.label.maxLots.Shift(gui.ScaledPixel(5),gui.ScaledPixel(102));
   gui.riskExposure.label.maxLots.FontSize(gui.GetMainFont_S());
   
   //edit
   gui.riskExposure.edit.maxLots.Create(0,"gui.riskExposure.edit.maxLots",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.maxLots);
   gui.riskExposure.edit.maxLots.Shift(gui.ScaledPixel(255),gui.ScaledPixel(100));
   gui.riskExposure.edit.maxLots.ReadOnly(true);
   gui.riskExposure.edit.maxLots.ColorBackground(clrWhiteSmoke);
   gui.riskExposure.edit.maxLots.FontSize(gui.GetMainFont_S());
   if (riskOptions.GetMaxLots() != -1) gui.riskExposure.edit.maxLots.Text((string)riskOptions.GetMaxLots());
   
   //bmp
   gui.riskExposure.bmpButton.maxLots.Create(0,"gui.riskExposure.bmpButton.maxLots",0,0,0,0,0);
   gui.riskExposure.bmpButton.maxLots.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                            "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   gui.mainWindow.windowDialog.Add(gui.riskExposure.bmpButton.maxLots); 
   gui.riskExposure.bmpButton.maxLots.Shift(gui.ScaledPixel(230),gui.ScaledPixel(105));
   
   //-------------------------
   //MAX Settings Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Risk Settings
   //Account percentage
   gui.riskExposure.button.percentageRiskSettings.Create(0,"gui.riskExposure.button.percentageRiskSettings",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.button.percentageRiskSettings);
   gui.riskExposure.button.percentageRiskSettings.Shift(gui.ScaledPixel(125),gui.ScaledPixel(135));
   gui.riskExposure.button.percentageRiskSettings.Text("Acc%");
   gui.riskExposure.button.percentageRiskSettings.FontSize(gui.GetsubFont_S());
   //Currency 
   gui.riskExposure.button.currencyRiskSettings.Create(0,"gui.riskExposure.button.currencyRiskSettings",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.button.currencyRiskSettings);
   gui.riskExposure.button.currencyRiskSettings.Shift(gui.ScaledPixel(175),gui.ScaledPixel(135));
   gui.riskExposure.button.currencyRiskSettings.Text(AccountCurrency());
   gui.riskExposure.button.currencyRiskSettings.FontSize(gui.GetsubFont_S());
   //Button Clr OnInit
   if(gui.riskExposure.RS ==1) {
      gui.riskExposure.button.percentageRiskSettings.ColorBackground(clrLightBlue);
      gui.riskExposure.button.currencyRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(gui.riskExposure.RS==2){
      gui.riskExposure.button.percentageRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
      gui.riskExposure.button.currencyRiskSettings.ColorBackground(clrLightBlue);
   }
   
   //Label
   gui.riskExposure.label.maxExposure.Create(0,"gui.riskExposure.label.maxExposure",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.maxExposure);
   gui.riskExposure.label.maxExposure.Text("MAX Risk");
   gui.riskExposure.label.maxExposure.Shift(gui.ScaledPixel(5),gui.ScaledPixel(132));
   gui.riskExposure.label.maxExposure.FontSize(gui.GetMainFont_S());
   
   //edit Currency
   gui.riskExposure.edit.maxExposure.Create(0,"gui.riskExposure.edit.maxExposure",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.maxExposure);
   gui.riskExposure.edit.maxExposure.Shift(gui.ScaledPixel(255),gui.ScaledPixel(130));
   gui.riskExposure.edit.maxExposure.ReadOnly(true);
   gui.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);
   if(gui.riskExposure.RS ==1) {
      if (riskOptions.GetMaxExpPer() != -1) 
         gui.riskExposure.edit.maxExposure.Text(DoubleToString(riskOptions.GetMaxExpPer(),2) + " %");
   }   
   if(gui.riskExposure.RS==2){
      if (riskOptions.GetMaxExpCur() != -1) 
         gui.riskExposure.edit.maxExposure.Text(DoubleToString(riskOptions.GetMaxExpCur(),2) + " "+AccountCurrency());
   }
   gui.riskExposure.edit.maxExposure.FontSize(gui.GetMainFont_S());
   //bmp
   gui.riskExposure.bmpButton.maxExposure.Create(0,"gui.riskExposure.bmpButton.maxExposure",0,0,0,0,0);
   gui.riskExposure.bmpButton.maxExposure.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   gui.mainWindow.windowDialog.Add(gui.riskExposure.bmpButton.maxExposure); 
   gui.riskExposure.bmpButton.maxExposure.Shift(gui.ScaledPixel(230),gui.ScaledPixel(135));
   
   //-------------------------
   //Max Currency Value of PositionSize
   //-------------------------
   //Label
   gui.riskExposure.label.maxPositionValue.Create(0,"gui.riskExposure.label.maxPositionValue",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.maxPositionValue);
   gui.riskExposure.label.maxPositionValue.Text("MAX " + AccountCurrency() + " Exposure");
   gui.riskExposure.label.maxPositionValue.Shift(gui.ScaledPixel(5),gui.ScaledPixel(162));
   gui.riskExposure.label.maxPositionValue.FontSize(gui.GetMainFont_S());
   
   //bmp
   gui.riskExposure.bmpButton.maxPositionValue.Create(0,"gui.riskExposure.bmpButton.maxPositionValue",0,0,0,0,0);
   gui.riskExposure.bmpButton.maxPositionValue.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                   "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   gui.mainWindow.windowDialog.Add(gui.riskExposure.bmpButton.maxPositionValue); 
   gui.riskExposure.bmpButton.maxPositionValue.Shift(gui.ScaledPixel(230),gui.ScaledPixel(165));
   
   //edit
   gui.riskExposure.edit.maxPositionValue.Create(0,"gui.riskExposure.edit.maxPositionValue",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.maxPositionValue);
   gui.riskExposure.edit.maxPositionValue.Shift(gui.ScaledPixel(255),gui.ScaledPixel(160));
   gui.riskExposure.edit.maxPositionValue.ReadOnly(true);
   gui.riskExposure.edit.maxPositionValue.ColorBackground(clrWhiteSmoke);
   gui.riskExposure.edit.maxPositionValue.FontSize(gui.GetMainFont_S());
   if (riskOptions.GetMaxPosVal() != -1) gui.riskExposure.edit.maxPositionValue.Text((string)riskOptions.GetMaxPosVal() + " "+AccountCurrency());
   
   //--------------------------------------------------------
   // Total Exposure
   //--------------------------------------------------------
  
   //-------------------------
   //Introduction Label
   //-------------------------
   gui.riskExposure.label.totalExposure_int.Create(0,"gui.riskExposure.label.totalExposure_int",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.riskExposure.label.totalExposure_int.Text("Total Exposure");
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.totalExposure_int);
   gui.riskExposure.label.totalExposure_int.Shift(gui.ScaledPixel(140),gui.ScaledPixel(188));
   gui.riskExposure.label.totalExposure_int.Color(clrMediumBlue);
   gui.riskExposure.label.totalExposure_int.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total_Trades
   //-------------------------
   //Label - gui.riskExposure.label.totalTrades 
   gui.riskExposure.label.totalTrades.Create(0,"gui.riskExposure.label.totalTrades",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.totalTrades);
   gui.riskExposure.label.totalTrades.Text("Total Trades");
   gui.riskExposure.label.totalTrades.Shift(gui.ScaledPixel(5),gui.ScaledPixel(212));
   gui.riskExposure.label.totalTrades.FontSize(gui.GetMainFont_S());
   
   //Edit - gui.riskExposure.edit.totalTrades 
   gui.riskExposure.edit.totalTrades.Create(0,"gui.riskExposure.edit.totalTrades",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.totalTrades);
   gui.riskExposure.edit.totalTrades.Shift(gui.ScaledPixel(255),gui.ScaledPixel(210));
   gui.riskExposure.edit.totalTrades.ReadOnly(true);
   gui.riskExposure.edit.totalTrades.FontSize(gui.GetMainFont_S());
   
   if (sumTrades.GetTotalTrades() > riskOptions.GetMaxTrades() && 
       riskOptions.GetMaxTrades() != -1) {
      gui.riskExposure.edit.totalTrades.ColorBackground(clrTomato);
   }
   else gui.riskExposure.edit.totalTrades.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label - gui.riskExposure.label.totalLots 
   gui.riskExposure.label.totalLots.Create(0,"gui.riskExposure.label.totalLots",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.totalLots);
   gui.riskExposure.label.totalLots.Text("Total Lots");
   gui.riskExposure.label.totalLots.Shift(gui.ScaledPixel(5),gui.ScaledPixel(242));
   gui.riskExposure.label.totalLots.FontSize(gui.GetMainFont_S());
   
   //Edit - gui.riskExposure.edit.totalLots 
   gui.riskExposure.edit.totalLots.Create(0,"gui.riskExposure.edit.totalLots",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.totalLots);
   gui.riskExposure.edit.totalLots.Shift(gui.ScaledPixel(255),gui.ScaledPixel(240));
   gui.riskExposure.edit.totalLots.ReadOnly(true);
   gui.riskExposure.edit.totalLots.FontSize(gui.GetMainFont_S());
   
   if (sumTrades.GetTotalLots() > riskOptions.GetMaxLots() && 
       riskOptions.GetMaxLots() != -1) {
      gui.riskExposure.edit.totalLots.ColorBackground(clrTomato);
   }
   else gui.riskExposure.edit.totalLots.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total Exp Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Total Exposure
   //Account percentage
   gui.riskExposure.button.percentageTotalExposure.Create(0,"gui.riskExposure.button.percentageTotalExposure",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.button.percentageTotalExposure);
   gui.riskExposure.button.percentageTotalExposure.Shift(gui.ScaledPixel(125),gui.ScaledPixel(275));
   gui.riskExposure.button.percentageTotalExposure.Text("Acc%");
   gui.riskExposure.button.percentageTotalExposure.FontSize(gui.GetsubFont_S());
   //gui.riskExposure.button.percentageTotalExposure.ColorBackground(clrLightBlue);
   //Currency 
   gui.riskExposure.button.currencyTotalExposure.Create(0,"gui.riskExposure.button.currencyTotalExposure",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.button.currencyTotalExposure);
   gui.riskExposure.button.currencyTotalExposure.Shift(gui.ScaledPixel(175),gui.ScaledPixel(275));
   gui.riskExposure.button.currencyTotalExposure.Text(AccountCurrency());
   gui.riskExposure.button.currencyTotalExposure.FontSize(gui.GetsubFont_S());
   //gui.riskExposure.button.currencyTotalExposure.ColorBackground(clrLightBlue);
   //Button Clr OnInit
   if(gui.riskExposure.TE ==1) {
      gui.riskExposure.button.percentageTotalExposure.ColorBackground(clrLightBlue);
      gui.riskExposure.button.currencyTotalExposure.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(gui.riskExposure.TE==2) {
      gui.riskExposure.button.percentageTotalExposure.ColorBackground(C'0xF0,0xF0,0xF0');
      gui.riskExposure.button.currencyTotalExposure.ColorBackground(clrLightBlue);
   }
   
   //Label - gui.riskExposure.label.totalExposure 
   gui.riskExposure.label.totalExposure.Create(0,"gui.riskExposure.label.totalExposure",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.totalExposure);
   gui.riskExposure.label.totalExposure.Text("Total Risk");
   gui.riskExposure.label.totalExposure.Shift(gui.ScaledPixel(5),gui.ScaledPixel(272));
   gui.riskExposure.label.totalExposure.FontSize(gui.GetMainFont_S());
   
   //Edit - gui.riskExposure.edit.totalExposure 
   gui.riskExposure.edit.totalExposure.Create(0,"gui.riskExposure.edit.totalExposure",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.totalExposure);
   gui.riskExposure.edit.totalExposure.Shift(gui.ScaledPixel(255),gui.ScaledPixel(270));
   gui.riskExposure.edit.totalExposure.ReadOnly(true);
   gui.riskExposure.edit.totalExposure.FontSize(gui.GetMainFont_S());
   
   if(gui.riskExposure.TE == 1) {
      if ((sumTrades.GetTotalExpAcc() > riskOptions.GetMaxExpPer() && 
          riskOptions.GetMaxExpPer() != -1) ||
          ((riskOptions.GetMaxExpPer() != -1) && (sumTrades.GetTotalExpAcc() == -10))) {
         gui.riskExposure.edit.totalExposure.ColorBackground(clrTomato);
      }
      else gui.riskExposure.edit.totalExposure.ColorBackground(clrWhiteSmoke);
   }
   
   if(gui.riskExposure.TE == 2) {
      if ((sumTrades.GetTotalExpCur() > riskOptions.GetMaxExpCur() && 
          riskOptions.GetMaxExpCur() != -1) ||
          ((riskOptions.GetMaxExpCur() != -1) && (sumTrades.GetTotalExpAcc() == -10))) {
         gui.riskExposure.edit.totalExposure.ColorBackground(clrTomato);
      }
      else gui.riskExposure.edit.totalExposure.ColorBackground(clrWhiteSmoke);
   }
   
   //-------------------------
   //Total Currency Value of PositionSize
   //-------------------------
   //Label - gui.riskExposure.label.totalPositionValue
   gui.riskExposure.label.totalPositionValue.Create(0,"gui.riskExposure.label.totalPositionValue",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.totalPositionValue);
   gui.riskExposure.label.totalPositionValue.Text("Total " + AccountCurrency() + " Exposure");
   gui.riskExposure.label.totalPositionValue.Shift(gui.ScaledPixel(5),gui.ScaledPixel(302));
   gui.riskExposure.label.totalPositionValue.FontSize(gui.GetMainFont_S());
   
   //Edit - gui.riskExposure.edit.totalPositionValue
   gui.riskExposure.edit.totalPositionValue.Create(0,"gui.riskExposure.edit.totalPositionValue",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.totalPositionValue);
   gui.riskExposure.edit.totalPositionValue.Shift(gui.ScaledPixel(255),gui.ScaledPixel(300));
   gui.riskExposure.edit.totalPositionValue.ReadOnly(true);
   gui.riskExposure.edit.totalPositionValue.FontSize(gui.GetMainFont_S());
   
   if (sumTrades.GetTotalPosVal() > riskOptions.GetMaxPosVal() && 
       riskOptions.GetMaxPosVal() != -1) {
      gui.riskExposure.edit.totalPositionValue.ColorBackground(clrTomato);
   }
   else gui.riskExposure.edit.totalPositionValue.ColorBackground(clrWhiteSmoke);
   
   //--------------------------------------------------------
   // Individual Trade Exposure
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label 
   //-------------------------
   gui.riskExposure.label.tradeSelect_int.Create(0,"gui.riskExposure.label.tradeSelect_int",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.tradeSelect_int);
   gui.riskExposure.label.tradeSelect_int.Text("Individual Trade Exposure");
   gui.riskExposure.label.tradeSelect_int.Shift(gui.ScaledPixel(100),gui.ScaledPixel(340));
   gui.riskExposure.label.tradeSelect_int.Color(clrMediumBlue);
   gui.riskExposure.label.tradeSelect_int.FontSize(gui.GetMainFont_S());

   //-------------------------
   //Choose Trade
   //-------------------------
   //Label gui.riskExposure.label.tradeSelect
   gui.riskExposure.label.tradeSelect.Create(0,"gui.riskExposure.label.tradeSelect",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.tradeSelect);
   gui.riskExposure.label.tradeSelect.Text("Select Trade");
   gui.riskExposure.label.tradeSelect.Shift(gui.ScaledPixel(5),gui.ScaledPixel(372));
   gui.riskExposure.label.tradeSelect.FontSize(gui.GetMainFont_S());
   
   //ComboBox - gui.riskExposure.comboBox.tradeExposure
   gui.riskExposure.comboBox.tradeExposure.Create(0,"gui.riskExposure.comboBox.tradeExposure",0,0,0,gui.ScaledPixel(145),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.comboBox.tradeExposure);
   gui.riskExposure.comboBox.tradeExposure.Shift(gui.ScaledPixel(215),gui.ScaledPixel(370));
   //Add trades to CB
   individualTrade.AddToCB_Singular_Trades(gui);
   
   //-------------------------
   //Singular Trade EXP in Currency or Account%
   //-------------------------
   //Label gui.riskExposure.label.tradeSelect
   gui.riskExposure.label.tradeExposure.Create(0,"gui.riskExposure.label.tradeExposure",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.tradeExposure);
   gui.riskExposure.label.tradeExposure.Text("Trade Risk");
   gui.riskExposure.label.tradeExposure.Shift(gui.ScaledPixel(5),gui.ScaledPixel(402));
   gui.riskExposure.label.tradeExposure.FontSize(gui.GetMainFont_S());
   
   //Edit gui.riskExposure.edit.tradeExposure
   gui.riskExposure.edit.tradeExposure.Create(0,"gui.riskExposure.edit.tradeExposure",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.tradeExposure);
   gui.riskExposure.edit.tradeExposure.Shift(gui.ScaledPixel(255),gui.ScaledPixel(400));
   gui.riskExposure.edit.tradeExposure.ReadOnly(true);
   gui.riskExposure.edit.tradeExposure.ColorBackground(clrWhiteSmoke);
   gui.riskExposure.edit.tradeExposure.FontSize(gui.GetMainFont_S());
   
   //Edit gui.riskExposure.edit.tradePositionValue
   gui.riskExposure.edit.tradePositionValue.Create(0,"gui.riskExposure.edit.tradePositionValue",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.edit.tradePositionValue);
   gui.riskExposure.edit.tradePositionValue.Shift(gui.ScaledPixel(255),gui.ScaledPixel(430));
   gui.riskExposure.edit.tradePositionValue.ReadOnly(true);
   gui.riskExposure.edit.tradePositionValue.ColorBackground(clrWhiteSmoke);
   gui.riskExposure.edit.tradePositionValue.FontSize(gui.GetMainFont_S());
   
   //Choose Currency or Account Percentage for Individual Trade Exposure
   //Currency 
   gui.riskExposure.button.currencyIndivualTradeExposure.Create(0,"gui.riskExposure.button.currencyIndivualTradeExposure",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.button.currencyIndivualTradeExposure);
   gui.riskExposure.button.currencyIndivualTradeExposure.Shift(gui.ScaledPixel(175),gui.ScaledPixel(405));
   gui.riskExposure.button.currencyIndivualTradeExposure.Text(AccountCurrency());
   gui.riskExposure.button.currencyIndivualTradeExposure.FontSize(gui.GetsubFont_S());
   //Account percentage
   gui.riskExposure.button.percentageIndivualTradeExposure.Create(0,"gui.riskExposure.button.percentageIndivualTradeExposure",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.button.percentageIndivualTradeExposure);
   gui.riskExposure.button.percentageIndivualTradeExposure.Shift(gui.ScaledPixel(125),gui.ScaledPixel(405));
   gui.riskExposure.button.percentageIndivualTradeExposure.Text("Acc%");
   gui.riskExposure.button.percentageIndivualTradeExposure.FontSize(gui.GetsubFont_S());
   //Button Clr OnInit
   if(gui.riskExposure.ITE ==1) {
      gui.riskExposure.button.percentageIndivualTradeExposure.ColorBackground(clrLightBlue);
      gui.riskExposure.button.currencyIndivualTradeExposure.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(gui.riskExposure.ITE ==2) {
      gui.riskExposure.button.percentageIndivualTradeExposure.ColorBackground(C'0xF0,0xF0,0xF0');
      gui.riskExposure.button.currencyIndivualTradeExposure.ColorBackground(clrLightBlue);
   }
   
   //-------------------------
   //Singular Currency Value of PositionSize
   //-------------------------
   //Label gui.riskExposure.label.tradePositionValue
   gui.riskExposure.label.tradePositionValue.Create(0,"gui.riskExposure.label.tradePositionValue",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.riskExposure.label.tradePositionValue);
   gui.riskExposure.label.tradePositionValue.Text(AccountCurrency() + " Exposure");
   gui.riskExposure.label.tradePositionValue.Shift(gui.ScaledPixel(5),gui.ScaledPixel(432));
   gui.riskExposure.label.tradePositionValue.FontSize(gui.GetMainFont_S());
}