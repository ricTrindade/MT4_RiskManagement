//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

//+------------------------------------------------------------------+
//| Position Size Calculator Initialiser class                       |
//+------------------------------------------------------------------+
class CPositionSizeCalculatorInitializer {

public:

   void create(CGuiControl &gui);
};

//+------------------------------------------------------------------+
//| create Method Defenition                                         |
//+------------------------------------------------------------------+
void CPositionSizeCalculatorInitializer::create(CGuiControl &gui) {

   CAppDialog *window =  gui.mainWindow.windowDialog;
   
   //-------------------------
   //Button - gui.positionSizeCalculator.button.tabPSC 
   CButton *tabPSC = gui.positionSizeCalculator.button.tabPSC;
   tabPSC.Create(0,"tabPSC",0,0,0,gui.ScaledPixel(115),gui.ScaledPixel(25));                
   tabPSC.Text("Size Calculator");
   tabPSC.FontSize(gui.GetMainFont_S());
   window.Add(tabPSC);
   tabPSC.Shift(gui.ScaledPixel(5),gui.ScaledPixel(5));
   
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
   priceBid.FontSize(gui.GetsubFont_S());
   priceBid.ColorBackground(clrTomato);
   
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
   CLabel *stopLossLABEL = gui.positionSizeCalculator.label.stopLoss;
   stopLossLABEL.Create(0,"stopLossLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));  
   window.Add(stopLossLABEL);
   stopLossLABEL.Text("Stop Loss Price");
   stopLossLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(105));
   stopLossLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit box
   CEdit *stopLossEDIT = gui.positionSizeCalculator.edit.stopLoss;
   stopLossEDIT.Create(0,"stopLossEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(stopLossEDIT);
   stopLossEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(105));
   stopLossEDIT.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Button - gui.positionSizeCalculator.button.calculate 
   //-------------------------
   CButton *calculateBUTTON = gui.positionSizeCalculator.button.calculate;
   calculateBUTTON.Create(0,"calculateBUTTON",0,0,0,gui.ScaledPixel(75),gui.ScaledPixel(25));
   window.Add(calculateBUTTON);
   calculateBUTTON.Shift(gui.ScaledPixel(150),gui.ScaledPixel(135));
   calculateBUTTON.Text("Calculate");
   calculateBUTTON.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Points
   //-------------------------
   //Label 
   CLabel *riskInPointsLABEL = gui.positionSizeCalculator.label.riskInPoints;
   riskInPointsLABEL.Create(0,"riskInPointsLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(riskInPointsLABEL);
   riskInPointsLABEL.Text("Risk in Points");
   riskInPointsLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(170));
   riskInPointsLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit box
   CEdit *riskInPointsEDIT = gui.positionSizeCalculator.edit.riskInPoints;
   riskInPointsEDIT.Create(0,"riskInPointsEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(riskInPointsEDIT);
   riskInPointsEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(170));
   riskInPointsEDIT.ReadOnly(true);
   riskInPointsEDIT.ColorBackground(clrWhiteSmoke);
   riskInPointsEDIT.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Currency
   //-------------------------
   //Label 
   CLabel *riskInCurrencyLABEL = gui.positionSizeCalculator.label.riskInCurrency;
   riskInCurrencyLABEL.Create(0,"riskInCurrencyLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(riskInCurrencyLABEL);
   riskInCurrencyLABEL.Text("Risk in " + AccountCurrency());
   riskInCurrencyLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(200));
   riskInCurrencyLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit box
   CEdit *riskInCurrencyEDIT = gui.positionSizeCalculator.edit.riskInCurrency;
   riskInCurrencyEDIT.Create(0,"riskInCurrencyEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(riskInCurrencyEDIT);
   riskInCurrencyEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(200));
   riskInCurrencyEDIT.ReadOnly(true);
   riskInCurrencyEDIT.ColorBackground(clrWhiteSmoke);
   riskInCurrencyEDIT.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Contract_Size
   //-------------------------
   //Label
   CLabel *contractSizeLABEL = gui.positionSizeCalculator.label.contractSize;
   contractSizeLABEL.Create(0,"contractSizeLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(contractSizeLABEL);
   contractSizeLABEL.Text("Contract Size");
   contractSizeLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(230));
   contractSizeLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit 
   CEdit *contractSizeEDIT = gui.positionSizeCalculator.edit.contractSize;
   contractSizeEDIT.Create(0,"contractSizeEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));       
   window.Add(contractSizeEDIT);
   contractSizeEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(230));
   contractSizeEDIT.ReadOnly(true);
   contractSizeEDIT.ColorBackground(clrGainsboro);
   contractSizeEDIT.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total_Units
   //-------------------------
   //Label
   CLabel *totalUnitsLABEL = gui.positionSizeCalculator.label.totalUnits;
   totalUnitsLABEL.Create(0,"totalUnitsLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(totalUnitsLABEL);
   totalUnitsLABEL.Text("Total Units");
   totalUnitsLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(260));
   totalUnitsLABEL.FontSize(gui.GetMainFont_S());
   
   //Edit 
   CEdit *totalUnitsEDIT = gui.positionSizeCalculator.edit.totalUnits;
   totalUnitsEDIT.Create(0,"totalUnitsEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(totalUnitsEDIT);
   totalUnitsEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(260));
   totalUnitsEDIT.ReadOnly(true);
   totalUnitsEDIT.ColorBackground(clrWhiteSmoke);
   totalUnitsEDIT.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label
   CLabel *totalLots_LABEL = gui.positionSizeCalculator.label.totalLots;
   totalLots_LABEL.Create(0,"totalLots_LABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(totalLots_LABEL);
   totalLots_LABEL.Text("Total Lots");
   totalLots_LABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(290));
   totalLots_LABEL.FontSize(gui.GetMainFont_S());
   
   //Edit 
   CEdit *totalLots_EDIT = gui.positionSizeCalculator.edit.totalLots;
   totalLots_EDIT.Create(0,"totalLots_EDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(totalLots_EDIT);
   totalLots_EDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(290));
   totalLots_EDIT.ReadOnly(true);
   totalLots_EDIT.ColorBackground(clrGold);
   totalLots_EDIT.FontSize(gui.GetMainFont_S());
   
   //-------------------------
   //Total PositionValue 
   //-------------------------
   //label
   CLabel *positionValueLABEL = gui.positionSizeCalculator.label.positionValue;
   positionValueLABEL.Create(0,"positionValueLABEL",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(positionValueLABEL);
   positionValueLABEL.Text(AccountCurrency()+" Exposure");
   positionValueLABEL.Shift(gui.ScaledPixel(5),gui.ScaledPixel(320));
   positionValueLABEL.FontSize(gui.GetMainFont_S());
   
   //edit
   CEdit *positionValueEDIT = gui.positionSizeCalculator.edit.positionValue;
   positionValueEDIT.Create(0,"positionValueEDIT",0,0,0,gui.ScaledPixel(105),gui.ScaledPixel(25));
   window.Add(positionValueEDIT);
   positionValueEDIT.Shift(gui.ScaledPixel(255),gui.ScaledPixel(320));
   positionValueEDIT.ReadOnly(true);
   positionValueEDIT.ColorBackground(clrWhiteSmoke);
   positionValueEDIT.FontSize(gui.GetMainFont_S()); 
}



