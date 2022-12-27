//+------------------------------------------------------------------+
//|                                                  RiskManager.mq4 |
//|                       Copyright 2022, MrPragmatic Software Corp. |
//|                                 https://github.com/mrPragmatic07 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MrPragmatic Software Corp."
#property link      "https://github.com/mrPragmatic07"
#property version   "1.00"
#property strict
#property show_inputs

//+------------------------------------------------------------------+
//| Include Event Handlers Classes                                   |
//+------------------------------------------------------------------+
#include "controller\chart_event\COnChartEvent.mqh"
#include "controller\deinit\COnDeinit.mqh"
#include "controller\init\COnInit.mqh"
#include "controller\tick\COnTick.mqh"
#include "controller\timer\COnTimer.mqh"

//+------------------------------------------------------------------+
//| Include App Functionality Components                             |
//+------------------------------------------------------------------+
#include "model\CIndivialTradeExposure.mqh"
#include "model\CPositionSizeCalculator.mqh"
#include "model\CRiskSettings.mqh"
#include "model\CSumTradesExposure.mqh"

//+------------------------------------------------------------------+
//| Include MT4 Defined Resources                                    |
//+------------------------------------------------------------------+
#resource "\\Include\\Controls\\res\\CheckBoxOff.bmp"  
#resource "\\Include\\Controls\\res\\CheckBoxOn.bmp"
#resource "\\Include\\Controls\\res\\Up.bmp"  
#resource "\\Include\\Controls\\res\\Down.bmp"

//+------------------------------------------------------------------+
//| Declaring 'Model' Objects                                        |
//+------------------------------------------------------------------+
CPositionSizeCalculator positionSizeCalculator;
CRiskSettings           riskSettings;          
CSumTradesExposure      sumTradesExposure;  
CIndivialTradeExposure  indivialTradeExposure;
CGuiControl             guiControl;

//+------------------------------------------------------------------+
//| Input Variables                                                  |
//+------------------------------------------------------------------+
input  double SCALE = 1.0; //Scale    
extern Window FirstWindow = RiskExposure;

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
input  string LicenceKey;
double contractsize; 

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {

   // Initialise COnInit Object
   COnInit initialiser;
   
   //Licence Validation 
   if(!initialiser.licenceValidation(LicenceKey)) return(INIT_FAILED);
   
   //Manipulation of Global Variables
   contractsize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);
   
   //Create Main Window
   initialiser.createMainWindow(guiControl, SCALE);
   
   //****************************************************************
   //Create Position Size Calculator Window
   //****************************************************************
   //-------------------------
   //Button - guiControl.positionSizeCalculator.button.tabPSC  
   guiControl.positionSizeCalculator.button.tabPSC.Create(0,
                      "guiControl.positionSizeCalculator.button.tabPSC",
                      0,
                      guiControl.ScaledPixel(5),
                      guiControl.ScaledPixel(5),
                      guiControl.ScaledPixel(180),
                      guiControl.ScaledPixel(30));
                      
   guiControl.positionSizeCalculator.button.tabPSC.Text("Position Size Calculator");
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.button.tabPSC);
   guiControl.positionSizeCalculator.button.tabPSC.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Risk per trade
   //-------------------------
   //Label
   guiControl.positionSizeCalculator.label.riskPerTrade.Create(0,"guiControl.positionSizeCalculator.label.riskPerTrade",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));                         
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.label.riskPerTrade);
   guiControl.positionSizeCalculator.label.riskPerTrade.Text("Risk On Trade (% of Account Balance)");
   guiControl.positionSizeCalculator.label.riskPerTrade.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(45));
   guiControl.positionSizeCalculator.label.riskPerTrade.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   guiControl.positionSizeCalculator.edit.riskPerTrade.Create(0,"guiControl.positionSizeCalculator.edit.riskPerTrade",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));                
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.edit.riskPerTrade);
   guiControl.positionSizeCalculator.edit.riskPerTrade.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(45));
   guiControl.positionSizeCalculator.edit.riskPerTrade.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Entry Price
   //-------------------------
   //Label
   guiControl.positionSizeCalculator.label.entryPrice.Create(0,"guiControl.positionSizeCalculator.label.entryPrice",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));                   
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.label.entryPrice);
   guiControl.positionSizeCalculator.label.entryPrice.Text("Entry Price");
   guiControl.positionSizeCalculator.label.entryPrice.Shift(guiControl.ScaledPixel(5), guiControl.ScaledPixel(75));                  
   guiControl.positionSizeCalculator.label.entryPrice.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   guiControl.positionSizeCalculator.edit.entryPrice.Create(0,"guiControl.positionSizeCalculator.edit.entryPrice",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.edit.entryPrice);
   guiControl.positionSizeCalculator.edit.entryPrice.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(75));
   guiControl.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
   guiControl.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
   guiControl.positionSizeCalculator.edit.entryPrice.FontSize(guiControl.GetMainFont_S());
   
   //Button - Custom 
   guiControl.positionSizeCalculator.button.priceCustom.Create(0,"guiControl.positionSizeCalculator.button.priceCustom",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));        
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.button.priceCustom);
   guiControl.positionSizeCalculator.button.priceCustom.Shift(guiControl.ScaledPixel(80),guiControl.ScaledPixel(77));
   guiControl.positionSizeCalculator.button.priceCustom.Text("Custom");
   guiControl.positionSizeCalculator.button.priceCustom.FontSize(guiControl.GetsubFont_S());
   guiControl.positionSizeCalculator.button.priceCustom.ColorBackground(clrLightBlue);
   
   //Button - Bid 
   guiControl.positionSizeCalculator.button.priceBid.Create(0,"guiControl.positionSizeCalculator.button.priceBid",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.button.priceBid);
   guiControl.positionSizeCalculator.button.priceBid.Shift(guiControl.ScaledPixel(135),guiControl.ScaledPixel(77));
   guiControl.positionSizeCalculator.button.priceBid.Text("Bid");
   guiControl.positionSizeCalculator.button.priceBid.FontSize(guiControl.GetsubFont_S());
   guiControl.positionSizeCalculator.button.priceBid.ColorBackground(clrTomato);
   
   //Button - Ask
   guiControl.positionSizeCalculator.button.priceAsk.Create(0,"guiControl.positionSizeCalculator.button.priceAsk",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));  
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.button.priceAsk);
   guiControl.positionSizeCalculator.button.priceAsk.Shift(guiControl.ScaledPixel(190),guiControl.ScaledPixel(77));
   guiControl.positionSizeCalculator.button.priceAsk.Text("Ask");
   guiControl.positionSizeCalculator.button.priceAsk.FontSize(guiControl.GetsubFont_S());
   guiControl.positionSizeCalculator.button.priceAsk.ColorBackground(clrMediumSeaGreen);
   
   //-------------------------
   //Stop Loss
   //-------------------------
   //Label
   guiControl.positionSizeCalculator.label.stopLoss.Create(0,"guiControl.positionSizeCalculator.label.stopLoss",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));  
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.label.stopLoss);
   guiControl.positionSizeCalculator.label.stopLoss.Text("Stop Loss Price");
   guiControl.positionSizeCalculator.label.stopLoss.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(105));
   guiControl.positionSizeCalculator.label.stopLoss.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   guiControl.positionSizeCalculator.edit.stopLoss.Create(0,"guiControl.positionSizeCalculator.edit.stopLoss",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.edit.stopLoss);
   guiControl.positionSizeCalculator.edit.stopLoss.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(105));
   guiControl.positionSizeCalculator.edit.stopLoss.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Button - guiControl.positionSizeCalculator.button.calculate 
   //-------------------------
   guiControl.positionSizeCalculator.button.calculate.Create(0,"guiControl.positionSizeCalculator.button.calculate",0,0,0,guiControl.ScaledPixel(75),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.button.calculate);
   guiControl.positionSizeCalculator.button.calculate.Shift(guiControl.ScaledPixel(150),guiControl.ScaledPixel(135));
   guiControl.positionSizeCalculator.button.calculate.Text("Calculate");
   guiControl.positionSizeCalculator.button.calculate.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Points
   //-------------------------
   //Label 
   guiControl.positionSizeCalculator.label.riskInPoints.Create(0,"guiControl.positionSizeCalculator.label.riskInPoints",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.label.riskInPoints);
   guiControl.positionSizeCalculator.label.riskInPoints.Text("Risk in Points");
   guiControl.positionSizeCalculator.label.riskInPoints.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(170));
   guiControl.positionSizeCalculator.label.riskInPoints.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   guiControl.positionSizeCalculator.edit.riskInPoints.Create(0,"guiControl.positionSizeCalculator.edit.riskInPoints",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.edit.riskInPoints);
   guiControl.positionSizeCalculator.edit.riskInPoints.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(170));
   guiControl.positionSizeCalculator.edit.riskInPoints.ReadOnly(true);
   guiControl.positionSizeCalculator.edit.riskInPoints.ColorBackground(clrWhiteSmoke);
   guiControl.positionSizeCalculator.edit.riskInPoints.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Currency
   //-------------------------
   //Label 
   guiControl.positionSizeCalculator.label.riskInCurrency.Create(0,"guiControl.positionSizeCalculator.label.riskInCurrency",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.label.riskInCurrency);
   guiControl.positionSizeCalculator.label.riskInCurrency.Text("Risk in " + AccountCurrency());
   guiControl.positionSizeCalculator.label.riskInCurrency.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(200));
   guiControl.positionSizeCalculator.label.riskInCurrency.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   guiControl.positionSizeCalculator.edit.riskInCurrency.Create(0,"guiControl.positionSizeCalculator.edit.riskInCurrency",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.edit.riskInCurrency);
   guiControl.positionSizeCalculator.edit.riskInCurrency.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(200));
   guiControl.positionSizeCalculator.edit.riskInCurrency.ReadOnly(true);
   guiControl.positionSizeCalculator.edit.riskInCurrency.ColorBackground(clrWhiteSmoke);
   guiControl.positionSizeCalculator.edit.riskInCurrency.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Contract_Size
   //-------------------------
   //Label
   guiControl.positionSizeCalculator.label.contractSize.Create(0,"guiControl.positionSizeCalculator.label.contractSize",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.label.contractSize);
   guiControl.positionSizeCalculator.label.contractSize.Text("Contract Size");
   guiControl.positionSizeCalculator.label.contractSize.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(230));
   guiControl.positionSizeCalculator.label.contractSize.FontSize(guiControl.GetMainFont_S());
   
   //Edit 
   guiControl.positionSizeCalculator.edit.contractSize.Create(0,"guiControl.positionSizeCalculator.edit.contractSize",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));       
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.edit.contractSize);
   guiControl.positionSizeCalculator.edit.contractSize.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(230));
   guiControl.positionSizeCalculator.edit.contractSize.ReadOnly(true);
   guiControl.positionSizeCalculator.edit.contractSize.ColorBackground(clrGainsboro);
   guiControl.positionSizeCalculator.edit.contractSize.Text((string)contractsize);
   guiControl.positionSizeCalculator.edit.contractSize.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Total_Units
   //-------------------------
   //Label
   guiControl.positionSizeCalculator.label.totalUnits.Create(0,"guiControl.positionSizeCalculator.label.totalUnits",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.label.totalUnits);
   guiControl.positionSizeCalculator.label.totalUnits.Text("Total Units");
   guiControl.positionSizeCalculator.label.totalUnits.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(260));
   guiControl.positionSizeCalculator.label.totalUnits.FontSize(guiControl.GetMainFont_S());
   
   //Edit 
   guiControl.positionSizeCalculator.edit.totalUnits.Create(0,"guiControl.positionSizeCalculator.edit.totalUnits",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.edit.totalUnits);
   guiControl.positionSizeCalculator.edit.totalUnits.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(260));
   guiControl.positionSizeCalculator.edit.totalUnits.ReadOnly(true);
   guiControl.positionSizeCalculator.edit.totalUnits.ColorBackground(clrWhiteSmoke);
   guiControl.positionSizeCalculator.edit.totalUnits.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label
   guiControl.positionSizeCalculator.label.totalLots.Create(0,"guiControl.positionSizeCalculator.label.totalLots",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.label.totalLots);
   guiControl.positionSizeCalculator.label.totalLots.Text("Total Lots");
   guiControl.positionSizeCalculator.label.totalLots.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(290));
   guiControl.positionSizeCalculator.label.totalLots.FontSize(guiControl.GetMainFont_S());
   
   //Edit 
   guiControl.positionSizeCalculator.edit.totalLots.Create(0,"guiControl.positionSizeCalculator.edit.totalLots",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.edit.totalLots);
   guiControl.positionSizeCalculator.edit.totalLots.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(290));
   guiControl.positionSizeCalculator.edit.totalLots.ReadOnly(true);
   guiControl.positionSizeCalculator.edit.totalLots.ColorBackground(clrGold);
   guiControl.positionSizeCalculator.edit.totalLots.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Total PositionValue 
   //-------------------------
   //label
   guiControl.positionSizeCalculator.label.positionValue.Create(0,"guiControl.positionSizeCalculator.label.positionValue",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.label.positionValue);
   guiControl.positionSizeCalculator.label.positionValue.Text(AccountCurrency()+" Exposure");
   guiControl.positionSizeCalculator.label.positionValue.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(320));
   guiControl.positionSizeCalculator.label.positionValue.FontSize(guiControl.GetMainFont_S());
   
   //edit
   guiControl.positionSizeCalculator.edit.positionValue.Create(0,"guiControl.positionSizeCalculator.edit.positionValue",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.positionSizeCalculator.edit.positionValue);
   guiControl.positionSizeCalculator.edit.positionValue.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(320));
   guiControl.positionSizeCalculator.edit.positionValue.ReadOnly(true);
   guiControl.positionSizeCalculator.edit.positionValue.ColorBackground(clrWhiteSmoke);
   guiControl.positionSizeCalculator.edit.positionValue.FontSize(guiControl.GetMainFont_S());
   
   //****************************************************************
   //Create Risk Exposure Window
   //****************************************************************
   //-------------------------
   //Button - guiControl.riskExposure.button.tabRiskExposure
   //-------------------------
   guiControl.riskExposure.button.tabRiskExposure.Create(0,"guiControl.riskExposure.button.tabRiskExposure",0,0,0,guiControl.ScaledPixel(175),guiControl.ScaledPixel(25));
   guiControl.riskExposure.button.tabRiskExposure.Text("Risk Exposure");
   guiControl.riskExposure.button.tabRiskExposure.FontSize(guiControl.GetMainFont_S());
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.button.tabRiskExposure);
   guiControl.riskExposure.button.tabRiskExposure.Shift(guiControl.ScaledPixel(195),guiControl.ScaledPixel(5));
   
   //--------------------------------------------------------
   // Risk Settings
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label
   //-------------------------
   guiControl.riskExposure.label.maxInt.Create(0,"guiControl.riskExposure.label.maxInt",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.maxInt);
   guiControl.riskExposure.label.maxInt.Text("Risk Settings");
   guiControl.riskExposure.label.maxInt.Shift(guiControl.ScaledPixel(145),guiControl.ScaledPixel(45));
   guiControl.riskExposure.label.maxInt.Color(clrMediumBlue);
   guiControl.riskExposure.label.maxInt.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //MAX Settings Trades
   //-------------------------
   //Label
   guiControl.riskExposure.label.maxTrades.Create(0,"guiControl.riskExposure.label.maxTrades",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.maxTrades);
   guiControl.riskExposure.label.maxTrades.Text("MAX # Trades");
   guiControl.riskExposure.label.maxTrades.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(72));
   guiControl.riskExposure.label.maxTrades.FontSize(guiControl.GetMainFont_S());
   
   //edit
   guiControl.riskExposure.edit.maxTrades.Create(0,"guiControl.riskExposure.edit.maxTrades",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.maxTrades);
   guiControl.riskExposure.edit.maxTrades.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(70));
   guiControl.riskExposure.edit.maxTrades.ReadOnly(true);
   guiControl.riskExposure.edit.maxTrades.ColorBackground(clrWhiteSmoke);
   guiControl.riskExposure.edit.maxTrades.FontSize(guiControl.GetMainFont_S());
   if (riskSettings.GetMaxTrades() != -1) guiControl.riskExposure.edit.maxTrades.Text((string)riskSettings.GetMaxTrades());
   
   //bmp
   guiControl.riskExposure.bmpButton.maxTrades.Create(0,"guiControl.riskExposure.bmpButton.maxTrades",0,0,0,0,0);
   guiControl.riskExposure.bmpButton.maxTrades.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                              "::Include\\Controls\\res\\CheckBoxOn.bmp");
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.bmpButton.maxTrades); 
   guiControl.riskExposure.bmpButton.maxTrades.Shift(guiControl.ScaledPixel(230),guiControl.ScaledPixel(75));
   
   //-------------------------
   //MAX Settings Lots
   //-------------------------
   //Label
   guiControl.riskExposure.label.maxLots.Create(0,"guiControl.riskExposure.label.maxLots",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.maxLots);
   guiControl.riskExposure.label.maxLots.Text("MAX Lots");
   guiControl.riskExposure.label.maxLots.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(102));
   guiControl.riskExposure.label.maxLots.FontSize(guiControl.GetMainFont_S());
   
   //edit
   guiControl.riskExposure.edit.maxLots.Create(0,"guiControl.riskExposure.edit.maxLots",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.maxLots);
   guiControl.riskExposure.edit.maxLots.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(100));
   guiControl.riskExposure.edit.maxLots.ReadOnly(true);
   guiControl.riskExposure.edit.maxLots.ColorBackground(clrWhiteSmoke);
   guiControl.riskExposure.edit.maxLots.FontSize(guiControl.GetMainFont_S());
   if (riskSettings.GetMaxLots() != -1) guiControl.riskExposure.edit.maxLots.Text((string)riskSettings.GetMaxLots());
   
   //bmp
   guiControl.riskExposure.bmpButton.maxLots.Create(0,"guiControl.riskExposure.bmpButton.maxLots",0,0,0,0,0);
   guiControl.riskExposure.bmpButton.maxLots.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                            "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.bmpButton.maxLots); 
   guiControl.riskExposure.bmpButton.maxLots.Shift(guiControl.ScaledPixel(230),guiControl.ScaledPixel(105));
   
   //-------------------------
   //MAX Settings Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Risk Settings
   //Account percentage
   guiControl.riskExposure.button.percentageRiskSettings.Create(0,"guiControl.riskExposure.button.percentageRiskSettings",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.button.percentageRiskSettings);
   guiControl.riskExposure.button.percentageRiskSettings.Shift(guiControl.ScaledPixel(125),guiControl.ScaledPixel(135));
   guiControl.riskExposure.button.percentageRiskSettings.Text("Acc%");
   guiControl.riskExposure.button.percentageRiskSettings.FontSize(guiControl.GetsubFont_S());
   //Currency 
   guiControl.riskExposure.button.currencyRiskSettings.Create(0,"guiControl.riskExposure.button.currencyRiskSettings",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.button.currencyRiskSettings);
   guiControl.riskExposure.button.currencyRiskSettings.Shift(guiControl.ScaledPixel(175),guiControl.ScaledPixel(135));
   guiControl.riskExposure.button.currencyRiskSettings.Text(AccountCurrency());
   guiControl.riskExposure.button.currencyRiskSettings.FontSize(guiControl.GetsubFont_S());
   //Button Clr OnInit
   if(guiControl.riskExposure.RS ==1) {
      guiControl.riskExposure.button.percentageRiskSettings.ColorBackground(clrLightBlue);
      guiControl.riskExposure.button.currencyRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(guiControl.riskExposure.RS==2){
      guiControl.riskExposure.button.percentageRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
      guiControl.riskExposure.button.currencyRiskSettings.ColorBackground(clrLightBlue);
   }
   
   //Label
   guiControl.riskExposure.label.maxExposure.Create(0,"guiControl.riskExposure.label.maxExposure",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.maxExposure);
   guiControl.riskExposure.label.maxExposure.Text("MAX Risk");
   guiControl.riskExposure.label.maxExposure.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(132));
   guiControl.riskExposure.label.maxExposure.FontSize(guiControl.GetMainFont_S());
   
   //edit Currency
   guiControl.riskExposure.edit.maxExposure.Create(0,"guiControl.riskExposure.edit.maxExposure",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.maxExposure);
   guiControl.riskExposure.edit.maxExposure.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(130));
   guiControl.riskExposure.edit.maxExposure.ReadOnly(true);
   guiControl.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);
   if(guiControl.riskExposure.RS ==1) {
      if (riskSettings.GetMaxExpPer() != -1) 
         guiControl.riskExposure.edit.maxExposure.Text(DoubleToString(riskSettings.GetMaxExpPer(),2) + " %");
   }   
   if(guiControl.riskExposure.RS==2){
      if (riskSettings.GetMaxExpCur() != -1) 
         guiControl.riskExposure.edit.maxExposure.Text(DoubleToString(riskSettings.GetMaxExpCur(),2) + " "+AccountCurrency());
   }
   guiControl.riskExposure.edit.maxExposure.FontSize(guiControl.GetMainFont_S());
   //bmp
   guiControl.riskExposure.bmpButton.maxExposure.Create(0,"guiControl.riskExposure.bmpButton.maxExposure",0,0,0,0,0);
   guiControl.riskExposure.bmpButton.maxExposure.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.bmpButton.maxExposure); 
   guiControl.riskExposure.bmpButton.maxExposure.Shift(guiControl.ScaledPixel(230),guiControl.ScaledPixel(135));
   
   //-------------------------
   //Max Currency Value of PositionSize
   //-------------------------
   //Label
   guiControl.riskExposure.label.maxPositionValue.Create(0,"guiControl.riskExposure.label.maxPositionValue",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.maxPositionValue);
   guiControl.riskExposure.label.maxPositionValue.Text("MAX " + AccountCurrency() + " Exposure");
   guiControl.riskExposure.label.maxPositionValue.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(162));
   guiControl.riskExposure.label.maxPositionValue.FontSize(guiControl.GetMainFont_S());
   
   //bmp
   guiControl.riskExposure.bmpButton.maxPositionValue.Create(0,"guiControl.riskExposure.bmpButton.maxPositionValue",0,0,0,0,0);
   guiControl.riskExposure.bmpButton.maxPositionValue.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                   "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.bmpButton.maxPositionValue); 
   guiControl.riskExposure.bmpButton.maxPositionValue.Shift(guiControl.ScaledPixel(230),guiControl.ScaledPixel(165));
   
   //edit
   guiControl.riskExposure.edit.maxPositionValue.Create(0,"guiControl.riskExposure.edit.maxPositionValue",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.maxPositionValue);
   guiControl.riskExposure.edit.maxPositionValue.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(160));
   guiControl.riskExposure.edit.maxPositionValue.ReadOnly(true);
   guiControl.riskExposure.edit.maxPositionValue.ColorBackground(clrWhiteSmoke);
   guiControl.riskExposure.edit.maxPositionValue.FontSize(guiControl.GetMainFont_S());
   if (riskSettings.GetMaxPosVal() != -1) guiControl.riskExposure.edit.maxPositionValue.Text((string)riskSettings.GetMaxPosVal() + " "+AccountCurrency());
   
   //--------------------------------------------------------
   // Total Exposure
   //--------------------------------------------------------
  
   //-------------------------
   //Introduction Label
   //-------------------------
   guiControl.riskExposure.label.totalExposure_int.Create(0,"guiControl.riskExposure.label.totalExposure_int",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.riskExposure.label.totalExposure_int.Text("Total Exposure");
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.totalExposure_int);
   guiControl.riskExposure.label.totalExposure_int.Shift(guiControl.ScaledPixel(140),guiControl.ScaledPixel(188));
   guiControl.riskExposure.label.totalExposure_int.Color(clrMediumBlue);
   guiControl.riskExposure.label.totalExposure_int.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Total_Trades
   //-------------------------
   //Label - guiControl.riskExposure.label.totalTrades 
   guiControl.riskExposure.label.totalTrades.Create(0,"guiControl.riskExposure.label.totalTrades",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.totalTrades);
   guiControl.riskExposure.label.totalTrades.Text("Total Trades");
   guiControl.riskExposure.label.totalTrades.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(212));
   guiControl.riskExposure.label.totalTrades.FontSize(guiControl.GetMainFont_S());
   
   //Edit - guiControl.riskExposure.edit.totalTrades 
   guiControl.riskExposure.edit.totalTrades.Create(0,"guiControl.riskExposure.edit.totalTrades",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.totalTrades);
   guiControl.riskExposure.edit.totalTrades.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(210));
   guiControl.riskExposure.edit.totalTrades.ReadOnly(true);
   guiControl.riskExposure.edit.totalTrades.FontSize(guiControl.GetMainFont_S());
   
   if (sumTradesExposure.GetTotalTrades() > riskSettings.GetMaxTrades() && 
       riskSettings.GetMaxTrades() != -1) {
      guiControl.riskExposure.edit.totalTrades.ColorBackground(clrTomato);
   }
   else guiControl.riskExposure.edit.totalTrades.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label - guiControl.riskExposure.label.totalLots 
   guiControl.riskExposure.label.totalLots.Create(0,"guiControl.riskExposure.label.totalLots",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.totalLots);
   guiControl.riskExposure.label.totalLots.Text("Total Lots");
   guiControl.riskExposure.label.totalLots.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(242));
   guiControl.riskExposure.label.totalLots.FontSize(guiControl.GetMainFont_S());
   
   //Edit - guiControl.riskExposure.edit.totalLots 
   guiControl.riskExposure.edit.totalLots.Create(0,"guiControl.riskExposure.edit.totalLots",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.totalLots);
   guiControl.riskExposure.edit.totalLots.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(240));
   guiControl.riskExposure.edit.totalLots.ReadOnly(true);
   guiControl.riskExposure.edit.totalLots.FontSize(guiControl.GetMainFont_S());
   
   if (sumTradesExposure.GetTotalLots() > riskSettings.GetMaxLots() && 
       riskSettings.GetMaxLots() != -1) {
      guiControl.riskExposure.edit.totalLots.ColorBackground(clrTomato);
   }
   else guiControl.riskExposure.edit.totalLots.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total Exp Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Total Exposure
   //Account percentage
   guiControl.riskExposure.button.percentageTotalExposure.Create(0,"guiControl.riskExposure.button.percentageTotalExposure",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.button.percentageTotalExposure);
   guiControl.riskExposure.button.percentageTotalExposure.Shift(guiControl.ScaledPixel(125),guiControl.ScaledPixel(275));
   guiControl.riskExposure.button.percentageTotalExposure.Text("Acc%");
   guiControl.riskExposure.button.percentageTotalExposure.FontSize(guiControl.GetsubFont_S());
   //guiControl.riskExposure.button.percentageTotalExposure.ColorBackground(clrLightBlue);
   //Currency 
   guiControl.riskExposure.button.currencyTotalExposure.Create(0,"guiControl.riskExposure.button.currencyTotalExposure",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.button.currencyTotalExposure);
   guiControl.riskExposure.button.currencyTotalExposure.Shift(guiControl.ScaledPixel(175),guiControl.ScaledPixel(275));
   guiControl.riskExposure.button.currencyTotalExposure.Text(AccountCurrency());
   guiControl.riskExposure.button.currencyTotalExposure.FontSize(guiControl.GetsubFont_S());
   //guiControl.riskExposure.button.currencyTotalExposure.ColorBackground(clrLightBlue);
   //Button Clr OnInit
   if(guiControl.riskExposure.TE ==1) {
      guiControl.riskExposure.button.percentageTotalExposure.ColorBackground(clrLightBlue);
      guiControl.riskExposure.button.currencyTotalExposure.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(guiControl.riskExposure.TE==2) {
      guiControl.riskExposure.button.percentageTotalExposure.ColorBackground(C'0xF0,0xF0,0xF0');
      guiControl.riskExposure.button.currencyTotalExposure.ColorBackground(clrLightBlue);
   }
   
   //Label - guiControl.riskExposure.label.totalExposure 
   guiControl.riskExposure.label.totalExposure.Create(0,"guiControl.riskExposure.label.totalExposure",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.totalExposure);
   guiControl.riskExposure.label.totalExposure.Text("Total Risk");
   guiControl.riskExposure.label.totalExposure.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(272));
   guiControl.riskExposure.label.totalExposure.FontSize(guiControl.GetMainFont_S());
   
   //Edit - guiControl.riskExposure.edit.totalExposure 
   guiControl.riskExposure.edit.totalExposure.Create(0,"guiControl.riskExposure.edit.totalExposure",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.totalExposure);
   guiControl.riskExposure.edit.totalExposure.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(270));
   guiControl.riskExposure.edit.totalExposure.ReadOnly(true);
   guiControl.riskExposure.edit.totalExposure.FontSize(guiControl.GetMainFont_S());
   
   if(guiControl.riskExposure.TE == 1) {
      if ((sumTradesExposure.GetTotalExpAcc() > riskSettings.GetMaxExpPer() && 
          riskSettings.GetMaxExpPer() != -1) ||
          ((riskSettings.GetMaxExpPer() != -1) && (sumTradesExposure.GetTotalExpAcc() == -10))) {
         guiControl.riskExposure.edit.totalExposure.ColorBackground(clrTomato);
      }
      else guiControl.riskExposure.edit.totalExposure.ColorBackground(clrWhiteSmoke);
   }
   
   if(guiControl.riskExposure.TE == 2) {
      if ((sumTradesExposure.GetTotalExpCur() > riskSettings.GetMaxExpCur() && 
          riskSettings.GetMaxExpCur() != -1) ||
          ((riskSettings.GetMaxExpCur() != -1) && (sumTradesExposure.GetTotalExpAcc() == -10))) {
         guiControl.riskExposure.edit.totalExposure.ColorBackground(clrTomato);
      }
      else guiControl.riskExposure.edit.totalExposure.ColorBackground(clrWhiteSmoke);
   }
   
   //-------------------------
   //Total Currency Value of PositionSize
   //-------------------------
   //Label - guiControl.riskExposure.label.totalPositionValue
   guiControl.riskExposure.label.totalPositionValue.Create(0,"guiControl.riskExposure.label.totalPositionValue",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.totalPositionValue);
   guiControl.riskExposure.label.totalPositionValue.Text("Total " + AccountCurrency() + " Exposure");
   guiControl.riskExposure.label.totalPositionValue.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(302));
   guiControl.riskExposure.label.totalPositionValue.FontSize(guiControl.GetMainFont_S());
   
   //Edit - guiControl.riskExposure.edit.totalPositionValue
   guiControl.riskExposure.edit.totalPositionValue.Create(0,"guiControl.riskExposure.edit.totalPositionValue",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.totalPositionValue);
   guiControl.riskExposure.edit.totalPositionValue.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(300));
   guiControl.riskExposure.edit.totalPositionValue.ReadOnly(true);
   guiControl.riskExposure.edit.totalPositionValue.FontSize(guiControl.GetMainFont_S());
   
   if (sumTradesExposure.GetTotalPosVal() > riskSettings.GetMaxPosVal() && 
       riskSettings.GetMaxPosVal() != -1) {
      guiControl.riskExposure.edit.totalPositionValue.ColorBackground(clrTomato);
   }
   else guiControl.riskExposure.edit.totalPositionValue.ColorBackground(clrWhiteSmoke);
   
   //--------------------------------------------------------
   // Individual Trade Exposure
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label 
   //-------------------------
   guiControl.riskExposure.label.tradeSelect_int.Create(0,"guiControl.riskExposure.label.tradeSelect_int",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.tradeSelect_int);
   guiControl.riskExposure.label.tradeSelect_int.Text("Individual Trade Exposure");
   guiControl.riskExposure.label.tradeSelect_int.Shift(guiControl.ScaledPixel(100),guiControl.ScaledPixel(340));
   guiControl.riskExposure.label.tradeSelect_int.Color(clrMediumBlue);
   guiControl.riskExposure.label.tradeSelect_int.FontSize(guiControl.GetMainFont_S());

   //-------------------------
   //Choose Trade
   //-------------------------
   //Label guiControl.riskExposure.label.tradeSelect
   guiControl.riskExposure.label.tradeSelect.Create(0,"guiControl.riskExposure.label.tradeSelect",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.tradeSelect);
   guiControl.riskExposure.label.tradeSelect.Text("Select Trade");
   guiControl.riskExposure.label.tradeSelect.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(372));
   guiControl.riskExposure.label.tradeSelect.FontSize(guiControl.GetMainFont_S());
   
   //ComboBox - guiControl.riskExposure.comboBox.tradeExposure
   guiControl.riskExposure.comboBox.tradeExposure.Create(0,"guiControl.riskExposure.comboBox.tradeExposure",0,0,0,guiControl.ScaledPixel(145),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.comboBox.tradeExposure);
   guiControl.riskExposure.comboBox.tradeExposure.Shift(guiControl.ScaledPixel(215),guiControl.ScaledPixel(370));
   //Add trades to CB
   indivialTradeExposure.AddToCB_Singular_Trades(guiControl);
   
   //-------------------------
   //Singular Trade EXP in Currency or Account%
   //-------------------------
   //Label guiControl.riskExposure.label.tradeSelect
   guiControl.riskExposure.label.tradeExposure.Create(0,"guiControl.riskExposure.label.tradeExposure",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.tradeExposure);
   guiControl.riskExposure.label.tradeExposure.Text("Trade Risk");
   guiControl.riskExposure.label.tradeExposure.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(402));
   guiControl.riskExposure.label.tradeExposure.FontSize(guiControl.GetMainFont_S());
   
   //Edit guiControl.riskExposure.edit.tradeExposure
   guiControl.riskExposure.edit.tradeExposure.Create(0,"guiControl.riskExposure.edit.tradeExposure",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.tradeExposure);
   guiControl.riskExposure.edit.tradeExposure.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(400));
   guiControl.riskExposure.edit.tradeExposure.ReadOnly(true);
   guiControl.riskExposure.edit.tradeExposure.ColorBackground(clrWhiteSmoke);
   guiControl.riskExposure.edit.tradeExposure.FontSize(guiControl.GetMainFont_S());
   
   //Edit guiControl.riskExposure.edit.tradePositionValue
   guiControl.riskExposure.edit.tradePositionValue.Create(0,"guiControl.riskExposure.edit.tradePositionValue",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.edit.tradePositionValue);
   guiControl.riskExposure.edit.tradePositionValue.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(430));
   guiControl.riskExposure.edit.tradePositionValue.ReadOnly(true);
   guiControl.riskExposure.edit.tradePositionValue.ColorBackground(clrWhiteSmoke);
   guiControl.riskExposure.edit.tradePositionValue.FontSize(guiControl.GetMainFont_S());
   
   //Choose Currency or Account Percentage for Individual Trade Exposure
   //Currency 
   guiControl.riskExposure.button.currencyIndivualTradeExposure.Create(0,"guiControl.riskExposure.button.currencyIndivualTradeExposure",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.button.currencyIndivualTradeExposure);
   guiControl.riskExposure.button.currencyIndivualTradeExposure.Shift(guiControl.ScaledPixel(175),guiControl.ScaledPixel(405));
   guiControl.riskExposure.button.currencyIndivualTradeExposure.Text(AccountCurrency());
   guiControl.riskExposure.button.currencyIndivualTradeExposure.FontSize(guiControl.GetsubFont_S());
   //Account percentage
   guiControl.riskExposure.button.percentageIndivualTradeExposure.Create(0,"guiControl.riskExposure.button.percentageIndivualTradeExposure",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.button.percentageIndivualTradeExposure);
   guiControl.riskExposure.button.percentageIndivualTradeExposure.Shift(guiControl.ScaledPixel(125),guiControl.ScaledPixel(405));
   guiControl.riskExposure.button.percentageIndivualTradeExposure.Text("Acc%");
   guiControl.riskExposure.button.percentageIndivualTradeExposure.FontSize(guiControl.GetsubFont_S());
   //Button Clr OnInit
   if(guiControl.riskExposure.ITE ==1) {
      guiControl.riskExposure.button.percentageIndivualTradeExposure.ColorBackground(clrLightBlue);
      guiControl.riskExposure.button.currencyIndivualTradeExposure.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(guiControl.riskExposure.ITE ==2) {
      guiControl.riskExposure.button.percentageIndivualTradeExposure.ColorBackground(C'0xF0,0xF0,0xF0');
      guiControl.riskExposure.button.currencyIndivualTradeExposure.ColorBackground(clrLightBlue);
   }
   
   //-------------------------
   //Singular Currency Value of PositionSize
   //-------------------------
   //Label guiControl.riskExposure.label.tradePositionValue
   guiControl.riskExposure.label.tradePositionValue.Create(0,"guiControl.riskExposure.label.tradePositionValue",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   guiControl.mainWindow.windowDialog.Add(guiControl.riskExposure.label.tradePositionValue);
   guiControl.riskExposure.label.tradePositionValue.Text(AccountCurrency() + " Exposure");
   guiControl.riskExposure.label.tradePositionValue.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(432));
   guiControl.riskExposure.label.tradePositionValue.FontSize(guiControl.GetMainFont_S());
   
   //****************************************************************
   //Set 1st Window
   //****************************************************************
   if (guiControl.GetCopyFirstWindow() == -1 || guiControl.GetCopyScale() != SCALE){
   
      //PositionSizeCalculator
      if(FirstWindow == PositionSizeCalculator) {

         guiControl.SetOPEN_TAB(1);
         guiControl.riskExposure.hide(); 
         guiControl.positionSizeCalculator.show(); 
         guiControl.mainWindow.windowDialog.Height(guiControl.positionSizeCalculator.height); 
         guiControl.mainWindow.copyRightsLabel.Shift(guiControl.ScaledPixel(5),guiControl.positionSizeCalculator.height-guiControl.ScaledPixel(50));
      }
      
      //RiskExposure
      if(FirstWindow == RiskExposure) {
      
         guiControl.SetOPEN_TAB(2); 
         guiControl.positionSizeCalculator.hide();
         guiControl.riskExposure.show(); 
         guiControl.mainWindow.windowDialog.Height(guiControl.riskExposure.height);
         guiControl.mainWindow.copyRightsLabel.Shift(guiControl.ScaledPixel(5),guiControl.riskExposure.height-guiControl.ScaledPixel(50));
      }   
      
      //Minimised
      if (FirstWindow == Minimised) {
         
         guiControl.mainWindow.minMaxBmpButton.Pressed(true);
         guiControl.WindowMin();
         if (guiControl.GetOPEN_TAB() == 2) guiControl.mainWindow.copyRightsLabel.Shift(guiControl.ScaledPixel(5),guiControl.riskExposure.height-guiControl.ScaledPixel(50));
         else guiControl.mainWindow.copyRightsLabel.Shift(guiControl.ScaledPixel(5),guiControl.positionSizeCalculator.height-guiControl.ScaledPixel(50));
      }
   }
   
   else {
   
      //PositionSizeCalculator
      if(guiControl.GetCopyFirstWindow() == PositionSizeCalculator) {

         guiControl.SetOPEN_TAB(1);
         guiControl.riskExposure.hide();
         guiControl.positionSizeCalculator.show();
         guiControl.mainWindow.windowDialog.Height(guiControl.positionSizeCalculator.height);
         guiControl.mainWindow.copyRightsLabel.Shift(guiControl.ScaledPixel(5),guiControl.positionSizeCalculator.height-guiControl.ScaledPixel(50));
      }
      
      //RiskExposure
      if(guiControl.GetCopyFirstWindow() == RiskExposure) {
      
         guiControl.SetOPEN_TAB(2);
         guiControl.positionSizeCalculator.hide();
         guiControl.riskExposure.show();
         guiControl.mainWindow.windowDialog.Height(guiControl.riskExposure.height);
         guiControl.mainWindow.copyRightsLabel.Shift(guiControl.ScaledPixel(5),guiControl.riskExposure.height-guiControl.ScaledPixel(50));
      }   
      
      //Minimised
      if (guiControl.GetCopyFirstWindow() == Minimised) {
         
         guiControl.mainWindow.minMaxBmpButton.Pressed(true);
         guiControl.WindowMin();
         if (guiControl.GetOPEN_TAB() == 2) guiControl.mainWindow.copyRightsLabel.Shift(5,guiControl.riskExposure.height-50);
         else guiControl.mainWindow.copyRightsLabel.Shift(guiControl.ScaledPixel(5),guiControl.positionSizeCalculator.height-guiControl.ScaledPixel(50));
      }
   }
   
   //****************************************************************
   //Run Everything on Main Window
   //****************************************************************
   guiControl.mainWindow.windowDialog.Run();
   
//--- create timer
   EventSetTimer(1);
   guiControl.SetCopyScale(SCALE);
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert Timer function                                            |
//+------------------------------------------------------------------+
void OnTimer() {

   //..................................................
   //Track Inputs set by the user On Risk and Exposure
   //..................................................
   
   //Number of Trades   
   if (sumTradesExposure.GetTotalTrades() > riskSettings.GetMaxTrades() && 
       riskSettings.GetMaxTrades() != -1) {
      guiControl.riskExposure.edit.totalTrades.ColorBackground(clrTomato);
   }
   else guiControl.riskExposure.edit.totalTrades.ColorBackground(clrWhiteSmoke);
   
   //Number of Lots
   if (sumTradesExposure.GetTotalLots() > riskSettings.GetMaxLots() && 
       riskSettings.GetMaxLots() != -1) {
      guiControl.riskExposure.edit.totalLots.ColorBackground(clrTomato);
   }
   else guiControl.riskExposure.edit.totalLots.ColorBackground(clrWhiteSmoke);
   
   //Exposure in Currency or Account %
   if(guiControl.riskExposure.TE ==1) {
      if ((sumTradesExposure.GetTotalExpAcc() > riskSettings.GetMaxExpPer() && 
          riskSettings.GetMaxExpPer() != -1) ||
          ((riskSettings.GetMaxExpPer() != -1) && (sumTradesExposure.GetTotalExpAcc() == -10))) {
         guiControl.riskExposure.edit.totalExposure.ColorBackground(clrTomato);
      }
      else guiControl.riskExposure.edit.totalExposure.ColorBackground(clrWhiteSmoke);
   }
   
   if(guiControl.riskExposure.TE == 2) {
      if ((sumTradesExposure.GetTotalExpCur() > riskSettings.GetMaxExpCur() && 
          riskSettings.GetMaxExpCur() != -1) ||
          ((riskSettings.GetMaxExpCur() != -1) && (sumTradesExposure.GetTotalExpAcc() == -10))) {
         guiControl.riskExposure.edit.totalExposure.ColorBackground(clrTomato);
      }
      else guiControl.riskExposure.edit.totalExposure.ColorBackground(clrWhiteSmoke);
   }
   //Exposure in Position Size
   if (sumTradesExposure.GetTotalPosVal() > riskSettings.GetMaxPosVal() && 
       riskSettings.GetMaxPosVal() != -1) {
      guiControl.riskExposure.edit.totalPositionValue.ColorBackground(clrTomato);
   }
   else guiControl.riskExposure.edit.totalPositionValue.ColorBackground(clrWhiteSmoke);
   
   //..................................................
   //Calculate total trades 
   //..................................................
   sumTradesExposure.SetTotalTrades(OrdersTotal());
   guiControl.riskExposure.edit.totalTrades.Text((string)sumTradesExposure.GetTotalTrades());
   
   //..................................................
   //Calculate total Lots 
   //..................................................
   double Total_lots = 0.0;
   
   //Get Total Lots
   for(int i=0; i < OrdersTotal(); i++) {
      
      if(OrderSelect(i, SELECT_BY_POS))
         Total_lots += OrderLots();
   }
   
   sumTradesExposure.SetTotalLots(Total_lots);
   guiControl.riskExposure.edit.totalLots.Text(DoubleToStr(sumTradesExposure.GetTotalLots(),2));
   
   //..................................................
   //Calculate Risk in Currency or Account Percentage 
   //..................................................
   sumTradesExposure.TotalExpAccAndCurr(guiControl);
   
   //..................................................
   //Calculate Position Size value  
   //..................................................
   sumTradesExposure.Total_PosVal(guiControl);
   
   //..................................................
   //Add Trades To combo Box  
   //..................................................
   if(sumTradesExposure.IsNewTrade()) { 
         
      guiControl.riskExposure.comboBox.tradeExposure.ItemsClear();
      guiControl.riskExposure.edit.tradeExposure.Text("");
      guiControl.riskExposure.edit.tradePositionValue.Text("");
                 
      indivialTradeExposure.AddToCB_Singular_Trades(guiControl);
   }
   
   //..................................................
   //Update values of Singular Trade 
   //..................................................
   //guiControl.riskExposure.comboBox.tradeExposure.SelectByText()
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

   if (positionSizeCalculator.track_BidAsk(guiControl) == 2) {
      guiControl.positionSizeCalculator.edit.entryPrice.Text((string)Bid);
      guiControl.positionSizeCalculator.edit.entryPrice.Color(clrTomato);
      guiControl.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
      guiControl.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
   }
   else if (positionSizeCalculator.track_BidAsk(guiControl) == 3) {
      guiControl.positionSizeCalculator.edit.entryPrice.Text((string)Ask);
      guiControl.positionSizeCalculator.edit.entryPrice.Color(clrMediumSeaGreen);
      guiControl.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
      guiControl.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
   }
   else if (positionSizeCalculator.track_BidAsk(guiControl) == 3) { //Calculate button has been pressed 
      guiControl.positionSizeCalculator.edit.entryPrice.Text(guiControl.positionSizeCalculator.edit.entryPrice.Text()); 
   }
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {
   
   //+---------------------------------------+
   //|Enable Controls of Main Window         |
   //+---------------------------------------+
   
   //*************************
   //Default
   //*************************
   guiControl.mainWindow.windowDialog.OnEvent(id,lparam,dparam,sparam);
   
   //Track OBJ Pressed
   if(id==CHARTEVENT_OBJECT_CLICK) guiControl.SetOBJ_CONTROL(ObjectGetString(0,sparam,OBJPROP_TEXT));
   
   //Mininmise Window
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Min_Max") {
   
      if(!guiControl.mainWindow.minMaxBmpButton.Pressed()) guiControl.WindowMax();
      else guiControl.WindowMin();
   }
   
   //+---------------------------------------+
   //|Risk Exposure                          |
   //+---------------------------------------+
   
   //************************************
   //guiControl.riskExposure.button.tabRiskExposure
   //************************************
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.button.tabRiskExposure") {
      if(!guiControl.riskExposure.label.totalTrades.IsVisible()) {
      
         //Hide positionSizeCalculator
         guiControl.positionSizeCalculator.hide(); 
         
         //Change the size of Window
         guiControl.mainWindow.windowDialog.Height(guiControl.riskExposure.height);
         guiControl.mainWindow.copyRightsLabel.Shift(0,guiControl.riskExposure.crShift);
         
         //Show Risk Exposure
         guiControl.riskExposure.show();
         guiControl.SetOPEN_TAB(guiControl.Check_Tab());
      }   
   } 
   
   //************************************
   //Risk Settings
   //************************************
   //.......................
   //MAX TRADES (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.bmpButton.maxTrades") {
      if(guiControl.riskExposure.bmpButton.maxTrades.Pressed()) {
      
         guiControl.riskExposure.edit.maxTrades.ReadOnly(false);
         guiControl.riskExposure.edit.maxTrades.ColorBackground(clrWhite);
      }
      else {
         guiControl.riskExposure.edit.maxTrades.ReadOnly(true);
         guiControl.riskExposure.edit.maxTrades.Text("");
         riskSettings.SetMaxTrades(-1);
         guiControl.riskExposure.edit.maxTrades.ColorBackground(clrWhiteSmoke);
      }  
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="guiControl.riskExposure.edit.maxTrades"){
      
      string text  = guiControl.riskExposure.edit.maxTrades.Text();
      double value = StrToDouble(text);
      
      if (value <= 0) {
         
         guiControl.riskExposure.edit.maxTrades.Text("");
         guiControl.riskExposure.edit.maxTrades.ColorBackground(clrWhiteSmoke);
         guiControl.riskExposure.edit.maxTrades.ReadOnly(true);
         guiControl.riskExposure.bmpButton.maxTrades.Pressed(false);
         riskSettings.SetMaxTrades(-1);
      } 
      else {
      
         riskSettings.SetMaxTrades(value);
         guiControl.riskExposure.edit.maxTrades.Text(DoubleToString(riskSettings.GetMaxTrades(),0));
      } 
      
      guiControl.riskExposure.bmpButton.maxTrades.Pressed(false);
      guiControl.riskExposure.edit.maxTrades.ReadOnly(true); 
      guiControl.riskExposure.edit.maxTrades.ColorBackground(clrWhiteSmoke); 
   }
   
   //.......................
   //MAX Lots (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.bmpButton.maxLots") {
      if(guiControl.riskExposure.bmpButton.maxLots.Pressed()) {
         guiControl.riskExposure.edit.maxLots.ReadOnly(false);
         guiControl.riskExposure.edit.maxLots.ColorBackground(clrWhite);
      }
      else {
         guiControl.riskExposure.edit.maxLots.ReadOnly(true);
         guiControl.riskExposure.edit.maxLots.Text("");
         riskSettings.SetMaxLots(-1);
         guiControl.riskExposure.edit.maxLots.ColorBackground(clrWhiteSmoke);
      }   
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="guiControl.riskExposure.edit.maxLots"){
      
      string text  = guiControl.riskExposure.edit.maxLots.Text();
      double value = StringToDouble(text);
      
      if (value <= 0) {
          
         guiControl.riskExposure.edit.maxLots.Text("");
         guiControl.riskExposure.edit.maxLots.ColorBackground(clrWhiteSmoke);
         guiControl.riskExposure.edit.maxLots.ReadOnly(true);
         guiControl.riskExposure.bmpButton.maxLots.Pressed(false);
         riskSettings.SetMaxLots(-1);
      }
      else {
      
         riskSettings.SetMaxLots(value);
         guiControl.riskExposure.edit.maxLots.Text(DoubleToString(riskSettings.GetMaxLots(),2));
      }
      
      guiControl.riskExposure.bmpButton.maxLots.Pressed(false);
      guiControl.riskExposure.edit.maxLots.ReadOnly(true); 
      guiControl.riskExposure.edit.maxLots.ColorBackground(clrWhiteSmoke);   
   }
   
   //.......................
   //MAX Currency Exposure (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.bmpButton.maxExposure") {
      if(guiControl.riskExposure.bmpButton.maxExposure.Pressed()) {
         guiControl.riskExposure.edit.maxExposure.ReadOnly(false);
         guiControl.riskExposure.edit.maxExposure.ColorBackground(clrWhite);
      }
      else {
         guiControl.riskExposure.edit.maxExposure.ReadOnly(true);
         guiControl.riskExposure.edit.maxExposure.Text("");
         riskSettings.SetMaxExpCur(-1);
         riskSettings.SetMaxExpPer(-1);
         guiControl.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);
      }   
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="guiControl.riskExposure.edit.maxExposure"){
      if(guiControl.riskExposure.RS==1){
      
         string text  = guiControl.riskExposure.edit.maxExposure.Text();
         double value = StrToDouble(text);
         
         if (value <= 0) {
             
            guiControl.riskExposure.edit.maxExposure.Text("");
            guiControl.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);
            guiControl.riskExposure.edit.maxExposure.ReadOnly(true);
            guiControl.riskExposure.bmpButton.maxExposure.Pressed(false);
            riskSettings.SetMaxExpCur(-1);
            riskSettings.SetMaxExpPer(-1);
         } 
         
         else{
         
            riskSettings.SetMaxExpPer(value);
            riskSettings.SetMaxExpCur((AccountBalance()* riskSettings.GetMaxExpPer())/100);
            guiControl.riskExposure.edit.maxExposure.Text(DoubleToStr(riskSettings.GetMaxExpPer(),2)+" %");  
         }
         
         guiControl.riskExposure.bmpButton.maxExposure.Pressed(false);
         guiControl.riskExposure.edit.maxExposure.ReadOnly(true); 
         guiControl.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke); 
      
      }
      
      else if(guiControl.riskExposure.RS==2){
            
         string text  = guiControl.riskExposure.edit.maxExposure.Text();
         double value = StrToDouble(text);
         
         if (value <= 0) {
             
            guiControl.riskExposure.edit.maxExposure.Text("");
            guiControl.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);
            guiControl.riskExposure.edit.maxExposure.ReadOnly(true);
            guiControl.riskExposure.bmpButton.maxExposure.Pressed(false);
            riskSettings.SetMaxExpCur(-1);
            riskSettings.SetMaxExpPer(-1);
         } 
         
         else{
            
            riskSettings.SetMaxExpCur(value);
            riskSettings.SetMaxExpPer((riskSettings.GetMaxExpCur()*100)/AccountBalance());
            guiControl.riskExposure.edit.maxExposure.Text(DoubleToStr(riskSettings.GetMaxExpCur(),2)+" "+AccountCurrency());
         }
         
         guiControl.riskExposure.bmpButton.maxExposure.Pressed(false);
         guiControl.riskExposure.edit.maxExposure.ReadOnly(true); 
         guiControl.riskExposure.edit.maxExposure.ColorBackground(clrWhiteSmoke);  
      }
   }
   //.......................
   //MAX Position Value (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.bmpButton.maxPositionValue") {
      if(guiControl.riskExposure.bmpButton.maxPositionValue.Pressed()) {
         guiControl.riskExposure.edit.maxPositionValue.ReadOnly(false);
         guiControl.riskExposure.edit.maxPositionValue.ColorBackground(clrWhite);
      }
      else {
         guiControl.riskExposure.edit.maxPositionValue.ReadOnly(true);
         guiControl.riskExposure.edit.maxPositionValue.Text("");
         riskSettings.SetMaxPosVal(-1);
         guiControl.riskExposure.edit.maxPositionValue.ColorBackground(clrWhiteSmoke);
      }   
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="guiControl.riskExposure.edit.maxPositionValue"){
      
      string text  = guiControl.riskExposure.edit.maxPositionValue.Text();
      double value = StrToDouble(text);
      
      if (value <= 0) {
          
         guiControl.riskExposure.edit.maxPositionValue.Text("");
         guiControl.riskExposure.edit.maxPositionValue.ColorBackground(clrWhiteSmoke);
         guiControl.riskExposure.edit.maxPositionValue.ReadOnly(true);
         guiControl.riskExposure.bmpButton.maxPositionValue.Pressed(false);
         riskSettings.SetMaxPosVal(-1);
      }  
      else {
         riskSettings.SetMaxPosVal(value); 
         guiControl.riskExposure.bmpButton.maxPositionValue.Pressed(false);
         guiControl.riskExposure.edit.maxPositionValue.ReadOnly(true); 
         guiControl.riskExposure.edit.maxPositionValue.ColorBackground(clrWhiteSmoke);  
         guiControl.riskExposure.edit.maxPositionValue.Text(DoubleToStr(riskSettings.GetMaxPosVal(),2)+" "+AccountCurrency());
      }
   }
   
   //.......................
   // Currency or Account % Button
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.button.percentageRiskSettings") {
      
      guiControl.riskExposure.RS=1;
      guiControl.riskExposure.button.percentageRiskSettings.ColorBackground(clrLightBlue);
      guiControl.riskExposure.button.currencyRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
      if(riskSettings.GetMaxExpPer()>0)guiControl.riskExposure.edit.maxExposure.Text(DoubleToStr(riskSettings.GetMaxExpPer(),2) + " %");
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.button.currencyRiskSettings") {
      
      guiControl.riskExposure.RS=2;
      guiControl.riskExposure.button.percentageRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
      guiControl.riskExposure.button.currencyRiskSettings.ColorBackground(clrLightBlue);
      if(riskSettings.GetMaxExpCur()>0)guiControl.riskExposure.edit.maxExposure.Text(DoubleToStr(riskSettings.GetMaxExpCur(),2)+" "+AccountCurrency());
   } 
   
   //************************************
   //Total Exposure and Risk
   //************************************
   //.......................
   // Currency or Account % Button
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.button.percentageTotalExposure") {
     
      guiControl.riskExposure.TE=1;
      guiControl.riskExposure.button.percentageTotalExposure.ColorBackground(clrLightBlue);
      guiControl.riskExposure.button.currencyTotalExposure.ColorBackground(C'0xF0,0xF0,0xF0');
      
      if(sumTradesExposure.GetTotalExpAcc() == -10 || sumTradesExposure.GetTotalExpCur() == -10) {
      
        guiControl.riskExposure.edit.totalExposure.FontSize(guiControl.GetsubFont_S());
        guiControl.riskExposure.edit.totalExposure.Text("Use SL in All Trades!");
      }
      else {
      
         guiControl.riskExposure.edit.totalExposure.FontSize(guiControl.GetMainFont_S());
         guiControl.riskExposure.edit.totalExposure.Text(DoubleToStr(sumTradesExposure.GetTotalExpAcc(),2)+" %"); 
      }
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.button.currencyTotalExposure") {
      
      guiControl.riskExposure.TE=2;
      guiControl.riskExposure.button.percentageTotalExposure.ColorBackground(C'0xF0,0xF0,0xF0');
      guiControl.riskExposure.button.currencyTotalExposure.ColorBackground(clrLightBlue);
      
      
      if(sumTradesExposure.GetTotalExpAcc() == -10 || sumTradesExposure.GetTotalExpCur() == -10) {
      
        guiControl.riskExposure.edit.totalExposure.FontSize(guiControl.GetsubFont_S());
        guiControl.riskExposure.edit.totalExposure.Text("Use SL in All Trades!");
      }
         
      else {
      
         guiControl.riskExposure.edit.totalExposure.FontSize(guiControl.GetMainFont_S());
         guiControl.riskExposure.edit.totalExposure.Text(DoubleToStr(sumTradesExposure.GetTotalExpCur(),2)+" " +AccountCurrency());
      }
   }
   
   //************************************
   //Individual Trade Risk and Exposure
   //************************************
   //.......................
   // Currency or Account % Button
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.button.percentageIndivualTradeExposure") {
     
      guiControl.riskExposure.ITE=1;
      guiControl.riskExposure.button.percentageIndivualTradeExposure.ColorBackground(clrLightBlue);
      guiControl.riskExposure.button.currencyIndivualTradeExposure.ColorBackground(C'0xF0,0xF0,0xF0');
      if (indivialTradeExposure.GetSingularExp_Per() == -10 || indivialTradeExposure.GetSingularExp_Cur() == -10) {
         
         guiControl.riskExposure.edit.tradeExposure.FontSize(guiControl.GetsubFont_S());
         guiControl.riskExposure.edit.tradeExposure.Text("Trade with No SL!");
      }
      else {
      
         guiControl.riskExposure.edit.tradeExposure.FontSize(guiControl.GetMainFont_S());
         guiControl.riskExposure.edit.tradeExposure.Text(DoubleToStr(indivialTradeExposure.GetSingularExp_Per(),2)+" %");
      }
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.riskExposure.button.currencyIndivualTradeExposure") {
   
      guiControl.riskExposure.ITE=2; 
      guiControl.riskExposure.button.percentageIndivualTradeExposure.ColorBackground(C'0xF0,0xF0,0xF0');
      guiControl.riskExposure.button.currencyIndivualTradeExposure.ColorBackground(clrLightBlue);    
      if (indivialTradeExposure.GetSingularExp_Per() == -10 || indivialTradeExposure.GetSingularExp_Cur() == -10) {
      
         guiControl.riskExposure.edit.tradeExposure.FontSize(guiControl.GetsubFont_S());
         guiControl.riskExposure.edit.tradeExposure.Text("Trade with No SL!"); 
      }
      else {
      
         guiControl.riskExposure.edit.tradeExposure.FontSize(guiControl.GetMainFont_S());
         guiControl.riskExposure.edit.tradeExposure.Text(DoubleToStr(indivialTradeExposure.GetSingularExp_Cur(),2)+" " +AccountCurrency());
      }
   }
   
   //.......................
   // Combo Box
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && indivialTradeExposure.check_CB_TRADE(guiControl.GetOBJ_CONTROL())) {
      
      if(indivialTradeExposure.GetSingularTradesValues_Risk(guiControl)) 
         indivialTradeExposure.GetSingularTradesValues_PosVal(guiControl);
   }
   
   //+---------------------------------------+
   //|Position Size Calculator               |
   //+---------------------------------------+
   
   //.......................
   //guiControl.positionSizeCalculator.button.tabPSC
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.positionSizeCalculator.button.tabPSC") {
      if(!guiControl.positionSizeCalculator.label.riskPerTrade.IsVisible()) {
      
         //Hide Risk Exposure
         guiControl.riskExposure.hide(); 
         
         //Change the size of Window
         guiControl.mainWindow.windowDialog.Height(guiControl.positionSizeCalculator.height);
         guiControl.mainWindow.copyRightsLabel.Shift(0,guiControl.positionSizeCalculator.crShift);
         
         //Show positionSizeCalculator
         guiControl.positionSizeCalculator.show();
         guiControl.SetOPEN_TAB(guiControl.Check_Tab());
      }   
   } 
   
   //.......................
   //Entry Price Edit Box
   //.......................
   
   //----------------
   //Custom
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.positionSizeCalculator.button.priceCustom") {
      if(guiControl.positionSizeCalculator.edit.entryPrice.ReadOnly() == true){
         guiControl.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhite);
         guiControl.positionSizeCalculator.edit.entryPrice.ReadOnly(false);
         guiControl.positionSizeCalculator.edit.entryPrice.Color(clrBlack);
         
         //Empty Info of positionSizeCalculator
         guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
         guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
         guiControl.positionSizeCalculator.edit.totalUnits.Text("");
         guiControl.positionSizeCalculator.edit.totalLots.Text("");
         guiControl.positionSizeCalculator.edit.positionValue.Text("");
      }
      else {
         guiControl.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
         guiControl.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
         guiControl.positionSizeCalculator.edit.entryPrice.Text("");
         
         //Empty Info of positionSizeCalculator
         guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
         guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
         guiControl.positionSizeCalculator.edit.totalUnits.Text("");
         guiControl.positionSizeCalculator.edit.totalLots.Text("");
         guiControl.positionSizeCalculator.edit.positionValue.Text("");
      }   
   }
   
   //----------------
   //Entry Price - Bid
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.positionSizeCalculator.button.priceBid") {
      guiControl.positionSizeCalculator.edit.entryPrice.Text((string)Bid);
      guiControl.positionSizeCalculator.edit.entryPrice.Color(clrTomato);
      guiControl.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
      guiControl.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
      
      //Empty Info of positionSizeCalculator
      guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
      guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
      guiControl.positionSizeCalculator.edit.totalUnits.Text("");
      guiControl.positionSizeCalculator.edit.totalLots.Text("");
      guiControl.positionSizeCalculator.edit.positionValue.Text("");
   }
   
   //----------------
   //Entry Price - Ask
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.positionSizeCalculator.button.priceAsk") {
      guiControl.positionSizeCalculator.edit.entryPrice.Text((string)Ask);
      guiControl.positionSizeCalculator.edit.entryPrice.Color(clrMediumSeaGreen);
      guiControl.positionSizeCalculator.edit.entryPrice.ColorBackground(clrWhiteSmoke);
      guiControl.positionSizeCalculator.edit.entryPrice.ReadOnly(true);
      
      //Empty Info of positionSizeCalculator
      guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
      guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
      guiControl.positionSizeCalculator.edit.totalUnits.Text("");
      guiControl.positionSizeCalculator.edit.totalLots.Text("");
      guiControl.positionSizeCalculator.edit.positionValue.Text("");
   }
   
   //.......................
   //Calculate Button
   //.......................
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="guiControl.positionSizeCalculator.button.calculate") {
      
      if(positionSizeCalculator.Calculate_Lot(guiControl)) {
      
         positionSizeCalculator.Calculate_PosVal(guiControl);
      }
   }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

   //Entry Price Reset 
   guiControl.positionSizeCalculator.edit.entryPrice.Text("");
   
   //Empty Info of positionSizeCalculator
   guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
   guiControl.positionSizeCalculator.edit.riskInPoints.Text("");
   guiControl.positionSizeCalculator.edit.totalUnits.Text("");
   guiControl.positionSizeCalculator.edit.totalLots.Text("");
   guiControl.positionSizeCalculator.edit.positionValue.Text("");
   
   //Window Control
   if (guiControl.positionSizeCalculator.label.entryPrice.IsVisible()) guiControl.SetCopyFirstWindow(PositionSizeCalculator);
   if (guiControl.riskExposure.label.maxInt.IsVisible()) guiControl.SetCopyFirstWindow(RiskExposure);
   if (guiControl.IsMin()) guiControl.SetCopyFirstWindow(Minimised);
   
   guiControl.SetCopyScale(SCALE);

   //destroy timer
   EventKillTimer();
   
   //Destroy items from Memory
   guiControl.mainWindow.windowDialog.Destroy(reason);
}

