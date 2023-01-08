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
#include "model\CPositionSizeCalculator.mqh"

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

   positionSizeCalculator = new CPositionSizeCalculator();
   riskSettings           = new CRiskSettings();          
   sumTradesExposure      = new CSumTradesExposure();  
   indivialTradeExposure  = new CIndivialTradeExposure();
   guiControl             = new CGuiControl(); 

   // Initialise COnInit Object
   COnInit initialiser;
   
   //Licence Validation 
   if(!initialiser.licenceValidation(LicenceKey)) return(INIT_FAILED);
   
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.button.tabRiskExposure") {
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.bmpButton.maxTrades") {
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
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="gui.riskExposure.edit.maxTrades"){
      
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.bmpButton.maxLots") {
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
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="gui.riskExposure.edit.maxLots"){
      
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.bmpButton.maxExposure") {
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
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="gui.riskExposure.edit.maxExposure"){
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.bmpButton.maxPositionValue") {
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
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="gui.riskExposure.edit.maxPositionValue"){
      
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.button.percentageRiskSettings") {
      
      guiControl.riskExposure.RS=1;
      guiControl.riskExposure.button.percentageRiskSettings.ColorBackground(clrLightBlue);
      guiControl.riskExposure.button.currencyRiskSettings.ColorBackground(C'0xF0,0xF0,0xF0');
      if(riskSettings.GetMaxExpPer()>0)guiControl.riskExposure.edit.maxExposure.Text(DoubleToStr(riskSettings.GetMaxExpPer(),2) + " %");
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.button.currencyRiskSettings") {
      
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.button.percentageTotalExposure") {
     
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
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.button.currencyTotalExposure") {
      
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.button.percentageIndivualTradeExposure") {
     
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
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.riskExposure.button.currencyIndivualTradeExposure") {
   
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
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.positionSizeCalculator.button.priceAsk") {
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
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="gui.positionSizeCalculator.button.calculate") {
      
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

