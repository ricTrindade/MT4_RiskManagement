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
   CButton *priceAsk = gui.positionSizeCalculator.button.priceAsk;
   priceAsk.Create(0,"priceAsk",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(17));  
   window.Add(priceAsk);
   priceAsk.Shift(gui.ScaledPixel(190),gui.ScaledPixel(77));
   priceAsk.Text("Ask");
   priceAsk.FontSize(gui.GetsubFont_S());
   priceAsk.ColorBackground(clrMediumSeaGreen);
   
   //-------------------------
   //Stop Loss
   //-------------------------
   //Label
   CLabel *stopLossLabel = gui.positionSizeCalculator.label.stopLoss;
   stopLossLabel.Create(0,"stopLossLabel",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));  
   window.Add(stopLossLabel);
   stopLossLabel.Text("Stop Loss Price");
   stopLossLabel.Shift(gui.ScaledPixel(5),gui.ScaledPixel(105));
   stopLossLabel.FontSize(gui.GetMainFont_S());
   
   //Edit box
   CEdit *stopLossEdit = gui.positionSizeCalculator.edit.stopLoss;
   stopLossEdit.Create(0,"stopLossEdit",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(stopLossEdit);
   stopLossEdit.Shift(gui.ScaledPixel(255),gui.ScaledPixel(105));
   stopLossEdit.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Button - calculate 
   //-------------------------
   CButton *calculate = gui.positionSizeCalculator.button.calculate;
   calculate.Create(0,"calculate",0,0,0,gui.ScaledPixel(75),gui.ScaledPixel(25));
   window.Add(calculate);
   calculate.Shift(gui.ScaledPixel(150),gui.ScaledPixel(135));
   calculate.Text("Calculate");
   calculate.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Points
   //-------------------------
   //Label 
   CLabel *riskInPointsLabel = gui.positionSizeCalculator.label.riskInPoints;
   riskInPointsLabel.Create(0,"riskInPointsLabel",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(riskInPointsLabel);
   riskInPointsLabel.Text("Risk in Points");
   riskInPointsLabel.Shift(gui.ScaledPixel(5),gui.ScaledPixel(170));
   riskInPointsLabel.FontSize(gui.GetMainFont_S());
   
   //Edit box
   CEdit *riskInPointsEdit = gui.positionSizeCalculator.edit.riskInPoints;
   riskInPointsEdit.Create(0,"riskInPointsEdit",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(riskInPointsEdit);
   riskInPointsEdit.Shift(gui.ScaledPixel(255),gui.ScaledPixel(170));
   riskInPointsEdit.ReadOnly(true);
   riskInPointsEdit.ColorBackground(clrWhiteSmoke);
   riskInPointsEdit.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Currency
   //-------------------------
   //Label 
   CLabel *riskInCurrencyLabel = gui.positionSizeCalculator.label.riskInCurrency;
   riskInCurrencyLabel.Create(0,"riskInCurrencyLabel",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(riskInCurrencyLabel);
   riskInCurrencyLabel.Text("Risk in " + AccountCurrency());
   riskInCurrencyLabel.Shift(gui.ScaledPixel(5),gui.ScaledPixel(200));
   riskInCurrencyLabel.FontSize(gui.GetMainFont_S());
   
   //Edit box
   CEdit riskInCurrencyEdit = gui.positionSizeCalculator.edit.riskInCurrency;
   riskInCurrencyEdit.Create(0,"riskInCurrencyEdit",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(riskInCurrencyEdit);
   riskInCurrencyEdit.Shift(gui.ScaledPixel(255),gui.ScaledPixel(200));
   riskInCurrencyEdit.ReadOnly(true);
   riskInCurrencyEdit.ColorBackground(clrWhiteSmoke);
   riskInCurrencyEdit.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Contract_Size
   //-------------------------
   //Label
   CLabel *contractSizeLabel = gui.positionSizeCalculator.label.contractSize;
   contractSizeLabel.Create(0,"contractSizeLabel",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(contractSizeLabel);
   contractSizeLabel.Text("Contract Size");
   contractSizeLabel.Shift(gui.ScaledPixel(5),gui.ScaledPixel(230));
   contractSizeLabel.FontSize(gui.GetMainFont_S());
   
   //Edit 
   CEdit *contractSizeEdit = gui.positionSizeCalculator.edit.contractSize;
   contractSizeEdit.Create(0,"contractSizeEdit",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));       
   window.Add(contractSizeEdit);
   contractSizeEdit.Shift(gui.ScaledPixel(255),gui.ScaledPixel(230));
   contractSizeEdit.ReadOnly(true);
   contractSizeEdit.ColorBackground(clrGainsboro);
   contractSizeEdit.Text((string)contractSize);
   contractSizeEdit.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total_Units
   //-------------------------
   //Label
   CLabel *totalUnitsLabel = gui.positionSizeCalculator.label.totalUnits;
   totalUnitsLabel.Create(0,"totalUnitsLabel",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(totalUnitsLabel);
   totalUnitsLabel.Text("Total Units");
   totalUnitsLabel.Shift(gui.ScaledPixel(5),gui.ScaledPixel(260));
   totalUnitsLabel.FontSize(gui.GetMainFont_S());
   
   //Edit 
   CEdit *totalUnitsEdit = gui.positionSizeCalculator.edit.totalUnits;
   totalUnitsEdit.Create(0,"totalUnitsEdit",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(totalUnitsEdit);
   totalUnitsEdit.Shift(gui.ScaledPixel(255),gui.ScaledPixel(260));
   totalUnitsEdit.ReadOnly(true);
   totalUnitsEdit.ColorBackground(clrWhiteSmoke);
   totalUnitsEdit.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label
   CLabel *totalLotsLabel = gui.positionSizeCalculator.label.totalLots;
   totalLotsLabel.Create(0,"totalLotsLabel",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(totalLotsLabel);
   totalLotsLabel.Text("Total Lots");
   totalLotsLabel.Shift(gui.ScaledPixel(5),gui.ScaledPixel(290));
   totalLotsLabel.FontSize(gui.GetMainFont_S());
   
   //Edit 
   CEdit *totalLotsEdit = gui.positionSizeCalculator.edit.totalLots;
   totalLotsEdit.Create(0,"totalLotsEdit",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(totalLotsEdit);
   totalLotsEdit.Shift(gui.ScaledPixel(255),gui.ScaledPixel(290));
   totalLotsEdit.ReadOnly(true);
   totalLotsEdit.ColorBackground(clrGold);
   totalLotsEdit.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total PositionValue 
   //-------------------------
   //label
   CLabel *positionValueLabel = gui.positionSizeCalculator.label.positionValue;
   positionValueLabel.Create(0,"positionValueLabel",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(positionValueLabel);
   positionValueLabel.Text(AccountCurrency()+" Exposure");
   positionValueLabel.Shift(gui.ScaledPixel(5),gui.ScaledPixel(320));
   positionValueLabel.FontSize(gui.GetMainFont_S());
   
   //edit
   CEdit *positionValueEdit = gui.positionSizeCalculator.edit.positionValue;
   positionValueEdit.Create(0,"positionValueEdit",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(positionValueEdit);
   positionValueEdit.Shift(gui.ScaledPixel(255),gui.ScaledPixel(320));
   positionValueEdit.ReadOnly(true);
   positionValueEdit.ColorBackground(clrWhiteSmoke);
   positionValueEdit.FontSize(gui.GetMainFont_S());
}



