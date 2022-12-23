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
#include "controller\COnChartEvent.mqh"
#include "controller\COnDeinit.mqh"
#include "controller\COnInit.mqh"
#include "controller\COnTick.mqh"
#include "controller\COnTimer.mqh"

//+------------------------------------------------------------------+
//| Include App Functionality Components                             |
//+------------------------------------------------------------------+
#include "model\CIndivialTradeExposure.mqh"
#include "model\CPositionSizeCalculator.mqh"
#include "model\CRiskSettings.mqh"
#include "model\CSumTradesExposure.mqh"

//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "view\CGuiControl.mqh"


//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
input  string LicenceKey;
double contractsize;   

//+------------------------------------------------------------------+
//| Input Variables                                                  |
//+------------------------------------------------------------------+
input  double SCALE = 1.0; //Scale      
extern Window FirstWindow = RiskExposure;

//+------------------------------------------------------------------+
//| Declaring Objects                                                |
//+------------------------------------------------------------------+

//------------------------------
//Custom Objects
//------------------------------
CPositionSizeCalculator positionSizeCalculator;
CRiskSettings           riskSettings;          
CSumTradesExposure      sumTradesExposure;  
CIndivialTradeExposure  indivialTradeExposure;
CGuiControl             guiControl;

//------------------------------
//Position Size Calculator
//------------------------------

//buttons
CButton ButtonTabPSC;
CButton ButtonCalculate;
CButton Price_Custom;
CButton Price_Bid;
CButton Price_Ask;

//Labels
CLabel PSC_label_Risk_per_trade;
CLabel PSC_label_Entry;
CLabel PSC_label_SL;
CLabel PSC_label_Risk_in_Points;
CLabel PSC_label_Risk_in_Currency;
CLabel PSC_label_Contract_Size;
CLabel PSC_label_Total_Units;
CLabel PSC_label_Total_Lots;
CLabel PSC_label_PosVal;

//Edit Box
CEdit PSC_edit_Risk_per_trade;
CEdit PSC_edit_Entry;
CEdit PSC_edit_SL;
CEdit PSC_edit_Risk_in_Points;
CEdit PSC_edit_Risk_in_Currency;
CEdit PSC_edit_Contract_Size;
CEdit PSC_edit_Total_Units;
CEdit PSC_edit_Total_Lots;
CEdit PSC_edit_PosVal;

//------------------------------
//Risk Exposure
//------------------------------

//buttons
CButton ButtonTabRisk;
CButton RE_Cur_RS;
CButton RE_Per_RS;
CButton RE_Cur_TE;
CButton RE_Per_TE;
CButton RE_Cur_ITE;
CButton RE_Per_ITE;

//Labels
CLabel RE_label_MAX_int;
CLabel RE_label_MAX_Trades;
CLabel RE_label_MAX_Lots;
CLabel RE_label_MAX_Exp;
CLabel RE_label_MAX_PosVal;
CLabel RE_label_total_Expo_int;
CLabel RE_label_Total_Trades;
CLabel RE_label_Total_Lots;
CLabel RE_label_Total_Exp;
CLabel RE_label_Total_PosVal;
CLabel RE_label_Trade_Select_int;
CLabel RE_label_Trade_Select;
CLabel RE_label_Trade_Exp;
CLabel RE_label_Trade_PosVal;

//Edit Box
CEdit RE_edit_MAX_Trades;
CEdit RE_edit_MAX_Lots;
CEdit RE_edit_MAX_Exp;
CEdit RE_edit_MAX_PosVal;
CEdit RE_edit_Total_Trades;
CEdit RE_edit_Total_Lots;
CEdit RE_edit_Total_Exp;
CEdit RE_edit_Total_PosVal;
CEdit RE_edit_Trade_Exp;
CEdit RE_edit_Trade_PosVal;

//Combo Box
CComboBox RE_CB_Trade_Expo;

//BMP Button
CBmpButton RE_BMP_MAX_Trades;
CBmpButton RE_BMP_MAX_Lots;
CBmpButton RE_BMP_MAX_Exp;
CBmpButton RE_BMP_MAX_PosVal;

//------------------------------
//Main Window
//------------------------------
CAppDialog MainWindow;
CLabel     CopyRights;
CBmpButton Min_Max;

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
   
   //****************************************************************
   //Create Main Window
   //****************************************************************
   
   //Reset Constructor if needed, adjust if user changes scale during the execution of the program
   guiControl.SetScale(SCALE);
   if(guiControl.GetCopyScale() != SCALE) guiControl.ResetContructor();
   
   if(guiControl.GetCopyFirstWindow()==-1 || guiControl.GetCopyScale() != SCALE) {
      MainWindow.Create(0,"MainWindow",0,0,0,guiControl.GetMainWindowWidth(),guiControl.GetRE_Height());        
      MainWindow.Shift(guiControl.ScaledPixel(400),0);
   }
   
   //Remember the position of the windown when Changing Assets or TimeFrames
   else MainWindow.Create(0,
                          "MainWindow",
                          0,
                          MainWindow.Left(),
                          MainWindow.Top(),
                          guiControl.GetMainWindowWidth()+MainWindow.Left(),
                          guiControl.GetRE_Height()+MainWindow.Top());
   
   MainWindow.Caption("Risk Manager v2.00 BETA");
   ObjectSetInteger(0,MainWindow.Name()+"Caption",OBJPROP_FONTSIZE,guiControl.GetMainFont_S());
   
   //CopyRights
   CopyRights.Create(0,"CopyRights",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(CopyRights);
   CopyRights.Text("©MrPragmatic");
   CopyRights.FontSize(guiControl.GetMainFont_S());
   
   //Personalised Min/Max Button
   MainWindow.m_button_minmax.Hide();
   Min_Max.Create(0,"Min_Max",0,0,0,0,0);
   Min_Max.BmpNames("::Include\\Controls\\res\\Up.bmp",
                    "::Include\\Controls\\res\\Down.bmp"); 
   MainWindow.Add(Min_Max); 
   Min_Max.Shift(guiControl.ScaledPixel(340),-18);
   
   //****************************************************************
   //Create Position Size Calculator Window
   //****************************************************************
   //-------------------------
   //Button - ButtonTabPSC  
   ButtonTabPSC.Create(0,
                      "ButtonTabPSC",
                      0,
                      guiControl.ScaledPixel(5),
                      guiControl.ScaledPixel(5),
                      guiControl.ScaledPixel(180),
                      guiControl.ScaledPixel(30));
                      
   ButtonTabPSC.Text("Position Size Calculator");
   MainWindow.Add(ButtonTabPSC);
   ButtonTabPSC.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Risk per trade
   //-------------------------
   //Label
   PSC_label_Risk_per_trade.Create(0,"PSC_label_Risk_per_trade",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));                         
   MainWindow.Add(PSC_label_Risk_per_trade);
   PSC_label_Risk_per_trade.Text("Risk On Trade (% of Account Balance)");
   PSC_label_Risk_per_trade.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(45));
   PSC_label_Risk_per_trade.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   PSC_edit_Risk_per_trade.Create(0,"PSC_edit_Risk_per_trade",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));                
   MainWindow.Add(PSC_edit_Risk_per_trade);
   PSC_edit_Risk_per_trade.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(45));
   PSC_edit_Risk_per_trade.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Entry Price
   //-------------------------
   //Label
   PSC_label_Entry.Create(0,"PSC_label_Entry",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));                   
   MainWindow.Add(PSC_label_Entry);
   PSC_label_Entry.Text("Entry Price");
   PSC_label_Entry.Shift(guiControl.ScaledPixel(5), guiControl.ScaledPixel(75));                  
   PSC_label_Entry.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   PSC_edit_Entry.Create(0,"PSC_edit_Entry",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Entry);
   PSC_edit_Entry.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(75));
   PSC_edit_Entry.ReadOnly(true);
   PSC_edit_Entry.ColorBackground(clrWhiteSmoke);
   PSC_edit_Entry.FontSize(guiControl.GetMainFont_S());
   
   //Button - Custom 
   Price_Custom.Create(0,"Price_Custom",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));        
   MainWindow.Add(Price_Custom);
   Price_Custom.Shift(guiControl.ScaledPixel(80),guiControl.ScaledPixel(77));
   Price_Custom.Text("Custom");
   Price_Custom.FontSize(guiControl.GetsubFont_S());
   Price_Custom.ColorBackground(clrLightBlue);
   
   //Button - Bid 
   Price_Bid.Create(0,"Price_Bid",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   MainWindow.Add(Price_Bid);
   Price_Bid.Shift(guiControl.ScaledPixel(135),guiControl.ScaledPixel(77));
   Price_Bid.Text("Bid");
   Price_Bid.FontSize(guiControl.GetsubFont_S());
   Price_Bid.ColorBackground(clrTomato);
   
   //Button - Ask
   Price_Ask.Create(0,"Price_Ask",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));  
   MainWindow.Add(Price_Ask);
   Price_Ask.Shift(guiControl.ScaledPixel(190),guiControl.ScaledPixel(77));
   Price_Ask.Text("Ask");
   Price_Ask.FontSize(guiControl.GetsubFont_S());
   Price_Ask.ColorBackground(clrMediumSeaGreen);
   
   //-------------------------
   //Stop Loss
   //-------------------------
   //Label
   PSC_label_SL.Create(0,"PSC_label_SL",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));  
   MainWindow.Add(PSC_label_SL);
   PSC_label_SL.Text("Stop Loss Price");
   PSC_label_SL.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(105));
   PSC_label_SL.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   PSC_edit_SL.Create(0,"PSC_edit_SL",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(PSC_edit_SL);
   PSC_edit_SL.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(105));
   PSC_edit_SL.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Button - ButtonCalculate 
   //-------------------------
   ButtonCalculate.Create(0,"ButtonCalculate",0,0,0,guiControl.ScaledPixel(75),guiControl.ScaledPixel(25));
   MainWindow.Add(ButtonCalculate);
   ButtonCalculate.Shift(guiControl.ScaledPixel(150),guiControl.ScaledPixel(135));
   ButtonCalculate.Text("Calculate");
   ButtonCalculate.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Points
   //-------------------------
   //Label 
   PSC_label_Risk_in_Points.Create(0,"PSC_label_Risk_in_Points",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(PSC_label_Risk_in_Points);
   PSC_label_Risk_in_Points.Text("Risk in Points");
   PSC_label_Risk_in_Points.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(170));
   PSC_label_Risk_in_Points.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   PSC_edit_Risk_in_Points.Create(0,"PSC_edit_Risk_in_Points",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Risk_in_Points);
   PSC_edit_Risk_in_Points.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(170));
   PSC_edit_Risk_in_Points.ReadOnly(true);
   PSC_edit_Risk_in_Points.ColorBackground(clrWhiteSmoke);
   PSC_edit_Risk_in_Points.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Currency
   //-------------------------
   //Label 
   PSC_label_Risk_in_Currency.Create(0,"PSC_label_Risk_in_Currency",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(PSC_label_Risk_in_Currency);
   PSC_label_Risk_in_Currency.Text("Risk in " + AccountCurrency());
   PSC_label_Risk_in_Currency.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(200));
   PSC_label_Risk_in_Currency.FontSize(guiControl.GetMainFont_S());
   
   //Edit box
   PSC_edit_Risk_in_Currency.Create(0,"PSC_edit_Risk_in_Currency",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Risk_in_Currency);
   PSC_edit_Risk_in_Currency.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(200));
   PSC_edit_Risk_in_Currency.ReadOnly(true);
   PSC_edit_Risk_in_Currency.ColorBackground(clrWhiteSmoke);
   PSC_edit_Risk_in_Currency.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Contract_Size
   //-------------------------
   //Label
   PSC_label_Contract_Size.Create(0,"PSC_label_Contract_Size",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(PSC_label_Contract_Size);
   PSC_label_Contract_Size.Text("Contract Size");
   PSC_label_Contract_Size.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(230));
   PSC_label_Contract_Size.FontSize(guiControl.GetMainFont_S());
   
   //Edit 
   PSC_edit_Contract_Size.Create(0,"PSC_edit_Contract_Size",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));       
   MainWindow.Add(PSC_edit_Contract_Size);
   PSC_edit_Contract_Size.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(230));
   PSC_edit_Contract_Size.ReadOnly(true);
   PSC_edit_Contract_Size.ColorBackground(clrGainsboro);
   PSC_edit_Contract_Size.Text((string)contractsize);
   PSC_edit_Contract_Size.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Total_Units
   //-------------------------
   //Label
   PSC_label_Total_Units.Create(0,"PSC_label_Total_Units",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(PSC_label_Total_Units);
   PSC_label_Total_Units.Text("Total Units");
   PSC_label_Total_Units.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(260));
   PSC_label_Total_Units.FontSize(guiControl.GetMainFont_S());
   
   //Edit 
   PSC_edit_Total_Units.Create(0,"PSC_edit_Total_Units",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Total_Units);
   PSC_edit_Total_Units.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(260));
   PSC_edit_Total_Units.ReadOnly(true);
   PSC_edit_Total_Units.ColorBackground(clrWhiteSmoke);
   PSC_edit_Total_Units.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label
   PSC_label_Total_Lots.Create(0,"PSC_label_Total_Lots",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(PSC_label_Total_Lots);
   PSC_label_Total_Lots.Text("Total Lots");
   PSC_label_Total_Lots.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(290));
   PSC_label_Total_Lots.FontSize(guiControl.GetMainFont_S());
   
   //Edit 
   PSC_edit_Total_Lots.Create(0,"PSC_edit_Total_Lots",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Total_Lots);
   PSC_edit_Total_Lots.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(290));
   PSC_edit_Total_Lots.ReadOnly(true);
   PSC_edit_Total_Lots.ColorBackground(clrGold);
   PSC_edit_Total_Lots.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Total PositionValue 
   //-------------------------
   //label
   PSC_label_PosVal.Create(0,"PSC_label_PosVal",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(PSC_label_PosVal);
   PSC_label_PosVal.Text(AccountCurrency()+" Exposure");
   PSC_label_PosVal.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(320));
   PSC_label_PosVal.FontSize(guiControl.GetMainFont_S());
   
   //edit
   PSC_edit_PosVal.Create(0,"PSC_edit_PosVal",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(PSC_edit_PosVal);
   PSC_edit_PosVal.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(320));
   PSC_edit_PosVal.ReadOnly(true);
   PSC_edit_PosVal.ColorBackground(clrWhiteSmoke);
   PSC_edit_PosVal.FontSize(guiControl.GetMainFont_S());
   
   //****************************************************************
   //Create Risk Exposure Window
   //****************************************************************
   //-------------------------
   //Button - ButtonTabRisk
   //-------------------------
   ButtonTabRisk.Create(0,"ButtonTabRisk",0,0,0,guiControl.ScaledPixel(175),guiControl.ScaledPixel(25));
   ButtonTabRisk.Text("Risk Exposure");
   ButtonTabRisk.FontSize(guiControl.GetMainFont_S());
   MainWindow.Add(ButtonTabRisk);
   ButtonTabRisk.Shift(guiControl.ScaledPixel(195),guiControl.ScaledPixel(5));
   
   //--------------------------------------------------------
   // Risk Settings
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label
   //-------------------------
   RE_label_MAX_int.Create(0,"RE_label_MAX_int",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_int);
   RE_label_MAX_int.Text("Risk Settings");
   RE_label_MAX_int.Shift(guiControl.ScaledPixel(145),guiControl.ScaledPixel(45));
   RE_label_MAX_int.Color(clrMediumBlue);
   RE_label_MAX_int.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //MAX Settings Trades
   //-------------------------
   //Label
   RE_label_MAX_Trades.Create(0,"RE_label_MAX_Trades",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_Trades);
   RE_label_MAX_Trades.Text("MAX # Trades");
   RE_label_MAX_Trades.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(72));
   RE_label_MAX_Trades.FontSize(guiControl.GetMainFont_S());
   
   //edit
   RE_edit_MAX_Trades.Create(0,"RE_edit_MAX_Trades",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_MAX_Trades);
   RE_edit_MAX_Trades.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(70));
   RE_edit_MAX_Trades.ReadOnly(true);
   RE_edit_MAX_Trades.ColorBackground(clrWhiteSmoke);
   RE_edit_MAX_Trades.FontSize(guiControl.GetMainFont_S());
   if (riskSettings.GetMaxTrades() != -1) RE_edit_MAX_Trades.Text((string)riskSettings.GetMaxTrades());
   
   //bmp
   RE_BMP_MAX_Trades.Create(0,"RE_BMP_MAX_Trades",0,0,0,0,0);
   RE_BMP_MAX_Trades.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                              "::Include\\Controls\\res\\CheckBoxOn.bmp");
   MainWindow.Add(RE_BMP_MAX_Trades); 
   RE_BMP_MAX_Trades.Shift(guiControl.ScaledPixel(230),guiControl.ScaledPixel(75));
   
   //-------------------------
   //MAX Settings Lots
   //-------------------------
   //Label
   RE_label_MAX_Lots.Create(0,"RE_label_MAX_Lots",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_Lots);
   RE_label_MAX_Lots.Text("MAX Lots");
   RE_label_MAX_Lots.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(102));
   RE_label_MAX_Lots.FontSize(guiControl.GetMainFont_S());
   
   //edit
   RE_edit_MAX_Lots.Create(0,"RE_edit_MAX_Lots",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_MAX_Lots);
   RE_edit_MAX_Lots.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(100));
   RE_edit_MAX_Lots.ReadOnly(true);
   RE_edit_MAX_Lots.ColorBackground(clrWhiteSmoke);
   RE_edit_MAX_Lots.FontSize(guiControl.GetMainFont_S());
   if (riskSettings.GetMaxLots() != -1) RE_edit_MAX_Lots.Text((string)riskSettings.GetMaxLots());
   
   //bmp
   RE_BMP_MAX_Lots.Create(0,"RE_BMP_MAX_Lots",0,0,0,0,0);
   RE_BMP_MAX_Lots.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                            "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   MainWindow.Add(RE_BMP_MAX_Lots); 
   RE_BMP_MAX_Lots.Shift(guiControl.ScaledPixel(230),guiControl.ScaledPixel(105));
   
   //-------------------------
   //MAX Settings Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Risk Settings
   //Account percentage
   RE_Per_RS.Create(0,"RE_Per_RS",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   MainWindow.Add(RE_Per_RS);
   RE_Per_RS.Shift(guiControl.ScaledPixel(125),guiControl.ScaledPixel(135));
   RE_Per_RS.Text("Acc%");
   RE_Per_RS.FontSize(guiControl.GetsubFont_S());
   //Currency 
   RE_Cur_RS.Create(0,"RE_Cur_RS",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   MainWindow.Add(RE_Cur_RS);
   RE_Cur_RS.Shift(guiControl.ScaledPixel(175),guiControl.ScaledPixel(135));
   RE_Cur_RS.Text(AccountCurrency());
   RE_Cur_RS.FontSize(guiControl.GetsubFont_S());
   //Button Clr OnInit
   if(guiControl.GetRS() ==1) {
      RE_Per_RS.ColorBackground(clrLightBlue);
      RE_Cur_RS.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(guiControl.GetRS()==2){
      RE_Per_RS.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_RS.ColorBackground(clrLightBlue);
   }
   
   //Label
   RE_label_MAX_Exp.Create(0,"RE_label_MAX_Exp",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_Exp);
   RE_label_MAX_Exp.Text("MAX Risk");
   RE_label_MAX_Exp.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(132));
   RE_label_MAX_Exp.FontSize(guiControl.GetMainFont_S());
   
   //edit Currency
   RE_edit_MAX_Exp.Create(0,"RE_edit_MAX_Exp",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_MAX_Exp);
   RE_edit_MAX_Exp.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(130));
   RE_edit_MAX_Exp.ReadOnly(true);
   RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke);
   if(guiControl.GetRS() ==1) {
      if (riskSettings.GetMaxExpPer() != -1) 
         RE_edit_MAX_Exp.Text(DoubleToString(riskSettings.GetMaxExpPer(),2) + " %");
   }   
   if(guiControl.GetRS()==2){
      if (riskSettings.GetMaxExpCur() != -1) 
         RE_edit_MAX_Exp.Text(DoubleToString(riskSettings.GetMaxExpCur(),2) + " "+AccountCurrency());
   }
   RE_edit_MAX_Exp.FontSize(guiControl.GetMainFont_S());
   //bmp
   RE_BMP_MAX_Exp.Create(0,"RE_BMP_MAX_Exp",0,0,0,0,0);
   RE_BMP_MAX_Exp.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   MainWindow.Add(RE_BMP_MAX_Exp); 
   RE_BMP_MAX_Exp.Shift(guiControl.ScaledPixel(230),guiControl.ScaledPixel(135));
   
   //-------------------------
   //Max Currency Value of PositionSize
   //-------------------------
   //Label
   RE_label_MAX_PosVal.Create(0,"RE_label_MAX_PosVal",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_PosVal);
   RE_label_MAX_PosVal.Text("MAX " + AccountCurrency() + " Exposure");
   RE_label_MAX_PosVal.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(162));
   RE_label_MAX_PosVal.FontSize(guiControl.GetMainFont_S());
   
   //bmp
   RE_BMP_MAX_PosVal.Create(0,"RE_BMP_MAX_PosVal",0,0,0,0,0);
   RE_BMP_MAX_PosVal.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                   "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   MainWindow.Add(RE_BMP_MAX_PosVal); 
   RE_BMP_MAX_PosVal.Shift(guiControl.ScaledPixel(230),guiControl.ScaledPixel(165));
   
   //edit
   RE_edit_MAX_PosVal.Create(0,"RE_edit_MAX_PosVal",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_MAX_PosVal);
   RE_edit_MAX_PosVal.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(160));
   RE_edit_MAX_PosVal.ReadOnly(true);
   RE_edit_MAX_PosVal.ColorBackground(clrWhiteSmoke);
   RE_edit_MAX_PosVal.FontSize(guiControl.GetMainFont_S());
   if (riskSettings.GetMaxPosVal() != -1) RE_edit_MAX_PosVal.Text((string)riskSettings.GetMaxPosVal() + " "+AccountCurrency());
   
   //--------------------------------------------------------
   // Total Exposure
   //--------------------------------------------------------
  
   //-------------------------
   //Introduction Label
   //-------------------------
   RE_label_total_Expo_int.Create(0,"RE_label_total_Expo_int",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   RE_label_total_Expo_int.Text("Total Exposure");
   MainWindow.Add(RE_label_total_Expo_int);
   RE_label_total_Expo_int.Shift(guiControl.ScaledPixel(140),guiControl.ScaledPixel(188));
   RE_label_total_Expo_int.Color(clrMediumBlue);
   RE_label_total_Expo_int.FontSize(guiControl.GetMainFont_S());
   
   //-------------------------
   //Total_Trades
   //-------------------------
   //Label - RE_label_Total_Trades 
   RE_label_Total_Trades.Create(0,"RE_label_Total_Trades",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_Total_Trades);
   RE_label_Total_Trades.Text("Total Trades");
   RE_label_Total_Trades.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(212));
   RE_label_Total_Trades.FontSize(guiControl.GetMainFont_S());
   
   //Edit - RE_edit_Total_Trades 
   RE_edit_Total_Trades.Create(0,"RE_edit_Total_Trades",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_Total_Trades);
   RE_edit_Total_Trades.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(210));
   RE_edit_Total_Trades.ReadOnly(true);
   RE_edit_Total_Trades.FontSize(guiControl.GetMainFont_S());
   
   if (sumTradesExposure.GetTotalTrades() > riskSettings.GetMaxTrades() && 
       riskSettings.GetMaxTrades() != -1) {
      RE_edit_Total_Trades.ColorBackground(clrTomato);
   }
   else RE_edit_Total_Trades.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label - RE_label_Total_Lots 
   RE_label_Total_Lots.Create(0,"RE_label_Total_Lots",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_Total_Lots);
   RE_label_Total_Lots.Text("Total Lots");
   RE_label_Total_Lots.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(242));
   RE_label_Total_Lots.FontSize(guiControl.GetMainFont_S());
   
   //Edit - RE_edit_Total_Lots 
   RE_edit_Total_Lots.Create(0,"RE_edit_Total_Lots",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_Total_Lots);
   RE_edit_Total_Lots.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(240));
   RE_edit_Total_Lots.ReadOnly(true);
   RE_edit_Total_Lots.FontSize(guiControl.GetMainFont_S());
   
   if (sumTradesExposure.GetTotalLots() > riskSettings.GetMaxLots() && 
       riskSettings.GetMaxLots() != -1) {
      RE_edit_Total_Lots.ColorBackground(clrTomato);
   }
   else RE_edit_Total_Lots.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total Exp Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Total Exposure
   //Account percentage
   RE_Per_TE.Create(0,"RE_Per_TE",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   MainWindow.Add(RE_Per_TE);
   RE_Per_TE.Shift(guiControl.ScaledPixel(125),guiControl.ScaledPixel(275));
   RE_Per_TE.Text("Acc%");
   RE_Per_TE.FontSize(guiControl.GetsubFont_S());
   //RE_Per_TE.ColorBackground(clrLightBlue);
   //Currency 
   RE_Cur_TE.Create(0,"RE_Cur_TE",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   MainWindow.Add(RE_Cur_TE);
   RE_Cur_TE.Shift(guiControl.ScaledPixel(175),guiControl.ScaledPixel(275));
   RE_Cur_TE.Text(AccountCurrency());
   RE_Cur_TE.FontSize(guiControl.GetsubFont_S());
   //RE_Cur_TE.ColorBackground(clrLightBlue);
   //Button Clr OnInit
   if(guiControl.GetTE() ==1) {
      RE_Per_TE.ColorBackground(clrLightBlue);
      RE_Cur_TE.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(guiControl.GetTE()==2) {
      RE_Per_TE.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_TE.ColorBackground(clrLightBlue);
   }
   
   //Label - RE_label_Total_Exp 
   RE_label_Total_Exp.Create(0,"RE_label_Total_Exp",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_Total_Exp);
   RE_label_Total_Exp.Text("Total Risk");
   RE_label_Total_Exp.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(272));
   RE_label_Total_Exp.FontSize(guiControl.GetMainFont_S());
   
   //Edit - RE_edit_Total_Exp 
   RE_edit_Total_Exp.Create(0,"RE_edit_Total_Exp",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_Total_Exp);
   RE_edit_Total_Exp.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(270));
   RE_edit_Total_Exp.ReadOnly(true);
   RE_edit_Total_Exp.FontSize(guiControl.GetMainFont_S());
   
   if(guiControl.GetTE() == 1) {
      if ((sumTradesExposure.GetTotalExpAcc() > riskSettings.GetMaxExpPer() && 
          riskSettings.GetMaxExpPer() != -1) ||
          ((riskSettings.GetMaxExpPer() != -1) && (sumTradesExposure.GetTotalExpAcc() == -10))) {
         RE_edit_Total_Exp.ColorBackground(clrTomato);
      }
      else RE_edit_Total_Exp.ColorBackground(clrWhiteSmoke);
   }
   
   if(guiControl.GetTE() == 2) {
      if ((sumTradesExposure.GetTotalExpCur() > riskSettings.GetMaxExpCur() && 
          riskSettings.GetMaxExpCur() != -1) ||
          ((riskSettings.GetMaxExpCur() != -1) && (sumTradesExposure.GetTotalExpAcc() == -10))) {
         RE_edit_Total_Exp.ColorBackground(clrTomato);
      }
      else RE_edit_Total_Exp.ColorBackground(clrWhiteSmoke);
   }
   
   //-------------------------
   //Total Currency Value of PositionSize
   //-------------------------
   //Label - RE_label_Total_PosVal
   RE_label_Total_PosVal.Create(0,"RE_label_Total_PosVal",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_Total_PosVal);
   RE_label_Total_PosVal.Text("Total " + AccountCurrency() + " Exposure");
   RE_label_Total_PosVal.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(302));
   RE_label_Total_PosVal.FontSize(guiControl.GetMainFont_S());
   
   //Edit - RE_edit_Total_PosVal
   RE_edit_Total_PosVal.Create(0,"RE_edit_Total_PosVal",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_Total_PosVal);
   RE_edit_Total_PosVal.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(300));
   RE_edit_Total_PosVal.ReadOnly(true);
   RE_edit_Total_PosVal.FontSize(guiControl.GetMainFont_S());
   
   if (sumTradesExposure.GetTotalPosVal() > riskSettings.GetMaxPosVal() && 
       riskSettings.GetMaxPosVal() != -1) {
      RE_edit_Total_PosVal.ColorBackground(clrTomato);
   }
   else RE_edit_Total_PosVal.ColorBackground(clrWhiteSmoke);
   
   //--------------------------------------------------------
   // Individual Trade Exposure
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label 
   //-------------------------
   RE_label_Trade_Select_int.Create(0,"RE_label_Trade_Select_int",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_Trade_Select_int);
   RE_label_Trade_Select_int.Text("Individual Trade Exposure");
   RE_label_Trade_Select_int.Shift(guiControl.ScaledPixel(100),guiControl.ScaledPixel(340));
   RE_label_Trade_Select_int.Color(clrMediumBlue);
   RE_label_Trade_Select_int.FontSize(guiControl.GetMainFont_S());

   //-------------------------
   //Choose Trade
   //-------------------------
   //Label RE_label_Trade_Select
   RE_label_Trade_Select.Create(0,"RE_label_Trade_Select",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_Trade_Select);
   RE_label_Trade_Select.Text("Select Trade");
   RE_label_Trade_Select.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(372));
   RE_label_Trade_Select.FontSize(guiControl.GetMainFont_S());
   
   //ComboBox - RE_CB_Trade_Expo
   RE_CB_Trade_Expo.Create(0,"RE_CB_Trade_Expo",0,0,0,guiControl.ScaledPixel(145),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_CB_Trade_Expo);
   RE_CB_Trade_Expo.Shift(guiControl.ScaledPixel(215),guiControl.ScaledPixel(370));
   //Add trades to CB
   indivialTradeExposure.AddToCB_Singular_Trades(RE_CB_Trade_Expo);
   
   //-------------------------
   //Singular Trade EXP in Currency or Account%
   //-------------------------
   //Label RE_label_Trade_Select
   RE_label_Trade_Exp.Create(0,"RE_label_Trade_Exp",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_Trade_Exp);
   RE_label_Trade_Exp.Text("Trade Risk");
   RE_label_Trade_Exp.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(402));
   RE_label_Trade_Exp.FontSize(guiControl.GetMainFont_S());
   
   //Edit RE_edit_Trade_Exp
   RE_edit_Trade_Exp.Create(0,"RE_edit_Trade_Exp",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_Trade_Exp);
   RE_edit_Trade_Exp.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(400));
   RE_edit_Trade_Exp.ReadOnly(true);
   RE_edit_Trade_Exp.ColorBackground(clrWhiteSmoke);
   RE_edit_Trade_Exp.FontSize(guiControl.GetMainFont_S());
   
   //Edit RE_edit_Trade_PosVal
   RE_edit_Trade_PosVal.Create(0,"RE_edit_Trade_PosVal",0,0,0,guiControl.ScaledPixel(105),guiControl.ScaledPixel(25));
   MainWindow.Add(RE_edit_Trade_PosVal);
   RE_edit_Trade_PosVal.Shift(guiControl.ScaledPixel(255),guiControl.ScaledPixel(430));
   RE_edit_Trade_PosVal.ReadOnly(true);
   RE_edit_Trade_PosVal.ColorBackground(clrWhiteSmoke);
   RE_edit_Trade_PosVal.FontSize(guiControl.GetMainFont_S());
   
   //Choose Currency or Account Percentage for Individual Trade Exposure
   //Currency 
   RE_Cur_ITE.Create(0,"RE_Cur_ITE",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   MainWindow.Add(RE_Cur_ITE);
   RE_Cur_ITE.Shift(guiControl.ScaledPixel(175),guiControl.ScaledPixel(405));
   RE_Cur_ITE.Text(AccountCurrency());
   RE_Cur_ITE.FontSize(guiControl.GetsubFont_S());
   //Account percentage
   RE_Per_ITE.Create(0,"RE_Per_ITE",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(17));
   MainWindow.Add(RE_Per_ITE);
   RE_Per_ITE.Shift(guiControl.ScaledPixel(125),guiControl.ScaledPixel(405));
   RE_Per_ITE.Text("Acc%");
   RE_Per_ITE.FontSize(guiControl.GetsubFont_S());
   //Button Clr OnInit
   if(guiControl.GetITE() ==1) {
      RE_Per_ITE.ColorBackground(clrLightBlue);
      RE_Cur_ITE.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(guiControl.GetITE() ==2) {
      RE_Per_ITE.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_ITE.ColorBackground(clrLightBlue);
   }
   
   //-------------------------
   //Singular Currency Value of PositionSize
   //-------------------------
   //Label RE_label_Trade_PosVal
   RE_label_Trade_PosVal.Create(0,"RE_label_Trade_PosVal",0,0,0,guiControl.ScaledPixel(45),guiControl.ScaledPixel(5));
   MainWindow.Add(RE_label_Trade_PosVal);
   RE_label_Trade_PosVal.Text(AccountCurrency() + " Exposure");
   RE_label_Trade_PosVal.Shift(guiControl.ScaledPixel(5),guiControl.ScaledPixel(432));
   RE_label_Trade_PosVal.FontSize(guiControl.GetMainFont_S());
   
   //****************************************************************
   //Set 1st Window
   //****************************************************************
   if (guiControl.GetCopyFirstWindow() == -1 || guiControl.GetCopyScale() != SCALE){
   
      //PositionSizeCalculator
      if(FirstWindow == PositionSizeCalculator) {

         guiControl.SetOPEN_TAB(1);
         guiControl.Hide_RE();
         guiControl.Show_PSC();
         MainWindow.Height(guiControl.GetPSC_Height());
         CopyRights.Shift(guiControl.ScaledPixel(5),guiControl.GetPSC_Height()-guiControl.ScaledPixel(50));
      }
      
      //RiskExposure
      if(FirstWindow == RiskExposure) {
      
         guiControl.SetOPEN_TAB(2);
         guiControl.Hide_PSC();
         guiControl.Show_RE();
         MainWindow.Height(guiControl.GetRE_Height());
         CopyRights.Shift(guiControl.ScaledPixel(5),guiControl.GetRE_Height()-guiControl.ScaledPixel(50));
      }   
      
      //Minimised
      if (FirstWindow == Minimised) {
         
         Min_Max.Pressed(true);
         guiControl.WindowMin(CopyRights,ButtonTabPSC,ButtonTabRisk,MainWindow);
         if (guiControl.GetOPEN_TAB() == 2) CopyRights.Shift(guiControl.ScaledPixel(5),guiControl.GetRE_Height()-guiControl.ScaledPixel(50));
         else CopyRights.Shift(guiControl.ScaledPixel(5),guiControl.GetPSC_Height()-guiControl.ScaledPixel(50));
      }
   }
   
   else {
   
      //PositionSizeCalculator
      if(guiControl.GetCopyFirstWindow() == PositionSizeCalculator) {

         guiControl.SetOPEN_TAB(1);
         guiControl.Hide_RE();
         guiControl.Show_PSC();
         MainWindow.Height(guiControl.GetPSC_Height());
         CopyRights.Shift(guiControl.ScaledPixel(5),guiControl.GetPSC_Height()-guiControl.ScaledPixel(50));
      }
      
      //RiskExposure
      if(guiControl.GetCopyFirstWindow() == RiskExposure) {
      
         guiControl.SetOPEN_TAB(2);
         guiControl.Hide_PSC();
         guiControl.Show_RE();
         MainWindow.Height(guiControl.GetRE_Height());
         CopyRights.Shift(guiControl.ScaledPixel(5),guiControl.GetRE_Height()-guiControl.ScaledPixel(50));
      }   
      
      //Minimised
      if (guiControl.GetCopyFirstWindow() == Minimised) {
         
         Min_Max.Pressed(true);
         guiControl.WindowMin(CopyRights,ButtonTabPSC,ButtonTabRisk,MainWindow);
         if (guiControl.GetOPEN_TAB() == 2) CopyRights.Shift(5,guiControl.GetRE_Height()-50);
         else CopyRights.Shift(guiControl.ScaledPixel(5),guiControl.GetPSC_Height()-guiControl.ScaledPixel(50));
      }
   }
   
   //****************************************************************
   //Run Everything on Main Window
   //****************************************************************
   MainWindow.Run();
   
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
      RE_edit_Total_Trades.ColorBackground(clrTomato);
   }
   else RE_edit_Total_Trades.ColorBackground(clrWhiteSmoke);
   
   //Number of Lots
   if (sumTradesExposure.GetTotalLots() > riskSettings.GetMaxLots() && 
       riskSettings.GetMaxLots() != -1) {
      RE_edit_Total_Lots.ColorBackground(clrTomato);
   }
   else RE_edit_Total_Lots.ColorBackground(clrWhiteSmoke);
   
   //Exposure in Currency or Account %
   if(guiControl.GetTE() ==1) {
      if ((sumTradesExposure.GetTotalExpAcc() > riskSettings.GetMaxExpPer() && 
          riskSettings.GetMaxExpPer() != -1) ||
          ((riskSettings.GetMaxExpPer() != -1) && (sumTradesExposure.GetTotalExpAcc() == -10))) {
         RE_edit_Total_Exp.ColorBackground(clrTomato);
      }
      else RE_edit_Total_Exp.ColorBackground(clrWhiteSmoke);
   }
   
   if(guiControl.GetTE() == 2) {
      if ((sumTradesExposure.GetTotalExpCur() > riskSettings.GetMaxExpCur() && 
          riskSettings.GetMaxExpCur() != -1) ||
          ((riskSettings.GetMaxExpCur() != -1) && (sumTradesExposure.GetTotalExpAcc() == -10))) {
         RE_edit_Total_Exp.ColorBackground(clrTomato);
      }
      else RE_edit_Total_Exp.ColorBackground(clrWhiteSmoke);
   }
   //Exposure in Position Size
   if (sumTradesExposure.GetTotalPosVal() > riskSettings.GetMaxPosVal() && 
       riskSettings.GetMaxPosVal() != -1) {
      RE_edit_Total_PosVal.ColorBackground(clrTomato);
   }
   else RE_edit_Total_PosVal.ColorBackground(clrWhiteSmoke);
   
   //..................................................
   //Calculate total trades 
   //..................................................
   sumTradesExposure.SetTotalTrades(OrdersTotal());
   RE_edit_Total_Trades.Text((string)sumTradesExposure.GetTotalTrades());
   
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
   RE_edit_Total_Lots.Text(DoubleToStr(sumTradesExposure.GetTotalLots(),2));
   
   //..................................................
   //Calculate Risk in Currency or Account Percentage 
   //..................................................
   sumTradesExposure.TotalExpAccAndCurr(guiControl, RE_edit_Total_Exp);
   
   //..................................................
   //Calculate Position Size value  
   //..................................................
   sumTradesExposure.Total_PosVal(RE_edit_Total_PosVal);
   
   //..................................................
   //Add Trades To combo Box  
   //..................................................
   if(sumTradesExposure.IsNewTrade()) { 
         
      RE_CB_Trade_Expo.ItemsClear();
      RE_edit_Trade_Exp.Text("");
      RE_edit_Trade_PosVal.Text("");
                 
      indivialTradeExposure.AddToCB_Singular_Trades(RE_CB_Trade_Expo);
   }
   
   //..................................................
   //Update values of Singular Trade 
   //..................................................
   //RE_CB_Trade_Expo.SelectByText()
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

   if (positionSizeCalculator.track_BidAsk(guiControl) == 2) {
      PSC_edit_Entry.Text((string)Bid);
      PSC_edit_Entry.Color(clrTomato);
      PSC_edit_Entry.ColorBackground(clrWhiteSmoke);
      PSC_edit_Entry.ReadOnly(true);
   }
   else if (positionSizeCalculator.track_BidAsk(guiControl) == 3) {
      PSC_edit_Entry.Text((string)Ask);
      PSC_edit_Entry.Color(clrMediumSeaGreen);
      PSC_edit_Entry.ColorBackground(clrWhiteSmoke);
      PSC_edit_Entry.ReadOnly(true);
   }
   else if (positionSizeCalculator.track_BidAsk(guiControl) == 3) { //Calculate button has been pressed 
      PSC_edit_Entry.Text(PSC_edit_Entry.Text()); 
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
   MainWindow.OnEvent(id,lparam,dparam,sparam);
   
   //Track OBJ Pressed
   if(id==CHARTEVENT_OBJECT_CLICK) guiControl.SetOBJ_CONTROL(ObjectGetString(0,sparam,OBJPROP_TEXT));
   
   //Mininmise Window
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Min_Max") {
   
      if(!Min_Max.Pressed()) guiControl.WindowMax();
      else guiControl.WindowMin(CopyRights,ButtonTabPSC,ButtonTabRisk,MainWindow);
   }
   
   //+---------------------------------------+
   //|Risk Exposure                          |
   //+---------------------------------------+
   
   //************************************
   //ButtonTabRisk
   //************************************
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="ButtonTabRisk") {
      if(!RE_label_Total_Trades.IsVisible()) {
      
         //Hide positionSizeCalculator
         guiControl.Hide_PSC();
         
         //Change the size of Window
         MainWindow.Height(guiControl.GetRE_Height());
         CopyRights.Shift(0,guiControl.GetRE_CR_Shift());
         
         //Show Risk Exposure
         guiControl.Show_RE();
         guiControl.SetOPEN_TAB(guiControl.Check_Tab(PSC_label_Risk_per_trade, RE_label_MAX_int));
      }   
   } 
   
   //************************************
   //Risk Settings
   //************************************
   //.......................
   //MAX TRADES (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_BMP_MAX_Trades") {
      if(RE_BMP_MAX_Trades.Pressed()) {
      
         RE_edit_MAX_Trades.ReadOnly(false);
         RE_edit_MAX_Trades.ColorBackground(clrWhite);
      }
      else {
         RE_edit_MAX_Trades.ReadOnly(true);
         RE_edit_MAX_Trades.Text("");
         riskSettings.SetMaxTrades(-1);
         RE_edit_MAX_Trades.ColorBackground(clrWhiteSmoke);
      }  
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="RE_edit_MAX_Trades"){
      
      string text  = RE_edit_MAX_Trades.Text();
      double value = StrToDouble(text);
      
      if (value <= 0) {
         
         RE_edit_MAX_Trades.Text("");
         RE_edit_MAX_Trades.ColorBackground(clrWhiteSmoke);
         RE_edit_MAX_Trades.ReadOnly(true);
         RE_BMP_MAX_Trades.Pressed(false);
         riskSettings.SetMaxTrades(-1);
      } 
      else {
      
         riskSettings.SetMaxTrades(value);
         RE_edit_MAX_Trades.Text(DoubleToString(riskSettings.GetMaxTrades(),0));
      } 
      
      RE_BMP_MAX_Trades.Pressed(false);
      RE_edit_MAX_Trades.ReadOnly(true); 
      RE_edit_MAX_Trades.ColorBackground(clrWhiteSmoke); 
   }
   
   //.......................
   //MAX Lots (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_BMP_MAX_Lots") {
      if(RE_BMP_MAX_Lots.Pressed()) {
         RE_edit_MAX_Lots.ReadOnly(false);
         RE_edit_MAX_Lots.ColorBackground(clrWhite);
      }
      else {
         RE_edit_MAX_Lots.ReadOnly(true);
         RE_edit_MAX_Lots.Text("");
         riskSettings.SetMaxLots(-1);
         RE_edit_MAX_Lots.ColorBackground(clrWhiteSmoke);
      }   
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="RE_edit_MAX_Lots"){
      
      string text  = RE_edit_MAX_Lots.Text();
      double value = StringToDouble(text);
      
      if (value <= 0) {
          
         RE_edit_MAX_Lots.Text("");
         RE_edit_MAX_Lots.ColorBackground(clrWhiteSmoke);
         RE_edit_MAX_Lots.ReadOnly(true);
         RE_BMP_MAX_Lots.Pressed(false);
         riskSettings.SetMaxLots(-1);
      }
      else {
      
         riskSettings.SetMaxLots(value);
         RE_edit_MAX_Lots.Text(DoubleToString(riskSettings.GetMaxLots(),2));
      }
      
      RE_BMP_MAX_Lots.Pressed(false);
      RE_edit_MAX_Lots.ReadOnly(true); 
      RE_edit_MAX_Lots.ColorBackground(clrWhiteSmoke);   
   }
   
   //.......................
   //MAX Currency Exposure (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_BMP_MAX_Exp") {
      if(RE_BMP_MAX_Exp.Pressed()) {
         RE_edit_MAX_Exp.ReadOnly(false);
         RE_edit_MAX_Exp.ColorBackground(clrWhite);
      }
      else {
         RE_edit_MAX_Exp.ReadOnly(true);
         RE_edit_MAX_Exp.Text("");
         riskSettings.SetMaxExpCur(-1);
         riskSettings.SetMaxExpPer(-1);
         RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke);
      }   
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="RE_edit_MAX_Exp"){
      if(guiControl.GetRS()==1){
      
         string text  = RE_edit_MAX_Exp.Text();
         double value = StrToDouble(text);
         
         if (value <= 0) {
             
            RE_edit_MAX_Exp.Text("");
            RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke);
            RE_edit_MAX_Exp.ReadOnly(true);
            RE_BMP_MAX_Exp.Pressed(false);
            riskSettings.SetMaxExpCur(-1);
            riskSettings.SetMaxExpPer(-1);
         } 
         
         else{
         
            riskSettings.SetMaxExpPer(value);
            riskSettings.SetMaxExpCur((AccountBalance()* riskSettings.GetMaxExpPer())/100);
            RE_edit_MAX_Exp.Text(DoubleToStr(riskSettings.GetMaxExpPer(),2)+" %");  
         }
         
         RE_BMP_MAX_Exp.Pressed(false);
         RE_edit_MAX_Exp.ReadOnly(true); 
         RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke); 
      
      }
      
      else if(guiControl.GetRS()==2){
            
         string text  = RE_edit_MAX_Exp.Text();
         double value = StrToDouble(text);
         
         if (value <= 0) {
             
            RE_edit_MAX_Exp.Text("");
            RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke);
            RE_edit_MAX_Exp.ReadOnly(true);
            RE_BMP_MAX_Exp.Pressed(false);
            riskSettings.SetMaxExpCur(-1);
            riskSettings.SetMaxExpPer(-1);
         } 
         
         else{
            
            riskSettings.SetMaxExpCur(value);
            riskSettings.SetMaxExpPer((riskSettings.GetMaxExpCur()*100)/AccountBalance());
            RE_edit_MAX_Exp.Text(DoubleToStr(riskSettings.GetMaxExpCur(),2)+" "+AccountCurrency());
         }
         
         RE_BMP_MAX_Exp.Pressed(false);
         RE_edit_MAX_Exp.ReadOnly(true); 
         RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke);  
      }
   }
   //.......................
   //MAX Position Value (Input by the user)
   //.......................
   
   //BMP Button
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_BMP_MAX_PosVal") {
      if(RE_BMP_MAX_PosVal.Pressed()) {
         RE_edit_MAX_PosVal.ReadOnly(false);
         RE_edit_MAX_PosVal.ColorBackground(clrWhite);
      }
      else {
         RE_edit_MAX_PosVal.ReadOnly(true);
         RE_edit_MAX_PosVal.Text("");
         riskSettings.SetMaxPosVal(-1);
         RE_edit_MAX_PosVal.ColorBackground(clrWhiteSmoke);
      }   
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="RE_edit_MAX_PosVal"){
      
      string text  = RE_edit_MAX_PosVal.Text();
      double value = StrToDouble(text);
      
      if (value <= 0) {
          
         RE_edit_MAX_PosVal.Text("");
         RE_edit_MAX_PosVal.ColorBackground(clrWhiteSmoke);
         RE_edit_MAX_PosVal.ReadOnly(true);
         RE_BMP_MAX_PosVal.Pressed(false);
         riskSettings.SetMaxPosVal(-1);
      }  
      else {
         riskSettings.SetMaxPosVal(value); 
         RE_BMP_MAX_PosVal.Pressed(false);
         RE_edit_MAX_PosVal.ReadOnly(true); 
         RE_edit_MAX_PosVal.ColorBackground(clrWhiteSmoke);  
         RE_edit_MAX_PosVal.Text(DoubleToStr(riskSettings.GetMaxPosVal(),2)+" "+AccountCurrency());
      }
   }
   
   //.......................
   // Currency or Account % Button
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Per_RS") {
      
      guiControl.SetRS(1);
      RE_Per_RS.ColorBackground(clrLightBlue);
      RE_Cur_RS.ColorBackground(C'0xF0,0xF0,0xF0');
      if(riskSettings.GetMaxExpPer()>0)RE_edit_MAX_Exp.Text(DoubleToStr(riskSettings.GetMaxExpPer(),2) + " %");
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Cur_RS") {
      
      guiControl.SetRS(2);
      RE_Per_RS.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_RS.ColorBackground(clrLightBlue);
      if(riskSettings.GetMaxExpCur()>0)RE_edit_MAX_Exp.Text(DoubleToStr(riskSettings.GetMaxExpCur(),2)+" "+AccountCurrency());
   } 
   
   //************************************
   //Total Exposure and Risk
   //************************************
   //.......................
   // Currency or Account % Button
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Per_TE") {
     
      guiControl.SetTE(1);
      RE_Per_TE.ColorBackground(clrLightBlue);
      RE_Cur_TE.ColorBackground(C'0xF0,0xF0,0xF0');
      
      if(sumTradesExposure.GetTotalExpAcc() == -10 || sumTradesExposure.GetTotalExpCur() == -10) {
      
        RE_edit_Total_Exp.FontSize(guiControl.GetsubFont_S());
        RE_edit_Total_Exp.Text("Use SL in All Trades!");
      }
      else {
      
         RE_edit_Total_Exp.FontSize(guiControl.GetMainFont_S());
         RE_edit_Total_Exp.Text(DoubleToStr(sumTradesExposure.GetTotalExpAcc(),2)+" %"); 
      }
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Cur_TE") {
      
      guiControl.SetTE(2);
      RE_Per_TE.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_TE.ColorBackground(clrLightBlue);
      
      
      if(sumTradesExposure.GetTotalExpAcc() == -10 || sumTradesExposure.GetTotalExpCur() == -10) {
      
        RE_edit_Total_Exp.FontSize(guiControl.GetsubFont_S());
        RE_edit_Total_Exp.Text("Use SL in All Trades!");
      }
         
      else {
      
         RE_edit_Total_Exp.FontSize(guiControl.GetMainFont_S());
         RE_edit_Total_Exp.Text(DoubleToStr(sumTradesExposure.GetTotalExpCur(),2)+" " +AccountCurrency());
      }
   }
   
   //************************************
   //Individual Trade Risk and Exposure
   //************************************
   //.......................
   // Currency or Account % Button
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Per_ITE") {
     
      guiControl.SetITE(1);
      RE_Per_ITE.ColorBackground(clrLightBlue);
      RE_Cur_ITE.ColorBackground(C'0xF0,0xF0,0xF0');
      if (indivialTradeExposure.GetSingularExp_Per() == -10 || indivialTradeExposure.GetSingularExp_Cur() == -10) {
         
         RE_edit_Trade_Exp.FontSize(guiControl.GetsubFont_S());
         RE_edit_Trade_Exp.Text("Trade with No SL!");
      }
      else {
      
         RE_edit_Trade_Exp.FontSize(guiControl.GetMainFont_S());
         RE_edit_Trade_Exp.Text(DoubleToStr(indivialTradeExposure.GetSingularExp_Per(),2)+" %");
      }
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Cur_ITE") {
   
      guiControl.SetITE(2); 
      RE_Per_ITE.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_ITE.ColorBackground(clrLightBlue);    
      if (indivialTradeExposure.GetSingularExp_Per() == -10 || indivialTradeExposure.GetSingularExp_Cur() == -10) {
      
         RE_edit_Trade_Exp.FontSize(guiControl.GetsubFont_S());
         RE_edit_Trade_Exp.Text("Trade with No SL!"); 
      }
      else {
      
         RE_edit_Trade_Exp.FontSize(guiControl.GetMainFont_S());
         RE_edit_Trade_Exp.Text(DoubleToStr(indivialTradeExposure.GetSingularExp_Cur(),2)+" " +AccountCurrency());
      }
   }
   
   //.......................
   // Combo Box
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && indivialTradeExposure.check_CB_TRADE(guiControl.GetOBJ_CONTROL())) {
      
      if(indivialTradeExposure.GetSingularTradesValues_Risk()) indivialTradeExposure.GetSingularTradesValues_PosVal();
   }
   
   //+---------------------------------------+
   //|Position Size Calculator               |
   //+---------------------------------------+
   
   //.......................
   //ButtonTabPSC
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="ButtonTabPSC") {
      if(!PSC_label_Risk_per_trade.IsVisible()) {
      
         //Hide Risk Exposure
         guiControl.Hide_RE();
         
         //Change the size of Window
         MainWindow.Height(guiControl.GetPSC_Height());
         CopyRights.Shift(0,guiControl.GetPSC_CR_Shift());
         
         //Show positionSizeCalculator
         guiControl.Show_PSC();
         guiControl.SetOPEN_TAB(guiControl.Check_Tab(PSC_label_Risk_per_trade, RE_label_MAX_int));
      }   
   } 
   
   //.......................
   //Entry Price Edit Box
   //.......................
   
   //----------------
   //Custom
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Price_Custom") {
      if(PSC_edit_Entry.ReadOnly() == true){
         PSC_edit_Entry.ColorBackground(clrWhite);
         PSC_edit_Entry.ReadOnly(false);
         PSC_edit_Entry.Color(clrBlack);
         
         //Empty Info of positionSizeCalculator
         PSC_edit_Risk_in_Points.Text("");
         PSC_edit_Risk_in_Currency.Text("");
         PSC_edit_Total_Units.Text("");
         PSC_edit_Total_Lots.Text("");
         PSC_edit_PosVal.Text("");
      }
      else {
         PSC_edit_Entry.ColorBackground(clrWhiteSmoke);
         PSC_edit_Entry.ReadOnly(true);
         PSC_edit_Entry.Text("");
         
         //Empty Info of positionSizeCalculator
         PSC_edit_Risk_in_Points.Text("");
         PSC_edit_Risk_in_Currency.Text("");
         PSC_edit_Total_Units.Text("");
         PSC_edit_Total_Lots.Text("");
         PSC_edit_PosVal.Text("");
      }   
   }
   
   //----------------
   //Entry Price - Bid
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Price_Bid") {
      PSC_edit_Entry.Text((string)Bid);
      PSC_edit_Entry.Color(clrTomato);
      PSC_edit_Entry.ColorBackground(clrWhiteSmoke);
      PSC_edit_Entry.ReadOnly(true);
      
      //Empty Info of positionSizeCalculator
      PSC_edit_Risk_in_Points.Text("");
      PSC_edit_Risk_in_Currency.Text("");
      PSC_edit_Total_Units.Text("");
      PSC_edit_Total_Lots.Text("");
      PSC_edit_PosVal.Text("");
   }
   
   //----------------
   //Entry Price - Ask
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Price_Ask") {
      PSC_edit_Entry.Text((string)Ask);
      PSC_edit_Entry.Color(clrMediumSeaGreen);
      PSC_edit_Entry.ColorBackground(clrWhiteSmoke);
      PSC_edit_Entry.ReadOnly(true);
      
      //Empty Info of positionSizeCalculator
      PSC_edit_Risk_in_Points.Text("");
      PSC_edit_Risk_in_Currency.Text("");
      PSC_edit_Total_Units.Text("");
      PSC_edit_Total_Lots.Text("");
      PSC_edit_PosVal.Text("");
   }
   
   //.......................
   //Calculate Button
   //.......................
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="ButtonCalculate") {
      
      if(positionSizeCalculator.Calculate_Lot(PSC_edit_Entry,
                           PSC_edit_SL,
                           PSC_edit_Risk_per_trade,
                           PSC_edit_Risk_in_Points,
                           PSC_edit_Risk_in_Currency,
                           PSC_edit_Total_Units,
                           PSC_edit_Total_Lots)) {
      
         positionSizeCalculator.Calculate_PosVal(PSC_edit_PosVal);
      }
   }
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

   //Entry Price Reset 
   PSC_edit_Entry.Text("");
   
   //Empty Info of positionSizeCalculator
   PSC_edit_Risk_in_Points.Text("");
   PSC_edit_Risk_in_Currency.Text("");
   PSC_edit_Total_Units.Text("");
   PSC_edit_Total_Lots.Text("");
   PSC_edit_PosVal.Text("");
   
   //Window Control
   if (PSC_label_Entry.IsVisible()) guiControl.SetCopyFirstWindow(PositionSizeCalculator);
   if (RE_label_MAX_int.IsVisible()) guiControl.SetCopyFirstWindow(RiskExposure);
   if (guiControl.IsMin(CopyRights)) guiControl.SetCopyFirstWindow(Minimised);
   
   guiControl.SetCopyScale(SCALE);

   //destroy timer
   EventKillTimer();
   
   //Destroy items from Memory
   MainWindow.Destroy(reason);
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Get Singular Trades Risk|
//+------------------------------------------------------------------+
bool CIndivialTradeExposure::GetSingularTradesValues_Risk (void) {

   RE_CB_Trade_Expo.SelectByText(guiControl.GetOBJ_CONTROL());
   
   string TRADES[2];
   
   StringSplit(guiControl.GetOBJ_CONTROL(), '_', TRADES);
   
   int P_TYPE;
   
   if      (TRADES[0] == "Long")        P_TYPE = OP_BUY;
   else if (TRADES[0] == "Short")       P_TYPE = OP_SELL;
   else if (TRADES[0] == "Long Limit")  P_TYPE = OP_BUYLIMIT;
   else if (TRADES[0] == "Long Stop")   P_TYPE = OP_BUYSTOP;
   else if (TRADES[0] == "Short Limit") P_TYPE = OP_SELLLIMIT;
   else if (TRADES[0] == "Short Stop")  P_TYPE = OP_SELLSTOP;
   else                                 P_TYPE = -1;   
   
   if(P_TYPE == -1) return false;
      
   for(int i=0; i < OrdersTotal(); i++) {
   
      if(OrderSelect(i, SELECT_BY_POS)) 
         if(OrderSymbol() == TRADES[1])
            if(OrderType() == P_TYPE) {
               
               //Order Succefully Selected
               string AccountCurr = AccountCurrency();
               string Profit_     = SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_PROFIT);
               
               //Entry And Exit Price
               double EntryPrice = OrderOpenPrice();
               double ExitPrice  = OrderStopLoss();
               
               //Points in risk
               double SL_points = MathAbs(EntryPrice - ExitPrice);
               
               //Trade Size
               double Lots    = OrderLots();
               double LotSize = SymbolInfoDouble(OrderSymbol(), SYMBOL_TRADE_CONTRACT_SIZE);
               double Units   = Lots * LotSize;
               
               //CurAcc------------------------------------------------------------------------
               //Risk in Currency
               double ExpInSymbolCurr;
               
               ExpInSymbolCurr = Units*SL_points;
               
               //Conversion
               bool accountSameAsCounterCurrency = AccountCurr == Profit_;
               double ConversitionRate; 
               
               if (accountSameAsCounterCurrency) ConversitionRate = 1.0;
               else {
                                            
                  ConversitionRate = iClose(AccountCurr + Profit_, PERIOD_D1, 1);
                  if (ConversitionRate == 0.0) {
                     
                     if (iClose(Profit_ + AccountCurr, PERIOD_D1, 1) == 0) ConversitionRate = 0.0;
                     else ConversitionRate = 1/iClose(Profit_ + AccountCurr, PERIOD_D1, 1);
                  }
                  if (ConversitionRate == 0.0) {
                  
                     //Error Checking
                     Print("Could not find Converstion Symbol! (Singular.Risk)");
                     int error = GetLastError();
                     Print("Singular.Risk - Conversion Rate error: " + (string)error + " " + OrderSymbol());
                     ResetLastError();
                  
                     return false;
                  }
               }
               
               //Print Additional Info
               Print("Singular.Risk - Conversion Pair: "+AccountCurr + Profit_+" at "+DoubleToStr(ConversitionRate,Digits));
               
               //CHECK IF TRADE IS IN PROFIT, IF IT IS THEN RISK IS ZERO
               bool BuyInProfit  = (OrderType() == OP_BUY || 
                                    OrderType() == OP_BUYLIMIT || 
                                    OrderType() == OP_BUYSTOP) &&
                                   (ExitPrice >= EntryPrice);
                                   
               bool SellInProfit = (OrderType() == OP_SELL || 
                                    OrderType() == OP_SELLLIMIT || 
                                    OrderType() == OP_SELLSTOP) &&
                                   (ExitPrice <= EntryPrice);
               
               if(BuyInProfit || SellInProfit) SingularExp_Cur = 0.0;
               else SingularExp_Cur = ExpInSymbolCurr/ConversitionRate; 
                                    
               SingularExp_Per = (SingularExp_Cur*100)/AccountBalance();
               
               //Display Results - Currency and Account %
               CheckTrade_withNoSL(guiControl.GetOBJ_CONTROL());
               
               if (SingularExp_Per == -10 || SingularExp_Cur == -10){
                  
                  if(guiControl.GetITE() == 2) {
                     RE_edit_Trade_Exp.FontSize(guiControl.GetsubFont_S());
                     RE_edit_Trade_Exp.Text("Trade with No SL!");
                  }
                  if(guiControl.GetITE() == 1) {
                     RE_edit_Trade_Exp.FontSize(guiControl.GetsubFont_S());
                     RE_edit_Trade_Exp.Text("Trade with No SL!");
                  }
               }
               else {
                  RE_edit_Trade_Exp.FontSize(guiControl.GetMainFont_S());
                  if(guiControl.GetITE() == 2) RE_edit_Trade_Exp.Text(DoubleToStr(SingularExp_Cur,2)+" " +AccountCurrency()); 
                  if(guiControl.GetITE() == 1) RE_edit_Trade_Exp.Text(DoubleToStr(SingularExp_Per,2)+" %");
               }                
            }
   }
   return true;
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Get Singular Trades PosVal|
//+------------------------------------------------------------------+
void CIndivialTradeExposure::GetSingularTradesValues_PosVal(void) {

   RE_CB_Trade_Expo.SelectByText(guiControl.GetOBJ_CONTROL());
   
   string TRADES[2];
   
   StringSplit(guiControl.GetOBJ_CONTROL(), '_', TRADES);
   
   int P_TYPE;
   
   if      (TRADES[0] == "Long")        P_TYPE = OP_BUY;
   else if (TRADES[0] == "Short")       P_TYPE = OP_SELL;
   else if (TRADES[0] == "Long Limit")  P_TYPE = OP_BUYLIMIT;
   else if (TRADES[0] == "Long Stop")   P_TYPE = OP_BUYSTOP;
   else if (TRADES[0] == "Short Limit") P_TYPE = OP_SELLLIMIT;
   else if (TRADES[0] == "Short Stop")  P_TYPE = OP_SELLSTOP;
   else                                 P_TYPE = -1;   
   
   if(P_TYPE == -1) return;
      
   for(int i=0; i < OrdersTotal(); i++) {
   
      if(OrderSelect(i, SELECT_BY_POS)) 
         if(OrderSymbol() == TRADES[1])
            if(OrderType() == P_TYPE) {
            
               //Order Succefully Selected
               string AccountCurr = AccountCurrency();
               string Profit_     = SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_PROFIT);
               string Base_ = SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_BASE);
               
               //Trade Size
               double Lots    = OrderLots();
               double LotSize = SymbolInfoDouble(OrderSymbol(), SYMBOL_TRADE_CONTRACT_SIZE);
               double Units   = Lots * LotSize;
   
               //Conversion
               bool accountSameAsBaseCurrency = AccountCurrency() == Base_;
               double ConversitionRate_; 
               
               if (accountSameAsBaseCurrency) ConversitionRate_ = 1.0;
               else {
                                            
                  ConversitionRate_ = iClose(Base_ + AccountCurrency(), PERIOD_D1, 1);
                  if (ConversitionRate_ == 0.0) {
                     
                     if (iClose(AccountCurrency()+Base_, PERIOD_D1, 1) == 0) ConversitionRate_ = 0.0;
                     else ConversitionRate_ = 1/iClose(AccountCurrency()+Base_, PERIOD_D1, 1);
                  }
                  if (ConversitionRate_ == 0.0) {
                  
                     //Error Checking
                     Print("Could not find Converstion Symbol! (Singular.Exposure)");
                     int error = GetLastError();
                     Print("Singular.Exposure - Conversion Rate error: " + (string)error + " " + OrderSymbol());
                     ResetLastError();
                  
                     return;
                  }
               }
               double singularPosVal = Base_ == Profit_ ? 
                                Units * ConversitionRate_ * iClose(OrderSymbol(), PERIOD_D1, 1) :
                                Units * ConversitionRate_;
                                
               //Print Additional Info
               Print("Singular.Exposure - Conversion Pair: "+Base_ + AccountCurrency()+" at "+DoubleToStr(ConversitionRate_,Digits));
               
               //Populate Edit Box
               RE_edit_Trade_PosVal.Text(DoubleToStr(singularPosVal,2)+" "+AccountCurrency());
            }
   }         
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Show positionSizeCalculator                           |
//+------------------------------------------------------------------+
void CGuiControl::Show_PSC(void) {

   PSC_label_Risk_per_trade.Show();
   PSC_edit_Risk_per_trade.Show();
   PSC_label_Entry.Show();
   PSC_edit_Entry.Show();
   Price_Custom.Show();
   Price_Bid.Show();
   Price_Ask.Show();
   PSC_label_SL.Show();
   PSC_edit_SL.Show();
   ButtonCalculate.Show();
   PSC_label_Risk_in_Points.Show();
   PSC_edit_Risk_in_Points.Show();
   PSC_label_Risk_in_Currency.Show();
   PSC_edit_Risk_in_Currency.Show();
   PSC_label_Contract_Size.Show();
   PSC_edit_Contract_Size.Show();
   PSC_label_Total_Units.Show();
   PSC_edit_Total_Units.Show();
   PSC_label_Total_Lots.Show();
   PSC_edit_Total_Lots.Show();
   PSC_label_PosVal.Show();
   PSC_edit_PosVal.Show();
} 

//+------------------------------------------------------------------+
//| Window Control Custom Class - Hide positionSizeCalculator                           |
//+------------------------------------------------------------------+
void CGuiControl::Hide_PSC(void) {

   PSC_label_Risk_per_trade.Hide();
   PSC_edit_Risk_per_trade.Hide();
   PSC_label_Entry.Hide();
   PSC_edit_Entry.Hide();
   Price_Custom.Hide();
   Price_Bid.Hide();
   Price_Ask.Hide();
   PSC_label_SL.Hide();
   PSC_edit_SL.Hide();
   ButtonCalculate.Hide();
   PSC_label_Risk_in_Points.Hide();
   PSC_edit_Risk_in_Points.Hide();
   PSC_label_Risk_in_Currency.Hide();
   PSC_edit_Risk_in_Currency.Hide();
   PSC_label_Contract_Size.Hide();
   PSC_edit_Contract_Size.Hide();
   PSC_label_Total_Units.Hide();
   PSC_edit_Total_Units.Hide();
   PSC_label_Total_Lots.Hide();
   PSC_edit_Total_Lots.Hide();
   PSC_label_PosVal.Hide();
   PSC_edit_PosVal.Hide();
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Show RE                            |
//+------------------------------------------------------------------+
void CGuiControl::Show_RE(void) {

   RE_label_MAX_int.Show();
   RE_label_MAX_Trades.Show();
   RE_edit_MAX_Trades.Show();
   RE_BMP_MAX_Trades.Show();
   RE_label_MAX_Lots.Show();
   RE_edit_MAX_Lots.Show();
   RE_BMP_MAX_Lots.Show();
   RE_label_MAX_Exp.Show();
   RE_edit_MAX_Exp.Show();
   RE_BMP_MAX_Exp.Show();
   RE_label_MAX_PosVal.Show();
   RE_edit_MAX_PosVal.Show();
   RE_BMP_MAX_PosVal.Show();
   RE_Cur_RS.Show();
   RE_Per_RS.Show();
   
   RE_label_total_Expo_int.Show();
   RE_label_Total_Trades.Show();
   RE_edit_Total_Trades.Show();
   RE_label_Total_Lots.Show();
   RE_edit_Total_Lots.Show();
   RE_label_Total_Exp.Show();
   RE_edit_Total_Exp.Show();
   RE_label_Total_PosVal.Show();
   RE_edit_Total_PosVal.Show();
   RE_Cur_TE.Show();
   RE_Per_TE.Show();
   
   RE_label_Trade_Select.Show();
   RE_CB_Trade_Expo.Show();
   RE_label_Trade_Exp.Show();
   RE_label_Trade_Select_int.Show();
   RE_edit_Trade_Exp.Show();
   RE_label_Trade_PosVal.Show();
   RE_edit_Trade_PosVal.Show();
   RE_Cur_ITE.Show();
   RE_Per_ITE.Show();
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Hide RE                            |
//+------------------------------------------------------------------+
void CGuiControl::Hide_RE(void) {

   RE_label_MAX_int.Hide();
   RE_label_MAX_Trades.Hide();
   RE_edit_MAX_Trades.Hide();
   RE_BMP_MAX_Trades.Hide();
   RE_label_MAX_Lots.Hide();
   RE_edit_MAX_Lots.Hide();
   RE_BMP_MAX_Lots.Hide();
   RE_label_MAX_Exp.Hide();
   RE_edit_MAX_Exp.Hide();
   RE_BMP_MAX_Exp.Hide();
   RE_label_MAX_PosVal.Hide();
   RE_edit_MAX_PosVal.Hide();
   RE_BMP_MAX_PosVal.Hide();
   RE_label_total_Expo_int.Hide();
   RE_Cur_RS.Hide();
   RE_Per_RS.Hide();
   
   RE_label_Total_Trades.Hide();
   RE_edit_Total_Trades.Hide();
   RE_label_Total_Lots.Hide();
   RE_edit_Total_Lots.Hide();
   RE_label_Total_Exp.Hide();
   RE_edit_Total_Exp.Hide();
   RE_label_Total_PosVal.Hide();
   RE_edit_Total_PosVal.Hide();
   RE_Cur_TE.Hide();
   RE_Per_TE.Hide();
   
   RE_label_Trade_Select.Hide();
   RE_CB_Trade_Expo.Hide();
   RE_label_Trade_Exp.Hide();
   RE_label_Trade_Select_int.Hide();
   RE_edit_Trade_Exp.Hide();
   RE_label_Trade_PosVal.Hide();
   RE_edit_Trade_PosVal.Hide();
   RE_Cur_ITE.Hide();
   RE_Per_ITE.Hide();
} 

//+------------------------------------------------------------------+
//| Window Control Custom Class - Maximise                           |
//+------------------------------------------------------------------+
void CGuiControl::WindowMax(void) {

   if(OPEN_TAB == 1) {
      MainWindow.Height(PSC_Height);
      Show_PSC();
      CopyRights.Show();
      ButtonTabPSC.Show();
      ButtonTabRisk.Show();
   }
   
   if(OPEN_TAB == 2) {
      MainWindow.Height(RE_Height);
      Show_RE();
      CopyRights.Show();
      ButtonTabPSC.Show();
      ButtonTabRisk.Show();
   }
}