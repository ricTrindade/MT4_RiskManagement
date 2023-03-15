//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

//+------------------------------------------------------------------+
//| Include Some Components                                          |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CRiskSettings.mqh" 
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CSumTradesExposure.mqh" 
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\model\CIndivialTradeExposure.mqh"

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

   // Pointer to main window
   CAppDialog *window = gui.mainWindow.windowDialog;
   
   //-------------------------
   //Button - gui.riskExposure.button.tabRiskExposure
   //-------------------------
   CButton *tabRiskExposure = gui.riskExposure.button.tabRiskExposure;
   tabRiskExposure.Create(0,"tabRiskExposure",0,0,0,gui.ScaledPixel(115),gui.ScaledPixel(25));
   tabRiskExposure.Text("Risk Exposure");
   tabRiskExposure.FontSize(gui.GetMainFont_S());
   window.Add(tabRiskExposure);
   tabRiskExposure.Shift(gui.ScaledPixel(135),gui.ScaledPixel(5));
   
   //--------------------------------------------------------
   // Risk Settings
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label
   //-------------------------
   CLabel *maxIntLABEL = gui.riskExposure.label.maxInt;
   maxIntLABEL.Create(0,"maxIntLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(maxIntLABEL);
   maxIntLABEL.Text("Risk Settings");
   maxIntLABEL.Shift(gui.ScaledPixel(145),gui.ScaledPixel(45));
   maxIntLABEL.Color(clrMediumBlue);
   maxIntLABEL.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //MAX Settings Trades
   //-------------------------
   //Label
   CLabel *maxTradesLABEL = gui.riskExposure.label.maxTrades;
   maxTradesLABEL.Create(0,"maxTradesLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(maxTradesLABEL);
   maxTradesLABEL.Text("MAX # Trades");
   maxTradesLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(72));
   maxTradesLABEL.FontSize(gui.GetMainFont_S());
   
   //edit
   CEdit *maxTradesEDIT = gui.riskExposure.edit.maxTrades;
   maxTradesEDIT.Create(0,"maxTradesEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(maxTradesEDIT);
   maxTradesEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(70));
   maxTradesEDIT.ReadOnly(true);
   maxTradesEDIT.ColorBackground(clrWhiteSmoke);
   maxTradesEDIT.FontSize(gui.GetMainFont_S());
   if (riskOptions.GetMaxTrades() != -1) maxTradesEDIT.Text((string)riskOptions.GetMaxTrades());
   
   //bmp
   CBmpButton *maxTradesBMP = gui.riskExposure.bmpButton.maxTrades;
   maxTradesBMP.Create(0,"maxTradesBMP",0,0,0,0,0);
   maxTradesBMP.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                              "::Include\\Controls\\res\\CheckBoxOn.bmp");
   window.Add(maxTradesBMP); 
   maxTradesBMP.Shift(gui.ScaledPixel(230),gui.ScaledPixel(75));
   
   //-------------------------
   //MAX Settings Lots
   //-------------------------
   //Label
   CLabel *maxLotsLABEL = gui.riskExposure.label.maxLots;
   maxLotsLABEL.Create(0,"maxLotsLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(maxLotsLABEL);
   maxLotsLABEL.Text("MAX Lots");
   maxLotsLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(102));
   maxLotsLABEL.FontSize(gui.GetMainFont_S());
   
   //edit
   CEdit *maxLotsEDIT = gui.riskExposure.edit.maxLots;
   maxLotsEDIT.Create(0,"maxLotsEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(maxLotsEDIT);
   maxLotsEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(100));
   maxLotsEDIT.ReadOnly(true);
   maxLotsEDIT.ColorBackground(clrWhiteSmoke);
   maxLotsEDIT.FontSize(gui.GetMainFont_S());
   if (riskOptions.GetMaxLots() != -1) maxLotsEDIT.Text((string)riskOptions.GetMaxLots());
   
   //bmp
   CBmpButton *maxLotsBMP = gui.riskExposure.bmpButton.maxLots;
   maxLotsBMP.Create(0,"maxLotsBMP",0,0,0,0,0);
   maxLotsBMP.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                            "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   window.Add(maxLotsBMP); 
   maxLotsBMP.Shift(gui.ScaledPixel(230),gui.ScaledPixel(105));
   
   //-------------------------
   //MAX Settings Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Risk Settings
   //Account percentage
   CButton *percentageRiskSettingsBUTTON = gui.riskExposure.button.percentageRiskSettings;
   percentageRiskSettingsBUTTON.Create(0,"percentageRiskSettingsBUTTON",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   window.Add(percentageRiskSettingsBUTTON);
   percentageRiskSettingsBUTTON.Shift(gui.ScaledPixel(125),gui.ScaledPixel(135));
   percentageRiskSettingsBUTTON.Text("Acc%");
   percentageRiskSettingsBUTTON.FontSize(gui.GetsubFont_S());
   //Currency 
   CButton *currencyRiskSettingsBUTTON = gui.riskExposure.button.currencyRiskSettings;
   currencyRiskSettingsBUTTON.Create(0,"currencyRiskSettingsBUTTON",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   window.Add(currencyRiskSettingsBUTTON);
   currencyRiskSettingsBUTTON.Shift(gui.ScaledPixel(175),gui.ScaledPixel(135));
   currencyRiskSettingsBUTTON.Text(AccountCurrency());
   currencyRiskSettingsBUTTON.FontSize(gui.GetsubFont_S());
   //Button Clr OnInit
   if(gui.riskExposure.RS ==1) {
      percentageRiskSettingsBUTTON.ColorBackground(clrLightBlue);
      currencyRiskSettingsBUTTON.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(gui.riskExposure.RS==2){
      percentageRiskSettingsBUTTON.ColorBackground(C'0xF0,0xF0,0xF0');
      currencyRiskSettingsBUTTON.ColorBackground(clrLightBlue);
   }
   
   //Label
   CLabel *maxExposureLABEL = gui.riskExposure.label.maxExposure;
   maxExposureLABEL.Create(0,"maxExposureLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(maxExposureLABEL);
   maxExposureLABEL.Text("MAX Risk");
   maxExposureLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(132));
   maxExposureLABEL.FontSize(gui.GetMainFont_S());
   
   //edit Currency
   CEdit *maxExposureEDIT = gui.riskExposure.edit.maxExposure;
   maxExposureEDIT.Create(0,"maxExposureEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(maxExposureEDIT);
   maxExposureEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(130));
   maxExposureEDIT.ReadOnly(true);
   maxExposureEDIT.ColorBackground(clrWhiteSmoke);
   if(gui.riskExposure.RS ==1) {
      if (riskOptions.GetMaxExpPer() != -1) 
         maxExposureEDIT.Text(DoubleToString(riskOptions.GetMaxExpPer(),2) + " %");
   }   
   if(gui.riskExposure.RS==2){
      if (riskOptions.GetMaxExpCur() != -1) 
         maxExposureEDIT.Text(DoubleToString(riskOptions.GetMaxExpCur(),2) + " "+AccountCurrency());
   }
   maxExposureEDIT.FontSize(gui.GetMainFont_S());
   
   //bmp
   CBmpButton *maxExposureBMP = gui.riskExposure.bmpButton.maxExposure;
   maxExposureBMP.Create(0,"maxExposureBMP",0,0,0,0,0);
   maxExposureBMP.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   window.Add(maxExposureBMP); 
   maxExposureBMP.Shift(gui.ScaledPixel(230),gui.ScaledPixel(135));
   
   //-------------------------
   //Max Currency Value of PositionSize
   //-------------------------
   //Label
   CLabel *maxPositionValueLABEL = gui.riskExposure.label.maxPositionValue;
   maxPositionValueLABEL.Create(0,"maxPositionValueLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(maxPositionValueLABEL);
   maxPositionValueLABEL.Text("MAX " + AccountCurrency() + " Exposure");
   maxPositionValueLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(162));
   maxPositionValueLABEL.FontSize(gui.GetMainFont_S());
   
   //bmp
   CBmpButton *maxPositionValueBMP = gui.riskExposure.bmpButton.maxPositionValue;
   maxPositionValueBMP.Create(0,"maxPositionValueBMP",0,0,0,0,0);
   maxPositionValueBMP.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   window.Add(maxPositionValueBMP); 
   maxPositionValueBMP.Shift(gui.ScaledPixel(230),gui.ScaledPixel(165));
   
   //edit
   CEdit *maxPositionValueEDIT = gui.riskExposure.edit.maxPositionValue;
   maxPositionValueEDIT.Create(0,"maxPositionValueEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(maxPositionValueEDIT);
   maxPositionValueEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(160));
   maxPositionValueEDIT.ReadOnly(true);
   maxPositionValueEDIT.ColorBackground(clrWhiteSmoke);
   maxPositionValueEDIT.FontSize(gui.GetMainFont_S());
   if (riskOptions.GetMaxPosVal() != -1) maxPositionValueEDIT.Text((string)riskOptions.GetMaxPosVal() + " "+AccountCurrency());
   
   //--------------------------------------------------------
   // Total Exposure
   //--------------------------------------------------------
  
   //-------------------------
   //Introduction Label
   //-------------------------
   CLabel *totalExposure_intLABEL = gui.riskExposure.label.totalExposure_int;
   totalExposure_intLABEL.Create(0,"totalExposure_intLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   totalExposure_intLABEL.Text("Total Exposure");
   window.Add(totalExposure_intLABEL);
   totalExposure_intLABEL.Shift(gui.ScaledPixel(140),gui.ScaledPixel(188));
   totalExposure_intLABEL.Color(clrMediumBlue);
   totalExposure_intLABEL.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total_Trades
   //-------------------------
   //Label - totalTradesLABEL 
   CLabel *totalTradesLABEL = gui.riskExposure.label.totalTrades;
   totalTradesLABEL.Create(0,"totalTradesLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(totalTradesLABEL);
   totalTradesLABEL.Text("Total Trades");
   totalTradesLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(212));
   totalTradesLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit - totalTradesEDIT 
   CEdit *totalTradesEDIT = gui.riskExposure.edit.totalTrades;
   totalTradesEDIT.Create(0,"totalTradesEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(totalTradesEDIT);
   totalTradesEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(210));
   totalTradesEDIT.ReadOnly(true);
   totalTradesEDIT.FontSize(gui.GetMainFont_S());
   
   if (sumTrades.GetTotalTrades() > riskOptions.GetMaxTrades() && 
       riskOptions.GetMaxTrades() != -1) {
      totalTradesEDIT.ColorBackground(clrTomato);
   }
   else totalTradesEDIT.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label - totalLotsLABEL 
   CLabel *totalLotsLABEL = gui.riskExposure.label.totalLots;
   totalLotsLABEL.Create(0,"totalLotsLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(totalLotsLABEL);
   totalLotsLABEL.Text("Total Lots");
   totalLotsLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(242));
   totalLotsLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit - totalLotsEDIT 
   CEdit *totalLotsEDIT = gui.riskExposure.edit.totalLots;
   totalLotsEDIT.Create(0,"totalLotsEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(totalLotsEDIT);
   totalLotsEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(240));
   totalLotsEDIT.ReadOnly(true);
   totalLotsEDIT.FontSize(gui.GetMainFont_S());
   
   if (sumTrades.GetTotalLots() > riskOptions.GetMaxLots() && 
       riskOptions.GetMaxLots() != -1) {
      totalLotsEDIT.ColorBackground(clrTomato);
   }
   else totalLotsEDIT.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total Exp Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Total Exposure
   //Account percentage
   CButton *percentageTotalExposureBUTTON = gui.riskExposure.button.percentageTotalExposure;
   percentageTotalExposureBUTTON.Create(0,"percentageTotalExposureBUTTON",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   window.Add(percentageTotalExposureBUTTON);
   percentageTotalExposureBUTTON.Shift(gui.ScaledPixel(125),gui.ScaledPixel(275));
   percentageTotalExposureBUTTON.Text("Acc%");
   percentageTotalExposureBUTTON.FontSize(gui.GetsubFont_S());
   //percentageTotalExposureBUTTON.ColorBackground(clrLightBlue);
   //Currency 
   CButton *currencyTotalExposureBUTTON = gui.riskExposure.button.currencyTotalExposure;
   currencyTotalExposureBUTTON.Create(0,"currencyTotalExposureBUTTON",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   window.Add(currencyTotalExposureBUTTON);
   currencyTotalExposureBUTTON.Shift(gui.ScaledPixel(175),gui.ScaledPixel(275));
   currencyTotalExposureBUTTON.Text(AccountCurrency());
   currencyTotalExposureBUTTON.FontSize(gui.GetsubFont_S());
   //currencyTotalExposureBUTTON.ColorBackground(clrLightBlue);
   //Button Clr OnInit
   if(gui.riskExposure.TE ==1) {
      percentageTotalExposureBUTTON.ColorBackground(clrLightBlue);
      currencyTotalExposureBUTTON.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(gui.riskExposure.TE==2) {
      percentageTotalExposureBUTTON.ColorBackground(C'0xF0,0xF0,0xF0');
      currencyTotalExposureBUTTON.ColorBackground(clrLightBlue);
   }
   
   //Label - totalExposureLABEL 
   CLabel *totalExposureLABEL = gui.riskExposure.label.totalExposure;
   totalExposureLABEL.Create(0,"totalExposureLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(totalExposureLABEL);
   totalExposureLABEL.Text("Total Risk");
   totalExposureLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(272));
   totalExposureLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit - totalExposureEDIT 
   CEdit *totalExposureEDIT = gui.riskExposure.edit.totalExposure;
   totalExposureEDIT.Create(0,"totalExposureEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(totalExposureEDIT);
   totalExposureEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(270));
   totalExposureEDIT.ReadOnly(true);
   totalExposureEDIT.FontSize(gui.GetMainFont_S());
   
   if(gui.riskExposure.TE == 1) {
      if ((sumTrades.GetTotalExpAcc() > riskOptions.GetMaxExpPer() && 
          riskOptions.GetMaxExpPer() != -1) ||
          ((riskOptions.GetMaxExpPer() != -1) && (sumTrades.GetTotalExpAcc() == -10))) {
         totalExposureEDIT.ColorBackground(clrTomato);
      }
      else totalExposureEDIT.ColorBackground(clrWhiteSmoke);
   }
   
   if(gui.riskExposure.TE == 2) {
      if ((sumTrades.GetTotalExpCur() > riskOptions.GetMaxExpCur() && 
          riskOptions.GetMaxExpCur() != -1) ||
          ((riskOptions.GetMaxExpCur() != -1) && (sumTrades.GetTotalExpAcc() == -10))) {
         totalExposureEDIT.ColorBackground(clrTomato);
      }
      else totalExposureEDIT.ColorBackground(clrWhiteSmoke);
   }
   
   //-------------------------
   //Total Currency Value of PositionSize
   //-------------------------
   //Label - totalPositionValueLABEL
   CLabel *totalPositionValueLABEL = gui.riskExposure.label.totalPositionValue;
   totalPositionValueLABEL.Create(0,"totalPositionValueLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(totalPositionValueLABEL);
   totalPositionValueLABEL.Text("Total " + AccountCurrency() + " Exposure");
   totalPositionValueLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(302));
   totalPositionValueLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit - totalPositionValueEDIT
   CEdit *totalPositionValueEDIT = gui.riskExposure.edit.totalPositionValue;
   totalPositionValueEDIT.Create(0,"totalPositionValueEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(totalPositionValueEDIT);
   totalPositionValueEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(300));
   totalPositionValueEDIT.ReadOnly(true);
   totalPositionValueEDIT.FontSize(gui.GetMainFont_S());
   
   if (sumTrades.GetTotalPosVal() > riskOptions.GetMaxPosVal() && 
       riskOptions.GetMaxPosVal() != -1) {
      totalPositionValueEDIT.ColorBackground(clrTomato);
   }
   else totalPositionValueEDIT.ColorBackground(clrWhiteSmoke);
   
   //--------------------------------------------------------
   // Individual Trade Exposure
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label 
   //-------------------------
   CLabel *tradeSelect_intLABEL = gui.riskExposure.label.tradeSelect_int;
   tradeSelect_intLABEL.Create(0,"tradeSelect_intLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(tradeSelect_intLABEL);
   tradeSelect_intLABEL.Text("Individual Trade Exposure");
   tradeSelect_intLABEL.Shift(gui.ScaledPixel(100),gui.ScaledPixel(340));
   tradeSelect_intLABEL.Color(clrMediumBlue);
   tradeSelect_intLABEL.FontSize(gui.GetMainFont_S());

   //-------------------------
   //Choose Trade
   //-------------------------
   //Label tradeSelectLABEL
   CLabel *tradeSelectLABEL = gui.riskExposure.label.tradeSelect;
   tradeSelectLABEL.Create(0,"tradeSelectLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(tradeSelectLABEL);
   tradeSelectLABEL.Text("Select Trade");
   tradeSelectLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(372));
   tradeSelectLABEL.FontSize(gui.GetMainFont_S());
   
   //ComboBox - tradeExposureComboBox
   CComboBox *tradeExposureComboBox = gui.riskExposure.comboBox.tradeExposure;
   tradeExposureComboBox.Create(0,"tradeExposureComboBox",0,0,0,gui.ScaledPixel(145),gui.ScaledPixel(25));
   window.Add(tradeExposureComboBox);
   tradeExposureComboBox.Shift(gui.ScaledPixel(215),gui.ScaledPixel(370));
   //Add trades to CB
   individualTrade.AddToCB_Singular_Trades(gui);
   
   //-------------------------
   //Singular Trade EXP in Currency or Account%
   //-------------------------
   //Label tradeSelectLABEL
   CLabel *tradeExposureLABEL = gui.riskExposure.label.tradeExposure;
   tradeExposureLABEL.Create(0,"tradeExposureLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(tradeExposureLABEL);
   tradeExposureLABEL.Text("Trade Risk");
   tradeExposureLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(402));
   tradeExposureLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit tradeExposureEDIT
   CEdit *tradeExposureEDIT = gui.riskExposure.edit.tradeExposure;
   tradeExposureEDIT.Create(0,"tradeExposureEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(tradeExposureEDIT);
   tradeExposureEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(400));
   tradeExposureEDIT.ReadOnly(true);
   tradeExposureEDIT.ColorBackground(clrWhiteSmoke);
   tradeExposureEDIT.FontSize(gui.GetMainFont_S());
   
   //Edit tradePositionValueEDIT
   CEdit *tradePositionValueEDIT = gui.riskExposure.edit.tradePositionValue;
   tradePositionValueEDIT.Create(0,"tradePositionValueEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(tradePositionValueEDIT);
   tradePositionValueEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(430));
   tradePositionValueEDIT.ReadOnly(true);
   tradePositionValueEDIT.ColorBackground(clrWhiteSmoke);
   tradePositionValueEDIT.FontSize(gui.GetMainFont_S());
   
   //Choose Currency or Account Percentage for Individual Trade Exposure
   //Currency 
   CButton *currencyIndivualTradeExposureBUTTON = gui.riskExposure.button.currencyIndivualTradeExposure;
   currencyIndivualTradeExposureBUTTON.Create(0,"currencyIndivualTradeExposureBUTTON",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   window.Add(currencyIndivualTradeExposureBUTTON);
   currencyIndivualTradeExposureBUTTON.Shift(gui.ScaledPixel(175),gui.ScaledPixel(405));
   currencyIndivualTradeExposureBUTTON.Text(AccountCurrency());
   currencyIndivualTradeExposureBUTTON.FontSize(gui.GetsubFont_S());
   //Account percentage
   CButton *percentageIndivualTradeExposureBUTTON = gui.riskExposure.button.percentageIndivualTradeExposure;
   percentageIndivualTradeExposureBUTTON.Create(0,"percentageIndivualTradeExposureBUTTON",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   window.Add(percentageIndivualTradeExposureBUTTON);
   percentageIndivualTradeExposureBUTTON.Shift(gui.ScaledPixel(125),gui.ScaledPixel(405));
   percentageIndivualTradeExposureBUTTON.Text("Acc%");
   percentageIndivualTradeExposureBUTTON.FontSize(gui.GetsubFont_S());
   //Button Clr OnInit
   if(gui.riskExposure.ITE ==1) {
      percentageIndivualTradeExposureBUTTON.ColorBackground(clrLightBlue);
      currencyIndivualTradeExposureBUTTON.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(gui.riskExposure.ITE ==2) {
      percentageIndivualTradeExposureBUTTON.ColorBackground(C'0xF0,0xF0,0xF0');
      currencyIndivualTradeExposureBUTTON.ColorBackground(clrLightBlue);
   }
   
   //-------------------------
   //Singular Currency Value of PositionSize
   //-------------------------
   //Label tradePositionValueLABEL
   CLabel *tradePositionValueLABEL = gui.riskExposure.label.tradePositionValue;
   tradePositionValueLABEL.Create(0,"tradePositionValueLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(tradePositionValueLABEL);
   tradePositionValueLABEL.Text(AccountCurrency() + " Exposure");
   tradePositionValueLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(432));
   tradePositionValueLABEL.FontSize(gui.GetMainFont_S());
}