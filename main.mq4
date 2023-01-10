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
//| Declaring 'Model' Objects                                        |
//+------------------------------------------------------------------+
CPositionSizeCalculator *positionSizeCalculator;
CRiskSettings           *riskSettings;          
CSumTradesExposure      *sumTradesExposure;  
CIndivialTradeExposure  *indivialTradeExposure;
CGuiControl             *guiControl;

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

   // Instantiate Model Objects
   positionSizeCalculator = new CPositionSizeCalculator();
   riskSettings           = new CRiskSettings();          
   sumTradesExposure      = new CSumTradesExposure();  
   indivialTradeExposure  = new CIndivialTradeExposure();
   
   // Instantiate View Object
   guiControl = new CGuiControl(); 

   // Instantiate COnInit Object
   COnInit initialiser;
   
   //Licence Validation 
   if(!initialiser.licenceValidation(LicenceKey)) {
   
      delete positionSizeCalculator;
      delete riskSettings;          
      delete sumTradesExposure;  
      delete indivialTradeExposure;
      delete guiControl;
   
      return(INIT_FAILED);
   }
   
   //Manipulation of Global Variables
   contractsize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);
   
   //Create Main Window
   initialiser.mainWindow.create(guiControl, SCALE);
   
   //Create Position Size Calculator Window
   initialiser.positionSizeCalculator.create(guiControl, contractsize);
   
   //Create Risk Exposure Window
   initialiser.riskExposure.create(guiControl, 
                                   riskSettings, 
                                   sumTradesExposure, 
                                   indivialTradeExposure);
   
   //Finalise SetUp
   initialiser.finaliseSetUp(guiControl, FirstWindow, SCALE);
   
//--- create timer
   EventSetTimer(1);
//---
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert Timer function                                            |
//+------------------------------------------------------------------+
void OnTimer() {

   // Instantiate COnTimer Object
   COnTimer timer;
   
   // track Input By User On Risk Exposure       
   timer.trackInputByUserOnRiskExposure(guiControl, riskSettings, sumTradesExposure);                           
   
   // Calculate total trades 
   timer.calculateTotalTrades(guiControl, sumTradesExposure);
   
   // Calculate totals
   timer.calculateTotals(guiControl, sumTradesExposure);
   
   //Add Trades To combo Box  
   timer.addTradesToComboBox(guiControl, sumTradesExposure, indivialTradeExposure);
   
   //..................................................
   //Update values of Singular Trade 
   //..................................................
   //guiControl.riskExposure.comboBox.tradeExposure.SelectByText()
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

   // Instantiate COnTick object
   COnTick tick;
   
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

   // Instantiate COnChartEvent Object
   COnChartEvent event;                  
   
   //+---------------------------------------+
   //|Enable Controls of Main Window         |
   //+---------------------------------------+
   
   //Enable Tracking of Main Window
   event.mainWindow.activate(guiControl,id,lparam,dparam,sparam);
   
   //Track OBJ Pressed
   if(id==CHARTEVENT_OBJECT_CLICK) {
      event.trackOBJ(guiControl, sparam);
   }
   
   //Mininmise Window
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Min_Max") {
      event.mainWindow.minMax(guiControl);
   }
   
   //+---------------------------------------+
   //|Risk Exposure Tab                      |
   //+---------------------------------------+
   
   //Mininmise/Maximise Risk Exposure Tab
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="tabRiskExposure") {
      event.riskExposure.displayTab(guiControl);   
   } 
   
   //************************************
   //Risk Settings
   //************************************
   //.......................
   //MAX TRADES (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="maxTradesBMP") {
      event.riskExposure.trackMaxTradesBMP(guiControl, riskSettings);  
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="maxTradesEDIT"){
      event.riskExposure.trackMaxTradesEdit(guiControl, riskSettings);
   }
   
   //.......................
   //MAX Lots (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="maxLotsBMP") {
      event.riskExposure.trackMaxLotsBMP(guiControl, riskSettings);
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="maxLotsEDIT"){
      event.riskExposure.trackMaxLotsEdit(guiControl, riskSettings);
   }
   
   //.......................
   //MAX Currency Exposure (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="maxExposureBMP") {
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
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="maxExposureEDIT"){
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="maxPositionValueBMP") {
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
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="maxPositionValueEDIT"){
      
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="percentageRiskSettingsBUTTON") {
      
      guiControl.riskExposure.RS=1;
      guiControl.riskExposure.button.percentageRiskSettings.ColorBackground(clrLightBlue);
      guiControl.riskExposure.button.currencyRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
      if(riskSettings.GetMaxExpPer()>0)guiControl.riskExposure.edit.maxExposure.Text(DoubleToStr(riskSettings.GetMaxExpPer(),2) + " %");
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="currencyRiskSettingsBUTTON") {
      
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="percentageTotalExposureBUTTON") {
     
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
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="currencyTotalExposureBUTTON") {
      
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="percentageIndivualTradeExposureBUTTON") {
     
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
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="currencyIndivualTradeExposureBUTTON") {
   
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="tabPSC") {
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="priceCustom") {
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="priceBid") {
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="priceAsk") {
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
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="calculatebutton") {
      
      if(positionSizeCalculator.Calculate_Lot(guiControl)) {
      
         positionSizeCalculator.Calculate_PosVal(guiControl);
      }
   }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   /*
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
   
   guiControl.SetCopyScale(SCALE);*/

   //destroy timer
   EventKillTimer();
   
   //Destroy items from Memory
   guiControl.mainWindow.windowDialog.Destroy(reason);
   
   // Delete Objects
   delete positionSizeCalculator;
   delete riskSettings;
   delete sumTradesExposure;
   delete indivialTradeExposure;
   delete guiControl;
}

