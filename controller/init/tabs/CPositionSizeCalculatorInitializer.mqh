//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

//+------------------------------------------------------------------+
//| Position Size Calculator Initialiser class                       |
//+------------------------------------------------------------------+
class CPositionSizeCalculatorInitializer {

public:

   void create(CGuiControl &gui, double contractSize);
};

//+------------------------------------------------------------------+
//| create Method Defenition                                         |
//+------------------------------------------------------------------+
void CPositionSizeCalculatorInitializer::create(CGuiControl &gui, double contractSize) {

   CAppDialog *window =  gui.mainWindow.windowDialog;
   
   //-------------------------
   //Button - gui.positionSizeCalculator.button.tabPSC 
   CButton *tabPSC = gui.positionSizeCalculator.button.tabPSC;
   tabPSC.Create(0,"tabPSC",0,gui.ScaledPixel(5),gui.ScaledPixel(5),gui.ScaledPixel(180),gui.ScaledPixel(30));                
   tabPSC.Text("Position Size Calculator");
   window.Add(tabPSC);
   tabPSC.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Risk per trade
   //-------------------------
   //Label
   CLabel *riskPerTradeLabel = gui.positionSizeCalculator.label.riskPerTrade;
   riskPerTradeLabel.Create(0,"riskPerTradeLabel",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));                         
   window.Add(riskPerTradeLabel);
   riskPerTradeLabel.Text("Risk On Trade (% of Account Balance)");
   riskPerTradeLabel.Shift(gui.ScaledPixel(5),gui.ScaledPixel(45));
   riskPerTradeLabel.FontSize(gui.GetMainFont_S());
   
   //Edit box
   CEdit *riskPerTradeEdit = gui.positionSizeCalculator.edit.riskPerTrade;
   riskPerTradeEdit.Create(0,"riskPerTradeEdit",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));                
   window.Add(riskPerTradeEdit);
   riskPerTradeEdit.Shift(gui.ScaledPixel(255),gui.ScaledPixel(45));
   riskPerTradeEdit.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Entry Price
   //-------------------------
   //Label
   CLabel *entryPriceLabel = gui.positionSizeCalculator.label.entryPrice;
   entryPriceLabel.Create(0,"entryPriceLabel",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));                   
   window.Add(entryPriceLabel);
   entryPriceLabel.Text("Entry Price");
   entryPriceLabel.Shift(gui.ScaledPixel(5), gui.ScaledPixel(75));                  
   entryPriceLabel.FontSize(gui.GetMainFont_S());
   
   //Edit box
   CEdit *entryPriceEdit = gui.positionSizeCalculator.edit.entryPrice;
   entryPriceEdit.Create(0,"entryPriceEdit",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(entryPriceEdit);
   entryPriceEdit.Shift(gui.ScaledPixel(255),gui.ScaledPixel(75));
   entryPriceEdit.ReadOnly(true);
   entryPriceEdit.ColorBackground(clrWhiteSmoke);
   entryPriceEdit.FontSize(gui.GetMainFont_S());
   
   //Button - Custom 
   CButton *priceCustom = gui.positionSizeCalculator.button.priceCustom;
   priceCustom.Create(0,"priceCustom",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));        
   window.Add(priceCustom);
   priceCustom.Shift(gui.ScaledPixel(80),gui.ScaledPixel(77));
   priceCustom.Text("Custom");
   priceCustom.FontSize(gui.GetsubFont_S());
   priceCustom.ColorBackground(clrLightBlue);
   
   //Button - Bid 
   CButton *priceBid = gui.positionSizeCalculator.button.priceBid;
   priceBid.Create(0,"priceBid",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));
   window.Add(priceBid);
   priceBid.Shift(gui.ScaledPixel(135),gui.ScaledPixel(77));
   priceBid.Text("Bid");
   gui.positionSizeCalculator.button.priceBid.FontSize(gui.GetsubFont_S());
   gui.positionSizeCalculator.button.priceBid.ColorBackground(clrTomato);
   
   //Button - Ask
   gui.positionSizeCalculator.button.priceAsk.Create(0,"priceAsk",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));  
   window.Add(gui.positionSizeCalculator.button.priceAsk);
   gui.positionSizeCalculator.button.priceAsk.Shift(gui.ScaledPixel(190),gui.ScaledPixel(77));
   gui.positionSizeCalculator.button.priceAsk.Text("Ask");
   gui.positionSizeCalculator.button.priceAsk.FontSize(gui.GetsubFont_S());
   gui.positionSizeCalculator.button.priceAsk.ColorBackground(clrMediumSeaGreen);
   
   //-------------------------
   //Stop Loss
   //-------------------------
   //Label
   gui.positionSizeCalculator.label.stopLoss.Create(0,"stopLossLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));  
   window.Add(gui.positionSizeCalculator.label.stopLoss);
   gui.positionSizeCalculator.label.stopLoss.Text("Stop Loss Price");
   gui.positionSizeCalculator.label.stopLoss.Shift(gui.ScaledPixel(5),gui.ScaledPixel(105));
   gui.positionSizeCalculator.label.stopLoss.FontSize(gui.GetMainFont_S());
   
   //Edit box
   gui.positionSizeCalculator.edit.stopLoss.Create(0,"stopLossEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(gui.positionSizeCalculator.edit.stopLoss);
   gui.positionSizeCalculator.edit.stopLoss.Shift(gui.ScaledPixel(255),gui.ScaledPixel(105));
   gui.positionSizeCalculator.edit.stopLoss.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Button - gui.positionSizeCalculator.button.calculate 
   //-------------------------
   gui.positionSizeCalculator.button.calculate.Create(0,"calculateBUTTON",0,0,0,gui.ScaledPixel(75),gui.ScaledPixel(25));
   window.Add(gui.positionSizeCalculator.button.calculate);
   gui.positionSizeCalculator.button.calculate.Shift(gui.ScaledPixel(150),gui.ScaledPixel(135));
   gui.positionSizeCalculator.button.calculate.Text("Calculate");
   gui.positionSizeCalculator.button.calculate.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Points
   //-------------------------
   //Label 
   gui.positionSizeCalculator.label.riskInPoints.Create(0,"riskInPointsLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(gui.positionSizeCalculator.label.riskInPoints);
   gui.positionSizeCalculator.label.riskInPoints.Text("Risk in Points");
   gui.positionSizeCalculator.label.riskInPoints.Shift(gui.ScaledPixel(5),gui.ScaledPixel(170));
   gui.positionSizeCalculator.label.riskInPoints.FontSize(gui.GetMainFont_S());
   
   //Edit box
   gui.positionSizeCalculator.edit.riskInPoints.Create(0,"riskInPointsEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(gui.positionSizeCalculator.edit.riskInPoints);
   gui.positionSizeCalculator.edit.riskInPoints.Shift(gui.ScaledPixel(255),gui.ScaledPixel(170));
   gui.positionSizeCalculator.edit.riskInPoints.ReadOnly(true);
   gui.positionSizeCalculator.edit.riskInPoints.ColorBackground(clrWhiteSmoke);
   gui.positionSizeCalculator.edit.riskInPoints.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Currency
   //-------------------------
   //Label 
   gui.positionSizeCalculator.label.riskInCurrency.Create(0,"riskInCurrencyLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(gui.positionSizeCalculator.label.riskInCurrency);
   gui.positionSizeCalculator.label.riskInCurrency.Text("Risk in " + AccountCurrency());
   gui.positionSizeCalculator.label.riskInCurrency.Shift(gui.ScaledPixel(5),gui.ScaledPixel(200));
   gui.positionSizeCalculator.label.riskInCurrency.FontSize(gui.GetMainFont_S());
   
   //Edit box
   gui.positionSizeCalculator.edit.riskInCurrency.Create(0,"riskInCurrencyEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(gui.positionSizeCalculator.edit.riskInCurrency);
   gui.positionSizeCalculator.edit.riskInCurrency.Shift(gui.ScaledPixel(255),gui.ScaledPixel(200));
   gui.positionSizeCalculator.edit.riskInCurrency.ReadOnly(true);
   gui.positionSizeCalculator.edit.riskInCurrency.ColorBackground(clrWhiteSmoke);
   gui.positionSizeCalculator.edit.riskInCurrency.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Contract_Size
   //-------------------------
   //Label
   gui.positionSizeCalculator.label.contractSize.Create(0,"contractSizeLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(gui.positionSizeCalculator.label.contractSize);
   gui.positionSizeCalculator.label.contractSize.Text("Contract Size");
   gui.positionSizeCalculator.label.contractSize.Shift(gui.ScaledPixel(5),gui.ScaledPixel(230));
   gui.positionSizeCalculator.label.contractSize.FontSize(gui.GetMainFont_S());
   
   //Edit 
   gui.positionSizeCalculator.edit.contractSize.Create(0,"contractSizeEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));       
   window.Add(gui.positionSizeCalculator.edit.contractSize);
   gui.positionSizeCalculator.edit.contractSize.Shift(gui.ScaledPixel(255),gui.ScaledPixel(230));
   gui.positionSizeCalculator.edit.contractSize.ReadOnly(true);
   gui.positionSizeCalculator.edit.contractSize.ColorBackground(clrGainsboro);
   gui.positionSizeCalculator.edit.contractSize.Text((string)contractSize);
   gui.positionSizeCalculator.edit.contractSize.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total_Units
   //-------------------------
   //Label
   gui.positionSizeCalculator.label.totalUnits.Create(0,"totalUnitsLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(gui.positionSizeCalculator.label.totalUnits);
   gui.positionSizeCalculator.label.totalUnits.Text("Total Units");
   gui.positionSizeCalculator.label.totalUnits.Shift(gui.ScaledPixel(5),gui.ScaledPixel(260));
   gui.positionSizeCalculator.label.totalUnits.FontSize(gui.GetMainFont_S());
   
   //Edit 
   gui.positionSizeCalculator.edit.totalUnits.Create(0,"totalUnitsEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(gui.positionSizeCalculator.edit.totalUnits);
   gui.positionSizeCalculator.edit.totalUnits.Shift(gui.ScaledPixel(255),gui.ScaledPixel(260));
   gui.positionSizeCalculator.edit.totalUnits.ReadOnly(true);
   gui.positionSizeCalculator.edit.totalUnits.ColorBackground(clrWhiteSmoke);
   gui.positionSizeCalculator.edit.totalUnits.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label
   gui.positionSizeCalculator.label.totalLots.Create(0,"totalLots_LABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(gui.positionSizeCalculator.label.totalLots);
   gui.positionSizeCalculator.label.totalLots.Text("Total Lots");
   gui.positionSizeCalculator.label.totalLots.Shift(gui.ScaledPixel(5),gui.ScaledPixel(290));
   gui.positionSizeCalculator.label.totalLots.FontSize(gui.GetMainFont_S());
   
   //Edit 
   gui.positionSizeCalculator.edit.totalLots.Create(0,"totalLots_EDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(gui.positionSizeCalculator.edit.totalLots);
   gui.positionSizeCalculator.edit.totalLots.Shift(gui.ScaledPixel(255),gui.ScaledPixel(290));
   gui.positionSizeCalculator.edit.totalLots.ReadOnly(true);
   gui.positionSizeCalculator.edit.totalLots.ColorBackground(clrGold);
   gui.positionSizeCalculator.edit.totalLots.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total PositionValue 
   //-------------------------
   //label
   gui.positionSizeCalculator.label.positionValue.Create(0,"positionValueLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(gui.positionSizeCalculator.label.positionValue);
   gui.positionSizeCalculator.label.positionValue.Text(AccountCurrency()+" Exposure");
   gui.positionSizeCalculator.label.positionValue.Shift(gui.ScaledPixel(5),gui.ScaledPixel(320));
   gui.positionSizeCalculator.label.positionValue.FontSize(gui.GetMainFont_S());
   
   //edit
   gui.positionSizeCalculator.edit.positionValue.Create(0,"positionValueEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(gui.positionSizeCalculator.edit.positionValue);
   gui.positionSizeCalculator.edit.positionValue.Shift(gui.ScaledPixel(255),gui.ScaledPixel(320));
   gui.positionSizeCalculator.edit.positionValue.ReadOnly(true);
   gui.positionSizeCalculator.edit.positionValue.ColorBackground(clrWhiteSmoke);
   gui.positionSizeCalculator.edit.positionValue.FontSize(gui.GetMainFont_S());
   
}



