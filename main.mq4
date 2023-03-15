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
//| Include MT4 Defined Resources                                    |
//+------------------------------------------------------------------+
#resource "\\Include\\Controls\\res\\CheckBoxOff.bmp"  
#resource "\\Include\\Controls\\res\\CheckBoxOn.bmp"
#resource "\\Include\\Controls\\res\\Up.bmp"  
#resource "\\Include\\Controls\\res\\Down.bmp"

//+------------------------------------------------------------------+
//| Declaring Pointers to Objects                                    |
//+------------------------------------------------------------------+
CPositionSizeCalculator *positionSizeCalculator;
CRiskSettings           *riskSettings;          
CSumTradesExposure      *sumTradesExposure;  
CIndivialTradeExposure  *indivialTradeExposure;
CGuiControl             *guiControl;

//+------------------------------------------------------------------+
//| Event Handlers Objects                                           |
//+------------------------------------------------------------------+
COnInit       initialiser;
COnTimer      timer;
COnTick       tick;
COnChartEvent event;

//+------------------------------------------------------------------+
//| Input Variables                                                  |
//+------------------------------------------------------------------+
input  double SCALE = 1.0; //Scale    
extern Window FirstWindow = PositionSizeCalculator;
input  string LicenceKey;

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
bool firstInit = true;
int  uninitReason;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   
   // Condition to Run OnInit
   if(uninitReason != REASON_CHARTCHANGE) {
      
      // Licence Validation 
      if(!initialiser.licenceValidation(LicenceKey)) return(INIT_FAILED);
   
      // Instantiate Objects
      positionSizeCalculator = new CPositionSizeCalculator();
      riskSettings           = new CRiskSettings();          
      sumTradesExposure      = new CSumTradesExposure();  
      indivialTradeExposure  = new CIndivialTradeExposure();
      guiControl             = new CGuiControl(SCALE); 
      
      // Create Main Window
      initialiser.mainWindow.create(guiControl);
      
      // Create Position Size Calculator Window
      initialiser.positionSizeCalculator.create(guiControl);
      
      // Create Risk Exposure Window
      initialiser.riskExposure.create(guiControl, 
                                      riskSettings, 
                                      sumTradesExposure, 
                                      indivialTradeExposure);
      
      // Finalise SetUp
      initialiser.mainWindow.finaliseSetUp(guiControl, FirstWindow);
   
   //--- create timer
      EventSetTimer(1);
   //---
   }
   
   // Manipulation of Global Variables
   guiControl.positionSizeCalculator.edit.contractSize.Text(string(SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE)));
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert Timer function                                            |
//+------------------------------------------------------------------+
void OnTimer() {

   // track Input By User On Risk Exposure       
   timer.trackInputByUserOnRiskExposure(guiControl, riskSettings, sumTradesExposure);                           
   
   // Calculate total trades 
   timer.calculateTotalTrades(guiControl, sumTradesExposure);
   
   // Calculate totals
   timer.calculateTotals(guiControl, sumTradesExposure);
   
   //Add Trades To combo Box  
   timer.addTradesToComboBox(guiControl, sumTradesExposure, indivialTradeExposure);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
   
   // Track Price Buttons On Position Size Calculator
   tick.trackPriceButtonsOnPSC(guiControl, positionSizeCalculator);
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int    id,
                  const long   &lparam,
                  const double &dparam,
                  const string &sparam) {                  
   
   // Enable Tracking of Main Window
   event.mainWindow.activate(guiControl,id,lparam,dparam,sparam);
   
   // Track OBJ Pressed
   if(id==CHARTEVENT_OBJECT_CLICK) 
      event.trackOBJ(guiControl, sparam);
   
   // Mininmise Window
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Min_Max") 
      event.mainWindow.minMax(guiControl);
   
   //+---------------------------------------+
   //|Risk Exposure Tab                      |
   //+---------------------------------------+
   
   // Mininmise/Maximise Risk Exposure Tab
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="tabRiskExposure") 
      event.riskExposure.displayTab(guiControl);   
   
   //-------------------------
   //Risk Settings
   
   // MAX TRADES (Input by the user) - BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="maxTradesBMP")
      event.riskExposure.trackMaxTradesBMP(guiControl, riskSettings);  
   
   // MAX TRADES (Input by the user) - Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="maxTradesEDIT")
      event.riskExposure.trackMaxTradesEdit(guiControl, riskSettings);
   
   // MAX Lots (Input by the user) - BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="maxLotsBMP") 
      event.riskExposure.trackMaxLotsBMP(guiControl, riskSettings);
   
   // MAX Lots (Input by the user) - Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="maxLotsEDIT")
      event.riskExposure.trackMaxLotsEdit(guiControl, riskSettings);
   
   // MAX Currency Exposure (Input by the user) - BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="maxExposureBMP") 
      event.riskExposure.trackMaxExposureBMP(guiControl, riskSettings);
   
   // MAX Currency Exposure (Input by the user) - Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="maxExposureEDIT") 
      event.riskExposure.trackMaxExposureEDIT(guiControl, riskSettings);
   
   // MAX Position Value (Input by the user) - BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="maxPositionValueBMP") 
      event.riskExposure.trackMaxPositionValueBMP(guiControl, riskSettings);
   
   // MAX Position Value (Input by the user) - Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="maxPositionValueEDIT")
      event.riskExposure.trackMaxPositionValueEDIT(guiControl, riskSettings);
   
   // Currency or Account % Button - percentage
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="percentageRiskSettingsBUTTON") 
      event.riskExposure.trackPercentageRiskSettingsBUTTON(guiControl, riskSettings);
   
   // Currency or Account % Button - percentage - currency
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="currencyRiskSettingsBUTTON") 
      event.riskExposure.trackCurrencyRiskSettingsBUTTON(guiControl, riskSettings);
   // End of Risk Settings 
   //-------------------------


   //-------------------------
   // Total Trade Risk and Exposure
   // Currency or Account % Button - percentage
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="percentageTotalExposureBUTTON") 
      event.riskExposure.trackPercentageTotalExposureBUTTON(guiControl, sumTradesExposure);
   
   // Currency or Account % Button - currency
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="currencyTotalExposureBUTTON") 
      event.riskExposure.trackCurrencyTotalExposureBUTTON(guiControl, sumTradesExposure);
   // End of Total Trade Risk and Exposure
   //-------------------------


   //-------------------------
   //Individual Trade Risk and Exposure

   // Currency or Account % Button - percentage
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="percentageIndivualTradeExposureBUTTON") 
      event.riskExposure.trackPercentageIndivualTradeExposureBUTTON(guiControl, indivialTradeExposure);  
   
   // Currency or Account % Button - currency
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="currencyIndivualTradeExposureBUTTON") 
      event.riskExposure.trackCurrencyIndivualTradeExposureBUTTON(guiControl, indivialTradeExposure);
   
   // Combo Box
   if(id==CHARTEVENT_OBJECT_CLICK && indivialTradeExposure.check_CB_TRADE(guiControl.GetOBJ_CONTROL()))
       event.riskExposure.trackComboBox(guiControl, indivialTradeExposure);
   //End of Individual Trade Risk and Exposure  
   //-------------------------


   //+---------------------------------------+
   //|Position Size Calculator               |
   //+---------------------------------------+
   
   // Mininmise/Maximise Position Size Calculator Tab
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="tabPSC") 
      event.positionSizeCalculator.displayTab(guiControl);
   
   //-------------------------
   // Entry Price Edit Box

   // Custom Price
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="priceCustom") 
      event.positionSizeCalculator.trackPriceCustom(guiControl);
   
   // Entry Price - Bid
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="priceBid") 
      event.positionSizeCalculator.trackPriceBid(guiControl);

   // Entry Price - Ask
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="priceAsk") 
      event.positionSizeCalculator.trackPriceAsk(guiControl);
   // End of Entry Price Edit Box
   //-------------------------
      
   // Calculate Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="calculateBUTTON") 
      event.positionSizeCalculator.trackCalculateBUTTON(guiControl, positionSizeCalculator);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   
   if(reason != REASON_CHARTCHANGE) {
   
      // destroy timer
      EventKillTimer();
   
      // Destroy items from Memory
      guiControl.mainWindow.windowDialog.Destroy(reason);
   
      // Delete Objects
      delete positionSizeCalculator;
      delete riskSettings;
      delete sumTradesExposure;
      delete indivialTradeExposure;
      delete guiControl;
   }
   
   //--- Set firstInit to false
   firstInit = false;
   //--- Set uninitReason to reason
   uninitReason = reason;
}

