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
//| Include MT4 Defined Libraries                                    |
//+------------------------------------------------------------------+
#include <Controls/DialogMyVersion.mqh>
#include <Controls/Button.mqh>   
#include <Controls/Label.mqh>
#include <Controls/ComboBox.mqh>  
#include <Controls/CheckGroup.mqh> 

//+------------------------------------------------------------------+
//| Include MT4 Defined Resources                                    |
//+------------------------------------------------------------------+
#resource "\\Include\\Controls\\res\\CheckBoxOff.bmp"  
#resource "\\Include\\Controls\\res\\CheckBoxOn.bmp"
#resource "\\Include\\Controls\\res\\Up.bmp"  
#resource "\\Include\\Controls\\res\\Down.bmp"

//+------------------------------------------------------------------+
//| Include MT4 Defined Libraries                                    |
//+------------------------------------------------------------------+
#include "CIndTraExp.mqh"
#include "CPosSizCal.mqh"
#include "CRiskSettings.mqh"
#include "CTotalExposure.mqh"
#include "CWinControl.mqh"

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
input string LicenceKey;
double contractsize;   

input double SCALE = 1.0; //Scale

//Window Control
             
extern Window FirstWindow = RiskExposure;




//+------------------------------------------------------------------+
//| Declaring Objects                                                |
//+------------------------------------------------------------------+

//------------------------------
//Custom Objects
//------------------------------
CPosSizCal     PSC;  //Position Size Calulator
CRiskSettings  RSet; //Risk Settings
CTotalExposure TR;   //Total Risk 
CIndTraExp     SinT; //Single Trade Risk
CWinControl    WCon; //Window Control

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

   //****************************************************************
   //Licence Validation 
   //****************************************************************
   string Pass;
   
   int Month_ = Month();
   
   switch (Month_) {
   
      case 1:  Pass = "AJVTVN"; break;
      case 2:  Pass = "6lNmwE"; break;
      case 3:  Pass = "bXdFYl"; break;
      case 4:  Pass = "hkRlls"; break;
      case 5:  Pass = "aGtSbG"; break;
      case 6:  Pass = "xzYUd0"; break;
      case 7:  Pass = "U2JHeH"; break;
      case 8:  Pass = "AbkGwa"; break;
      case 9:  Pass = "n0d3YT"; break;
      case 10: Pass = "BkM1lU"; break;
      case 11: Pass = "QmtNMW"; break;
      case 12: Pass = "RICARDO"; break;
   }
   
   if(Pass != LicenceKey) {
   
      PlaySound("alert2");
      MessageBox("Incorrect Licence Key - Please enter a valid key. For more information" + 
      " contact Alphachain Capital.","Invalid Licence",MB_OK);
      
      return(INIT_FAILED);
   }
   
   //****************************************************************
   //Manipulation of Global Variables 
   //****************************************************************
   contractsize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);
   
   //****************************************************************
   //Create Main Window
   //****************************************************************
   
   //Reset Constructor if needed, adjust if user changes scale during the execution of the program
   if(WCon.GetCopyScale() != SCALE) WCon.ResetContructor();
   
   if(WCon.GetCopyFirstWindow()==-1 || WCon.GetCopyScale() != SCALE) {
      MainWindow.Create(0,"MainWindow",0,0,0,WCon.GetMainWindowWidth(),WCon.GetRE_Height());        
      MainWindow.Shift(WCon.ScaledPixel(400),0);
   }
   
   //Remember the position of the windown when Changing Assets or TimeFrames
   else MainWindow.Create(0,
                          "MainWindow",
                          0,
                          MainWindow.Left(),
                          MainWindow.Top(),
                          WCon.GetMainWindowWidth()+MainWindow.Left(),
                          WCon.GetRE_Height()+MainWindow.Top());
   
   MainWindow.Caption("Alphachain Management Tool v1.00 BETA");
   ObjectSetInteger(0,MainWindow.Name()+"Caption",OBJPROP_FONTSIZE,WCon.GetMainFont_S());
   
   //CopyRights
   CopyRights.Create(0,"CopyRights",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(CopyRights);
   CopyRights.Text("©Alphachain");
   CopyRights.FontSize(WCon.GetMainFont_S());
   
   //Personalised Min/Max Button
   MainWindow.m_button_minmax.Hide();
   Min_Max.Create(0,"Min_Max",0,0,0,0,0);
   Min_Max.BmpNames("::Include\\Controls\\res\\Up.bmp",
                    "::Include\\Controls\\res\\Down.bmp"); 
   MainWindow.Add(Min_Max); 
   Min_Max.Shift(WCon.ScaledPixel(340),-18);
   
   //****************************************************************
   //Create Position Size Calculator Window
   //****************************************************************
   //-------------------------
   //Button - ButtonTabPSC  
   ButtonTabPSC.Create(0,
                      "ButtonTabPSC",
                      0,
                      WCon.ScaledPixel(5),
                      WCon.ScaledPixel(5),
                      WCon.ScaledPixel(180),
                      WCon.ScaledPixel(30));
                      
   ButtonTabPSC.Text("Position Size Calculator");
   MainWindow.Add(ButtonTabPSC);
   ButtonTabPSC.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Risk per trade
   //-------------------------
   //Label
   PSC_label_Risk_per_trade.Create(0,"PSC_label_Risk_per_trade",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));                         
   MainWindow.Add(PSC_label_Risk_per_trade);
   PSC_label_Risk_per_trade.Text("Risk On Trade (% of Account Balance)");
   PSC_label_Risk_per_trade.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(45));
   PSC_label_Risk_per_trade.FontSize(WCon.GetMainFont_S());
   
   //Edit box
   PSC_edit_Risk_per_trade.Create(0,"PSC_edit_Risk_per_trade",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));                
   MainWindow.Add(PSC_edit_Risk_per_trade);
   PSC_edit_Risk_per_trade.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(45));
   PSC_edit_Risk_per_trade.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Entry Price
   //-------------------------
   //Label
   PSC_label_Entry.Create(0,"PSC_label_Entry",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));                   
   MainWindow.Add(PSC_label_Entry);
   PSC_label_Entry.Text("Entry Price");
   PSC_label_Entry.Shift(WCon.ScaledPixel(5), WCon.ScaledPixel(75));                  
   PSC_label_Entry.FontSize(WCon.GetMainFont_S());
   
   //Edit box
   PSC_edit_Entry.Create(0,"PSC_edit_Entry",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Entry);
   PSC_edit_Entry.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(75));
   PSC_edit_Entry.ReadOnly(true);
   PSC_edit_Entry.ColorBackground(clrWhiteSmoke);
   PSC_edit_Entry.FontSize(WCon.GetMainFont_S());
   
   //Button - Custom 
   Price_Custom.Create(0,"Price_Custom",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(17));        
   MainWindow.Add(Price_Custom);
   Price_Custom.Shift(WCon.ScaledPixel(80),WCon.ScaledPixel(77));
   Price_Custom.Text("Custom");
   Price_Custom.FontSize(WCon.GetsubFont_S());
   Price_Custom.ColorBackground(clrLightBlue);
   
   //Button - Bid 
   Price_Bid.Create(0,"Price_Bid",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(17));
   MainWindow.Add(Price_Bid);
   Price_Bid.Shift(WCon.ScaledPixel(135),WCon.ScaledPixel(77));
   Price_Bid.Text("Bid");
   Price_Bid.FontSize(WCon.GetsubFont_S());
   Price_Bid.ColorBackground(clrTomato);
   
   //Button - Ask
   Price_Ask.Create(0,"Price_Ask",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(17));  
   MainWindow.Add(Price_Ask);
   Price_Ask.Shift(WCon.ScaledPixel(190),WCon.ScaledPixel(77));
   Price_Ask.Text("Ask");
   Price_Ask.FontSize(WCon.GetsubFont_S());
   Price_Ask.ColorBackground(clrMediumSeaGreen);
   
   //-------------------------
   //Stop Loss
   //-------------------------
   //Label
   PSC_label_SL.Create(0,"PSC_label_SL",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));  
   MainWindow.Add(PSC_label_SL);
   PSC_label_SL.Text("Stop Loss Price");
   PSC_label_SL.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(105));
   PSC_label_SL.FontSize(WCon.GetMainFont_S());
   
   //Edit box
   PSC_edit_SL.Create(0,"PSC_edit_SL",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(PSC_edit_SL);
   PSC_edit_SL.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(105));
   PSC_edit_SL.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Button - ButtonCalculate 
   //-------------------------
   ButtonCalculate.Create(0,"ButtonCalculate",0,0,0,WCon.ScaledPixel(75),WCon.ScaledPixel(25));
   MainWindow.Add(ButtonCalculate);
   ButtonCalculate.Shift(WCon.ScaledPixel(150),WCon.ScaledPixel(135));
   ButtonCalculate.Text("Calculate");
   ButtonCalculate.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Points
   //-------------------------
   //Label 
   PSC_label_Risk_in_Points.Create(0,"PSC_label_Risk_in_Points",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(PSC_label_Risk_in_Points);
   PSC_label_Risk_in_Points.Text("Risk in Points");
   PSC_label_Risk_in_Points.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(170));
   PSC_label_Risk_in_Points.FontSize(WCon.GetMainFont_S());
   
   //Edit box
   PSC_edit_Risk_in_Points.Create(0,"PSC_edit_Risk_in_Points",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Risk_in_Points);
   PSC_edit_Risk_in_Points.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(170));
   PSC_edit_Risk_in_Points.ReadOnly(true);
   PSC_edit_Risk_in_Points.ColorBackground(clrWhiteSmoke);
   PSC_edit_Risk_in_Points.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Risk_in_Currency
   //-------------------------
   //Label 
   PSC_label_Risk_in_Currency.Create(0,"PSC_label_Risk_in_Currency",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(PSC_label_Risk_in_Currency);
   PSC_label_Risk_in_Currency.Text("Risk in " + AccountCurrency());
   PSC_label_Risk_in_Currency.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(200));
   PSC_label_Risk_in_Currency.FontSize(WCon.GetMainFont_S());
   
   //Edit box
   PSC_edit_Risk_in_Currency.Create(0,"PSC_edit_Risk_in_Currency",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Risk_in_Currency);
   PSC_edit_Risk_in_Currency.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(200));
   PSC_edit_Risk_in_Currency.ReadOnly(true);
   PSC_edit_Risk_in_Currency.ColorBackground(clrWhiteSmoke);
   PSC_edit_Risk_in_Currency.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Contract_Size
   //-------------------------
   //Label
   PSC_label_Contract_Size.Create(0,"PSC_label_Contract_Size",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(PSC_label_Contract_Size);
   PSC_label_Contract_Size.Text("Contract Size");
   PSC_label_Contract_Size.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(230));
   PSC_label_Contract_Size.FontSize(WCon.GetMainFont_S());
   
   //Edit 
   PSC_edit_Contract_Size.Create(0,"PSC_edit_Contract_Size",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));       
   MainWindow.Add(PSC_edit_Contract_Size);
   PSC_edit_Contract_Size.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(230));
   PSC_edit_Contract_Size.ReadOnly(true);
   PSC_edit_Contract_Size.ColorBackground(clrGainsboro);
   PSC_edit_Contract_Size.Text((string)contractsize);
   PSC_edit_Contract_Size.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Total_Units
   //-------------------------
   //Label
   PSC_label_Total_Units.Create(0,"PSC_label_Total_Units",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(PSC_label_Total_Units);
   PSC_label_Total_Units.Text("Total Units");
   PSC_label_Total_Units.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(260));
   PSC_label_Total_Units.FontSize(WCon.GetMainFont_S());
   
   //Edit 
   PSC_edit_Total_Units.Create(0,"PSC_edit_Total_Units",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Total_Units);
   PSC_edit_Total_Units.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(260));
   PSC_edit_Total_Units.ReadOnly(true);
   PSC_edit_Total_Units.ColorBackground(clrWhiteSmoke);
   PSC_edit_Total_Units.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label
   PSC_label_Total_Lots.Create(0,"PSC_label_Total_Lots",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(PSC_label_Total_Lots);
   PSC_label_Total_Lots.Text("Total Lots");
   PSC_label_Total_Lots.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(290));
   PSC_label_Total_Lots.FontSize(WCon.GetMainFont_S());
   
   //Edit 
   PSC_edit_Total_Lots.Create(0,"PSC_edit_Total_Lots",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(PSC_edit_Total_Lots);
   PSC_edit_Total_Lots.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(290));
   PSC_edit_Total_Lots.ReadOnly(true);
   PSC_edit_Total_Lots.ColorBackground(clrGold);
   PSC_edit_Total_Lots.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Total PositionValue 
   //-------------------------
   //label
   PSC_label_PosVal.Create(0,"PSC_label_PosVal",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(PSC_label_PosVal);
   PSC_label_PosVal.Text(AccountCurrency()+" Exposure");
   PSC_label_PosVal.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(320));
   PSC_label_PosVal.FontSize(WCon.GetMainFont_S());
   
   //edit
   PSC_edit_PosVal.Create(0,"PSC_edit_PosVal",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(PSC_edit_PosVal);
   PSC_edit_PosVal.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(320));
   PSC_edit_PosVal.ReadOnly(true);
   PSC_edit_PosVal.ColorBackground(clrWhiteSmoke);
   PSC_edit_PosVal.FontSize(WCon.GetMainFont_S());
   
   //****************************************************************
   //Create Risk Exposure Window
   //****************************************************************
   //-------------------------
   //Button - ButtonTabRisk
   //-------------------------
   ButtonTabRisk.Create(0,"ButtonTabRisk",0,0,0,WCon.ScaledPixel(175),WCon.ScaledPixel(25));
   ButtonTabRisk.Text("Risk Exposure");
   ButtonTabRisk.FontSize(WCon.GetMainFont_S());
   MainWindow.Add(ButtonTabRisk);
   ButtonTabRisk.Shift(WCon.ScaledPixel(195),WCon.ScaledPixel(5));
   
   //--------------------------------------------------------
   // Risk Settings
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label
   //-------------------------
   RE_label_MAX_int.Create(0,"RE_label_MAX_int",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_int);
   RE_label_MAX_int.Text("Risk Settings");
   RE_label_MAX_int.Shift(WCon.ScaledPixel(145),WCon.ScaledPixel(45));
   RE_label_MAX_int.Color(clrMediumBlue);
   RE_label_MAX_int.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //MAX Settings Trades
   //-------------------------
   //Label
   RE_label_MAX_Trades.Create(0,"RE_label_MAX_Trades",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_Trades);
   RE_label_MAX_Trades.Text("MAX # Trades");
   RE_label_MAX_Trades.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(72));
   RE_label_MAX_Trades.FontSize(WCon.GetMainFont_S());
   
   //edit
   RE_edit_MAX_Trades.Create(0,"RE_edit_MAX_Trades",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_MAX_Trades);
   RE_edit_MAX_Trades.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(70));
   RE_edit_MAX_Trades.ReadOnly(true);
   RE_edit_MAX_Trades.ColorBackground(clrWhiteSmoke);
   RE_edit_MAX_Trades.FontSize(WCon.GetMainFont_S());
   if (RSet.GetMaxTrades() != -1) RE_edit_MAX_Trades.Text((string)RSet.GetMaxTrades());
   
   //bmp
   RE_BMP_MAX_Trades.Create(0,"RE_BMP_MAX_Trades",0,0,0,0,0);
   RE_BMP_MAX_Trades.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                              "::Include\\Controls\\res\\CheckBoxOn.bmp");
   MainWindow.Add(RE_BMP_MAX_Trades); 
   RE_BMP_MAX_Trades.Shift(WCon.ScaledPixel(230),WCon.ScaledPixel(75));
   
   //-------------------------
   //MAX Settings Lots
   //-------------------------
   //Label
   RE_label_MAX_Lots.Create(0,"RE_label_MAX_Lots",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_Lots);
   RE_label_MAX_Lots.Text("MAX Lots");
   RE_label_MAX_Lots.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(102));
   RE_label_MAX_Lots.FontSize(WCon.GetMainFont_S());
   
   //edit
   RE_edit_MAX_Lots.Create(0,"RE_edit_MAX_Lots",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_MAX_Lots);
   RE_edit_MAX_Lots.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(100));
   RE_edit_MAX_Lots.ReadOnly(true);
   RE_edit_MAX_Lots.ColorBackground(clrWhiteSmoke);
   RE_edit_MAX_Lots.FontSize(WCon.GetMainFont_S());
   if (RSet.GetMaxLots() != -1) RE_edit_MAX_Lots.Text((string)RSet.GetMaxLots());
   
   //bmp
   RE_BMP_MAX_Lots.Create(0,"RE_BMP_MAX_Lots",0,0,0,0,0);
   RE_BMP_MAX_Lots.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                            "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   MainWindow.Add(RE_BMP_MAX_Lots); 
   RE_BMP_MAX_Lots.Shift(WCon.ScaledPixel(230),WCon.ScaledPixel(105));
   
   //-------------------------
   //MAX Settings Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Risk Settings
   //Account percentage
   RE_Per_RS.Create(0,"RE_Per_RS",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(17));
   MainWindow.Add(RE_Per_RS);
   RE_Per_RS.Shift(WCon.ScaledPixel(125),WCon.ScaledPixel(135));
   RE_Per_RS.Text("Acc%");
   RE_Per_RS.FontSize(WCon.GetsubFont_S());
   //Currency 
   RE_Cur_RS.Create(0,"RE_Cur_RS",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(17));
   MainWindow.Add(RE_Cur_RS);
   RE_Cur_RS.Shift(WCon.ScaledPixel(175),WCon.ScaledPixel(135));
   RE_Cur_RS.Text(AccountCurrency());
   RE_Cur_RS.FontSize(WCon.GetsubFont_S());
   //Button Clr OnInit
   if(WCon.GetRS() ==1) {
      RE_Per_RS.ColorBackground(clrLightBlue);
      RE_Cur_RS.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(WCon.GetRS()==2){
      RE_Per_RS.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_RS.ColorBackground(clrLightBlue);
   }
   
   //Label
   RE_label_MAX_Exp.Create(0,"RE_label_MAX_Exp",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_Exp);
   RE_label_MAX_Exp.Text("MAX Risk");
   RE_label_MAX_Exp.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(132));
   RE_label_MAX_Exp.FontSize(WCon.GetMainFont_S());
   
   //edit Currency
   RE_edit_MAX_Exp.Create(0,"RE_edit_MAX_Exp",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_MAX_Exp);
   RE_edit_MAX_Exp.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(130));
   RE_edit_MAX_Exp.ReadOnly(true);
   RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke);
   if(WCon.GetRS() ==1) {
      if (RSet.GetMaxExpPer() != -1) 
         RE_edit_MAX_Exp.Text(DoubleToString(RSet.GetMaxExpPer(),2) + " %");
   }   
   if(WCon.GetRS()==2){
      if (RSet.GetMaxExpCur() != -1) 
         RE_edit_MAX_Exp.Text(DoubleToString(RSet.GetMaxExpCur(),2) + " "+AccountCurrency());
   }
   RE_edit_MAX_Exp.FontSize(WCon.GetMainFont_S());
   //bmp
   RE_BMP_MAX_Exp.Create(0,"RE_BMP_MAX_Exp",0,0,0,0,0);
   RE_BMP_MAX_Exp.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   MainWindow.Add(RE_BMP_MAX_Exp); 
   RE_BMP_MAX_Exp.Shift(WCon.ScaledPixel(230),WCon.ScaledPixel(135));
   
   //-------------------------
   //Max Currency Value of PositionSize
   //-------------------------
   //Label
   RE_label_MAX_PosVal.Create(0,"RE_label_MAX_PosVal",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_MAX_PosVal);
   RE_label_MAX_PosVal.Text("MAX " + AccountCurrency() + " Exposure");
   RE_label_MAX_PosVal.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(162));
   RE_label_MAX_PosVal.FontSize(WCon.GetMainFont_S());
   
   //bmp
   RE_BMP_MAX_PosVal.Create(0,"RE_BMP_MAX_PosVal",0,0,0,0,0);
   RE_BMP_MAX_PosVal.BmpNames("::Include\\Controls\\res\\CheckBoxOff.bmp",
                                   "::Include\\Controls\\res\\CheckBoxOn.bmp"); 
   MainWindow.Add(RE_BMP_MAX_PosVal); 
   RE_BMP_MAX_PosVal.Shift(WCon.ScaledPixel(230),WCon.ScaledPixel(165));
   
   //edit
   RE_edit_MAX_PosVal.Create(0,"RE_edit_MAX_PosVal",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_MAX_PosVal);
   RE_edit_MAX_PosVal.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(160));
   RE_edit_MAX_PosVal.ReadOnly(true);
   RE_edit_MAX_PosVal.ColorBackground(clrWhiteSmoke);
   RE_edit_MAX_PosVal.FontSize(WCon.GetMainFont_S());
   if (RSet.GetMaxPosVal() != -1) RE_edit_MAX_PosVal.Text((string)RSet.GetMaxPosVal() + " "+AccountCurrency());
   
   //--------------------------------------------------------
   // Total Exposure
   //--------------------------------------------------------
  
   //-------------------------
   //Introduction Label
   //-------------------------
   RE_label_total_Expo_int.Create(0,"RE_label_total_Expo_int",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   RE_label_total_Expo_int.Text("Total Exposure");
   MainWindow.Add(RE_label_total_Expo_int);
   RE_label_total_Expo_int.Shift(WCon.ScaledPixel(140),WCon.ScaledPixel(188));
   RE_label_total_Expo_int.Color(clrMediumBlue);
   RE_label_total_Expo_int.FontSize(WCon.GetMainFont_S());
   
   //-------------------------
   //Total_Trades
   //-------------------------
   //Label - RE_label_Total_Trades 
   RE_label_Total_Trades.Create(0,"RE_label_Total_Trades",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_Total_Trades);
   RE_label_Total_Trades.Text("Total Trades");
   RE_label_Total_Trades.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(212));
   RE_label_Total_Trades.FontSize(WCon.GetMainFont_S());
   
   //Edit - RE_edit_Total_Trades 
   RE_edit_Total_Trades.Create(0,"RE_edit_Total_Trades",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_Total_Trades);
   RE_edit_Total_Trades.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(210));
   RE_edit_Total_Trades.ReadOnly(true);
   RE_edit_Total_Trades.FontSize(WCon.GetMainFont_S());
   
   if (TR.GetTotalTrades() > RSet.GetMaxTrades() && 
       RSet.GetMaxTrades() != -1) {
      RE_edit_Total_Trades.ColorBackground(clrTomato);
   }
   else RE_edit_Total_Trades.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total_Lots
   //-------------------------
   //Label - RE_label_Total_Lots 
   RE_label_Total_Lots.Create(0,"RE_label_Total_Lots",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_Total_Lots);
   RE_label_Total_Lots.Text("Total Lots");
   RE_label_Total_Lots.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(242));
   RE_label_Total_Lots.FontSize(WCon.GetMainFont_S());
   
   //Edit - RE_edit_Total_Lots 
   RE_edit_Total_Lots.Create(0,"RE_edit_Total_Lots",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_Total_Lots);
   RE_edit_Total_Lots.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(240));
   RE_edit_Total_Lots.ReadOnly(true);
   RE_edit_Total_Lots.FontSize(WCon.GetMainFont_S());
   
   if (TR.GetTotalLots() > RSet.GetMaxLots() && 
       RSet.GetMaxLots() != -1) {
      RE_edit_Total_Lots.ColorBackground(clrTomato);
   }
   else RE_edit_Total_Lots.ColorBackground(clrWhiteSmoke);
   
   //-------------------------
   //Total Exp Currency or Account %
   //-------------------------
   
   //Choose Currency or Account Percentage for Total Exposure
   //Account percentage
   RE_Per_TE.Create(0,"RE_Per_TE",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(17));
   MainWindow.Add(RE_Per_TE);
   RE_Per_TE.Shift(WCon.ScaledPixel(125),WCon.ScaledPixel(275));
   RE_Per_TE.Text("Acc%");
   RE_Per_TE.FontSize(WCon.GetsubFont_S());
   //RE_Per_TE.ColorBackground(clrLightBlue);
   //Currency 
   RE_Cur_TE.Create(0,"RE_Cur_TE",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(17));
   MainWindow.Add(RE_Cur_TE);
   RE_Cur_TE.Shift(WCon.ScaledPixel(175),WCon.ScaledPixel(275));
   RE_Cur_TE.Text(AccountCurrency());
   RE_Cur_TE.FontSize(WCon.GetsubFont_S());
   //RE_Cur_TE.ColorBackground(clrLightBlue);
   //Button Clr OnInit
   if(WCon.GetTE() ==1) {
      RE_Per_TE.ColorBackground(clrLightBlue);
      RE_Cur_TE.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(WCon.GetTE()==2) {
      RE_Per_TE.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_TE.ColorBackground(clrLightBlue);
   }
   
   //Label - RE_label_Total_Exp 
   RE_label_Total_Exp.Create(0,"RE_label_Total_Exp",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_Total_Exp);
   RE_label_Total_Exp.Text("Total Risk");
   RE_label_Total_Exp.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(272));
   RE_label_Total_Exp.FontSize(WCon.GetMainFont_S());
   
   //Edit - RE_edit_Total_Exp 
   RE_edit_Total_Exp.Create(0,"RE_edit_Total_Exp",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_Total_Exp);
   RE_edit_Total_Exp.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(270));
   RE_edit_Total_Exp.ReadOnly(true);
   RE_edit_Total_Exp.FontSize(WCon.GetMainFont_S());
   
   if(WCon.GetTE() == 1) {
      if ((TR.GetTotalExpAcc() > RSet.GetMaxExpPer() && 
          RSet.GetMaxExpPer() != -1) ||
          ((RSet.GetMaxExpPer() != -1) && (TR.GetTotalExpAcc() == -10))) {
         RE_edit_Total_Exp.ColorBackground(clrTomato);
      }
      else RE_edit_Total_Exp.ColorBackground(clrWhiteSmoke);
   }
   
   if(WCon.GetTE() == 2) {
      if ((TR.GetTotalExpCur() > RSet.GetMaxExpCur() && 
          RSet.GetMaxExpCur() != -1) ||
          ((RSet.GetMaxExpCur() != -1) && (TR.GetTotalExpAcc() == -10))) {
         RE_edit_Total_Exp.ColorBackground(clrTomato);
      }
      else RE_edit_Total_Exp.ColorBackground(clrWhiteSmoke);
   }
   
   //-------------------------
   //Total Currency Value of PositionSize
   //-------------------------
   //Label - RE_label_Total_PosVal
   RE_label_Total_PosVal.Create(0,"RE_label_Total_PosVal",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_Total_PosVal);
   RE_label_Total_PosVal.Text("Total " + AccountCurrency() + " Exposure");
   RE_label_Total_PosVal.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(302));
   RE_label_Total_PosVal.FontSize(WCon.GetMainFont_S());
   
   //Edit - RE_edit_Total_PosVal
   RE_edit_Total_PosVal.Create(0,"RE_edit_Total_PosVal",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_Total_PosVal);
   RE_edit_Total_PosVal.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(300));
   RE_edit_Total_PosVal.ReadOnly(true);
   RE_edit_Total_PosVal.FontSize(WCon.GetMainFont_S());
   
   if (TR.GetTotalPosVal() > RSet.GetMaxPosVal() && 
       RSet.GetMaxPosVal() != -1) {
      RE_edit_Total_PosVal.ColorBackground(clrTomato);
   }
   else RE_edit_Total_PosVal.ColorBackground(clrWhiteSmoke);
   
   //--------------------------------------------------------
   // Individual Trade Exposure
   //--------------------------------------------------------
   
   //-------------------------
   //Introduction Label 
   //-------------------------
   RE_label_Trade_Select_int.Create(0,"RE_label_Trade_Select_int",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_Trade_Select_int);
   RE_label_Trade_Select_int.Text("Individual Trade Exposure");
   RE_label_Trade_Select_int.Shift(WCon.ScaledPixel(100),WCon.ScaledPixel(340));
   RE_label_Trade_Select_int.Color(clrMediumBlue);
   RE_label_Trade_Select_int.FontSize(WCon.GetMainFont_S());

   //-------------------------
   //Choose Trade
   //-------------------------
   //Label RE_label_Trade_Select
   RE_label_Trade_Select.Create(0,"RE_label_Trade_Select",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_Trade_Select);
   RE_label_Trade_Select.Text("Select Trade");
   RE_label_Trade_Select.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(372));
   RE_label_Trade_Select.FontSize(WCon.GetMainFont_S());
   
   //ComboBox - RE_CB_Trade_Expo
   RE_CB_Trade_Expo.Create(0,"RE_CB_Trade_Expo",0,0,0,WCon.ScaledPixel(145),WCon.ScaledPixel(25));
   MainWindow.Add(RE_CB_Trade_Expo);
   RE_CB_Trade_Expo.Shift(WCon.ScaledPixel(215),WCon.ScaledPixel(370));
   //Add trades to CB
   SinT.AddToCB_Singular_Trades();
   
   //-------------------------
   //Singular Trade EXP in Currency or Account%
   //-------------------------
   //Label RE_label_Trade_Select
   RE_label_Trade_Exp.Create(0,"RE_label_Trade_Exp",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_Trade_Exp);
   RE_label_Trade_Exp.Text("Trade Risk");
   RE_label_Trade_Exp.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(402));
   RE_label_Trade_Exp.FontSize(WCon.GetMainFont_S());
   
   //Edit RE_edit_Trade_Exp
   RE_edit_Trade_Exp.Create(0,"RE_edit_Trade_Exp",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_Trade_Exp);
   RE_edit_Trade_Exp.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(400));
   RE_edit_Trade_Exp.ReadOnly(true);
   RE_edit_Trade_Exp.ColorBackground(clrWhiteSmoke);
   RE_edit_Trade_Exp.FontSize(WCon.GetMainFont_S());
   
   //Edit RE_edit_Trade_PosVal
   RE_edit_Trade_PosVal.Create(0,"RE_edit_Trade_PosVal",0,0,0,WCon.ScaledPixel(105),WCon.ScaledPixel(25));
   MainWindow.Add(RE_edit_Trade_PosVal);
   RE_edit_Trade_PosVal.Shift(WCon.ScaledPixel(255),WCon.ScaledPixel(430));
   RE_edit_Trade_PosVal.ReadOnly(true);
   RE_edit_Trade_PosVal.ColorBackground(clrWhiteSmoke);
   RE_edit_Trade_PosVal.FontSize(WCon.GetMainFont_S());
   
   //Choose Currency or Account Percentage for Individual Trade Exposure
   //Currency 
   RE_Cur_ITE.Create(0,"RE_Cur_ITE",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(17));
   MainWindow.Add(RE_Cur_ITE);
   RE_Cur_ITE.Shift(WCon.ScaledPixel(175),WCon.ScaledPixel(405));
   RE_Cur_ITE.Text(AccountCurrency());
   RE_Cur_ITE.FontSize(WCon.GetsubFont_S());
   //Account percentage
   RE_Per_ITE.Create(0,"RE_Per_ITE",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(17));
   MainWindow.Add(RE_Per_ITE);
   RE_Per_ITE.Shift(WCon.ScaledPixel(125),WCon.ScaledPixel(405));
   RE_Per_ITE.Text("Acc%");
   RE_Per_ITE.FontSize(WCon.GetsubFont_S());
   //Button Clr OnInit
   if(WCon.GetITE() ==1) {
      RE_Per_ITE.ColorBackground(clrLightBlue);
      RE_Cur_ITE.ColorBackground(C'0xF0,0xF0,0xF0');
   }
   if(WCon.GetITE() ==2) {
      RE_Per_ITE.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_ITE.ColorBackground(clrLightBlue);
   }
   
   //-------------------------
   //Singular Currency Value of PositionSize
   //-------------------------
   //Label RE_label_Trade_PosVal
   RE_label_Trade_PosVal.Create(0,"RE_label_Trade_PosVal",0,0,0,WCon.ScaledPixel(45),WCon.ScaledPixel(5));
   MainWindow.Add(RE_label_Trade_PosVal);
   RE_label_Trade_PosVal.Text(AccountCurrency() + " Exposure");
   RE_label_Trade_PosVal.Shift(WCon.ScaledPixel(5),WCon.ScaledPixel(432));
   RE_label_Trade_PosVal.FontSize(WCon.GetMainFont_S());
   
   //****************************************************************
   //Set 1st Window
   //****************************************************************
   if (WCon.GetCopyFirstWindow() == -1 || WCon.GetCopyScale() != SCALE){
   
      //PositionSizeCalculator
      if(FirstWindow == PositionSizeCalculator) {

         WCon.SetOPEN_TAB(1);
         WCon.Hide_RE();
         WCon.Show_PSC();
         MainWindow.Height(WCon.GetPSC_Height());
         CopyRights.Shift(WCon.ScaledPixel(5),WCon.GetPSC_Height()-WCon.ScaledPixel(50));
      }
      
      //RiskExposure
      if(FirstWindow == RiskExposure) {
      
         WCon.SetOPEN_TAB(2);
         WCon.Hide_PSC();
         WCon.Show_RE();
         MainWindow.Height(WCon.GetRE_Height());
         CopyRights.Shift(WCon.ScaledPixel(5),WCon.GetRE_Height()-WCon.ScaledPixel(50));
      }   
      
      //Minimised
      if (FirstWindow == Minimised) {
         
         Min_Max.Pressed(true);
         WCon.WindowMin();
         if (WCon.GetOPEN_TAB() == 2) CopyRights.Shift(WCon.ScaledPixel(5),WCon.GetRE_Height()-WCon.ScaledPixel(50));
         else CopyRights.Shift(WCon.ScaledPixel(5),WCon.GetPSC_Height()-WCon.ScaledPixel(50));
      }
   }
   
   else {
   
      //PositionSizeCalculator
      if(WCon.GetCopyFirstWindow() == PositionSizeCalculator) {

         WCon.SetOPEN_TAB(1);
         WCon.Hide_RE();
         WCon.Show_PSC();
         MainWindow.Height(WCon.GetPSC_Height());
         CopyRights.Shift(WCon.ScaledPixel(5),WCon.GetPSC_Height()-WCon.ScaledPixel(50));
      }
      
      //RiskExposure
      if(WCon.GetCopyFirstWindow() == RiskExposure) {
      
         WCon.SetOPEN_TAB(2);
         WCon.Hide_PSC();
         WCon.Show_RE();
         MainWindow.Height(WCon.GetRE_Height());
         CopyRights.Shift(WCon.ScaledPixel(5),WCon.GetRE_Height()-WCon.ScaledPixel(50));
      }   
      
      //Minimised
      if (WCon.GetCopyFirstWindow() == Minimised) {
         
         Min_Max.Pressed(true);
         WCon.WindowMin();
         if (WCon.GetOPEN_TAB() == 2) CopyRights.Shift(5,WCon.GetRE_Height()-50);
         else CopyRights.Shift(WCon.ScaledPixel(5),WCon.GetPSC_Height()-WCon.ScaledPixel(50));
      }
   }
   
   //****************************************************************
   //Run Everything on Main Window
   //****************************************************************
   MainWindow.Run();
   
//--- create timer
   EventSetTimer(1);
   WCon.SetCopyScale(SCALE);
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
   if (TR.GetTotalTrades() > RSet.GetMaxTrades() && 
       RSet.GetMaxTrades() != -1) {
      RE_edit_Total_Trades.ColorBackground(clrTomato);
   }
   else RE_edit_Total_Trades.ColorBackground(clrWhiteSmoke);
   
   //Number of Lots
   if (TR.GetTotalLots() > RSet.GetMaxLots() && 
       RSet.GetMaxLots() != -1) {
      RE_edit_Total_Lots.ColorBackground(clrTomato);
   }
   else RE_edit_Total_Lots.ColorBackground(clrWhiteSmoke);
   
   //Exposure in Currency or Account %
   if(WCon.GetTE() ==1) {
      if ((TR.GetTotalExpAcc() > RSet.GetMaxExpPer() && 
          RSet.GetMaxExpPer() != -1) ||
          ((RSet.GetMaxExpPer() != -1) && (TR.GetTotalExpAcc() == -10))) {
         RE_edit_Total_Exp.ColorBackground(clrTomato);
      }
      else RE_edit_Total_Exp.ColorBackground(clrWhiteSmoke);
   }
   
   if(WCon.GetTE() == 2) {
      if ((TR.GetTotalExpCur() > RSet.GetMaxExpCur() && 
          RSet.GetMaxExpCur() != -1) ||
          ((RSet.GetMaxExpCur() != -1) && (TR.GetTotalExpAcc() == -10))) {
         RE_edit_Total_Exp.ColorBackground(clrTomato);
      }
      else RE_edit_Total_Exp.ColorBackground(clrWhiteSmoke);
   }
   //Exposure in Position Size
   if (TR.GetTotalPosVal() > RSet.GetMaxPosVal() && 
       RSet.GetMaxPosVal() != -1) {
      RE_edit_Total_PosVal.ColorBackground(clrTomato);
   }
   else RE_edit_Total_PosVal.ColorBackground(clrWhiteSmoke);
   
   //..................................................
   //Calculate total trades 
   //..................................................
   TR.SetTotalTrades(OrdersTotal());
   RE_edit_Total_Trades.Text((string)TR.GetTotalTrades());
   
   //..................................................
   //Calculate total Lots 
   //..................................................
   double Total_lots = 0.0;
   
   //Get Total Lots
   for(int i=0; i < OrdersTotal(); i++) {
      
      if(OrderSelect(i, SELECT_BY_POS))
         Total_lots += OrderLots();
   }
   
   TR.SetTotalLots(Total_lots);
   RE_edit_Total_Lots.Text(DoubleToStr(TR.GetTotalLots(),2));
   
   //..................................................
   //Calculate Risk in Currency or Account Percentage 
   //..................................................
   TR.TotalExpAccAndCurr();
   
   //..................................................
   //Calculate Position Size value  
   //..................................................
   TR.Total_PosVal();
   
   //..................................................
   //Add Trades To combo Box  
   //..................................................
   if(TR.IsNewTrade()) { 
         
         RE_CB_Trade_Expo.ItemsClear();
         RE_edit_Trade_Exp.Text("");
         RE_edit_Trade_PosVal.Text("");
                 
         SinT.AddToCB_Singular_Trades();
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

   if (PSC.track_BidAsk() == 2) {
      PSC_edit_Entry.Text((string)Bid);
      PSC_edit_Entry.Color(clrTomato);
      PSC_edit_Entry.ColorBackground(clrWhiteSmoke);
      PSC_edit_Entry.ReadOnly(true);
   }
   else if (PSC.track_BidAsk() == 3) {
      PSC_edit_Entry.Text((string)Ask);
      PSC_edit_Entry.Color(clrMediumSeaGreen);
      PSC_edit_Entry.ColorBackground(clrWhiteSmoke);
      PSC_edit_Entry.ReadOnly(true);
   }
   else if (PSC.track_BidAsk() == 3) { //Calculate button has been pressed 
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
   if(id==CHARTEVENT_OBJECT_CLICK) WCon.SetOBJ_CONTROL(ObjectGetString(0,sparam,OBJPROP_TEXT));
   
   //Mininmise Window
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="Min_Max") {
   
      if(!Min_Max.Pressed()) WCon.WindowMax();
      else WCon.WindowMin();
   }
   
   //+---------------------------------------+
   //|Risk Exposure                          |
   //+---------------------------------------+
   
   //************************************
   //ButtonTabRisk
   //************************************
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="ButtonTabRisk") {
      if(!RE_label_Total_Trades.IsVisible()) {
      
         //Hide PSC
         WCon.Hide_PSC();
         
         //Change the size of Window
         MainWindow.Height(WCon.GetRE_Height());
         CopyRights.Shift(0,WCon.GetRE_CR_Shift());
         
         //Show Risk Exposure
         WCon.Show_RE();
         WCon.SetOPEN_TAB(WCon.Check_Tab());
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
         RSet.SetMaxTrades(-1);
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
         RSet.SetMaxTrades(-1);
      } 
      else {
      
         RSet.SetMaxTrades(value);
         RE_edit_MAX_Trades.Text(DoubleToString(RSet.GetMaxTrades(),0));
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
         RSet.SetMaxLots(-1);
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
         RSet.SetMaxLots(-1);
      }
      else {
      
         RSet.SetMaxLots(value);
         RE_edit_MAX_Lots.Text(DoubleToString(RSet.GetMaxLots(),2));
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
         RSet.SetMaxExpCur(-1);
         RSet.SetMaxExpPer(-1);
         RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke);
      }   
   }
   
   //Edit Box
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam=="RE_edit_MAX_Exp"){
      if(WCon.GetRS()==1){
      
         string text  = RE_edit_MAX_Exp.Text();
         double value = StrToDouble(text);
         
         if (value <= 0) {
             
            RE_edit_MAX_Exp.Text("");
            RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke);
            RE_edit_MAX_Exp.ReadOnly(true);
            RE_BMP_MAX_Exp.Pressed(false);
            RSet.SetMaxExpCur(-1);
            RSet.SetMaxExpPer(-1);
         } 
         
         else{
         
            RSet.SetMaxExpPer(value);
            RSet.SetMaxExpCur((AccountBalance()* RSet.GetMaxExpPer())/100);
            RE_edit_MAX_Exp.Text(DoubleToStr(RSet.GetMaxExpPer(),2)+" %");  
         }
         
         RE_BMP_MAX_Exp.Pressed(false);
         RE_edit_MAX_Exp.ReadOnly(true); 
         RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke); 
      
      }
      
      else if(WCon.GetRS()==2){
            
         string text  = RE_edit_MAX_Exp.Text();
         double value = StrToDouble(text);
         
         if (value <= 0) {
             
            RE_edit_MAX_Exp.Text("");
            RE_edit_MAX_Exp.ColorBackground(clrWhiteSmoke);
            RE_edit_MAX_Exp.ReadOnly(true);
            RE_BMP_MAX_Exp.Pressed(false);
            RSet.SetMaxExpCur(-1);
            RSet.SetMaxExpPer(-1);
         } 
         
         else{
            
            RSet.SetMaxExpCur(value);
            RSet.SetMaxExpPer((RSet.GetMaxExpCur()*100)/AccountBalance());
            RE_edit_MAX_Exp.Text(DoubleToStr(RSet.GetMaxExpCur(),2)+" "+AccountCurrency());
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
         RSet.SetMaxPosVal(-1);
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
         RSet.SetMaxPosVal(-1);
      }  
      else {
         RSet.SetMaxPosVal(value); 
         RE_BMP_MAX_PosVal.Pressed(false);
         RE_edit_MAX_PosVal.ReadOnly(true); 
         RE_edit_MAX_PosVal.ColorBackground(clrWhiteSmoke);  
         RE_edit_MAX_PosVal.Text(DoubleToStr(RSet.GetMaxPosVal(),2)+" "+AccountCurrency());
      }
   }
   
   //.......................
   // Currency or Account % Button
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Per_RS") {
      
      WCon.SetRS(1);
      RE_Per_RS.ColorBackground(clrLightBlue);
      RE_Cur_RS.ColorBackground(C'0xF0,0xF0,0xF0');
      if(RSet.GetMaxExpPer()>0)RE_edit_MAX_Exp.Text(DoubleToStr(RSet.GetMaxExpPer(),2) + " %");
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Cur_RS") {
      
      WCon.SetRS(2);
      RE_Per_RS.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_RS.ColorBackground(clrLightBlue);
      if(RSet.GetMaxExpCur()>0)RE_edit_MAX_Exp.Text(DoubleToStr(RSet.GetMaxExpCur(),2)+" "+AccountCurrency());
   } 
   
   //************************************
   //Total Exposure and Risk
   //************************************
   //.......................
   // Currency or Account % Button
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Per_TE") {
     
      WCon.SetTE(1);
      RE_Per_TE.ColorBackground(clrLightBlue);
      RE_Cur_TE.ColorBackground(C'0xF0,0xF0,0xF0');
      
      if(TR.GetTotalExpAcc() == -10 || TR.GetTotalExpCur() == -10) {
      
        RE_edit_Total_Exp.FontSize(WCon.GetsubFont_S());
        RE_edit_Total_Exp.Text("Use SL in All Trades!");
      }
      else {
      
         RE_edit_Total_Exp.FontSize(WCon.GetMainFont_S());
         RE_edit_Total_Exp.Text(DoubleToStr(TR.GetTotalExpAcc(),2)+" %"); 
      }
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Cur_TE") {
      
      WCon.SetTE(2);
      RE_Per_TE.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_TE.ColorBackground(clrLightBlue);
      
      
      if(TR.GetTotalExpAcc() == -10 || TR.GetTotalExpCur() == -10) {
      
        RE_edit_Total_Exp.FontSize(WCon.GetsubFont_S());
        RE_edit_Total_Exp.Text("Use SL in All Trades!");
      }
         
      else {
      
         RE_edit_Total_Exp.FontSize(WCon.GetMainFont_S());
         RE_edit_Total_Exp.Text(DoubleToStr(TR.GetTotalExpCur(),2)+" " +AccountCurrency());
      }
   }
   
   //************************************
   //Individual Trade Risk and Exposure
   //************************************
   //.......................
   // Currency or Account % Button
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Per_ITE") {
     
      WCon.SetITE(1);
      RE_Per_ITE.ColorBackground(clrLightBlue);
      RE_Cur_ITE.ColorBackground(C'0xF0,0xF0,0xF0');
      if (SinT.GetSingularExp_Per() == -10 || SinT.GetSingularExp_Cur() == -10) {
         
         RE_edit_Trade_Exp.FontSize(WCon.GetsubFont_S());
         RE_edit_Trade_Exp.Text("Trade with No SL!");
      }
      else {
      
         RE_edit_Trade_Exp.FontSize(WCon.GetMainFont_S());
         RE_edit_Trade_Exp.Text(DoubleToStr(SinT.GetSingularExp_Per(),2)+" %");
      }
   }
   
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="RE_Cur_ITE") {
   
      WCon.SetITE(2); 
      RE_Per_ITE.ColorBackground(C'0xF0,0xF0,0xF0');
      RE_Cur_ITE.ColorBackground(clrLightBlue);    
      if (SinT.GetSingularExp_Per() == -10 || SinT.GetSingularExp_Cur() == -10) {
      
         RE_edit_Trade_Exp.FontSize(WCon.GetsubFont_S());
         RE_edit_Trade_Exp.Text("Trade with No SL!"); 
      }
      else {
      
         RE_edit_Trade_Exp.FontSize(WCon.GetMainFont_S());
         RE_edit_Trade_Exp.Text(DoubleToStr(SinT.GetSingularExp_Cur(),2)+" " +AccountCurrency());
      }
   }
   
   //.......................
   // Combo Box
   //.......................
   if(id==CHARTEVENT_OBJECT_CLICK && SinT.check_CB_TRADE(WCon.GetOBJ_CONTROL())) {
      
      if(SinT.GetSingularTradesValues_Risk()) SinT.GetSingularTradesValues_PosVal();
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
         WCon.Hide_RE();
         
         //Change the size of Window
         MainWindow.Height(WCon.GetPSC_Height());
         CopyRights.Shift(0,WCon.GetPSC_CR_Shift());
         
         //Show PSC
         WCon.Show_PSC();
         WCon.SetOPEN_TAB(WCon.Check_Tab());
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
         
         //Empty Info of PSC
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
         
         //Empty Info of PSC
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
      
      //Empty Info of PSC
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
      
      //Empty Info of PSC
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
      
      if(PSC.Calculate_Lot()) PSC.Calculate_PosVal(); 
   }
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

   //Entry Price Reset 
   PSC_edit_Entry.Text("");
   
   //Empty Info of PSC
   PSC_edit_Risk_in_Points.Text("");
   PSC_edit_Risk_in_Currency.Text("");
   PSC_edit_Total_Units.Text("");
   PSC_edit_Total_Lots.Text("");
   PSC_edit_PosVal.Text("");
   
   //Window Control
   if (PSC_label_Entry.IsVisible()) WCon.SetCopyFirstWindow(PositionSizeCalculator);
   if (RE_label_MAX_int.IsVisible()) WCon.SetCopyFirstWindow(RiskExposure);
   if (WCon.IsMin()) WCon.SetCopyFirstWindow(Minimised);
   
   WCon.SetCopyScale(SCALE);

   //destroy timer
   EventKillTimer();
   
   //Destroy items from Memory
   MainWindow.Destroy(reason);
}

//+------------------------------------------------------------------+
//| Position Size Calculator Custom Class - Constructor              |
//+------------------------------------------------------------------+
CPosSizCal::CPosSizCal(void) {

   RiskPoints  = 0.0;
   RiskCurr    = 0.0;
   TotalUnits  = 0.0;
   TotalLots   = 0.0;
   TotalPosVal = 0.0;
}

//+------------------------------------------------------------------+
//| Position Size Calculator Custom Class - Calculate Lot            |
//+------------------------------------------------------------------+
bool CPosSizCal::Calculate_Lot(void) {

   // General Variables
   double EntryPrice = StrToDouble(PSC_edit_Entry.Text());
   double ExitPrice  = StrToDouble(PSC_edit_SL.Text());
   double Risk       = StrToDouble(PSC_edit_Risk_per_trade.Text());
   
   if (EntryPrice <= 0 ||
       ExitPrice  <= 0 ||  
       Risk       <= 0) {
       
       PlaySound("alert2");
       MessageBox("Please Enter Valid Values for 'Risk on Trade'" + 
       ", 'EntryPrice' or 'StopLoss'","Error: Wrong Value!", MB_OK);
       
       return false;
   } 
   
   else {
   
      // General Variables
      double AccountSize = AccountInfoDouble(ACCOUNT_BALANCE);
      string AccountCurr = AccountCurrency();
      double SL_ = MathAbs(EntryPrice - ExitPrice) / SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE);
      double SL  = SL_ * SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE);
      
      // Symbol Information
      string Base_   = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_BASE);
      string Profit_ = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_PROFIT);
      
      //Conversion Rate
      bool accountSameAsCounterCurrency = AccountCurr == Profit_;
      
      //Calculation
      double ConversitionRate; 
      
      if (accountSameAsCounterCurrency) ConversitionRate = 1.0;
      else {
                                   
         ConversitionRate = iClose(AccountCurr + Profit_, PERIOD_D1, 1);
         if (ConversitionRate == 0.0) {
            Print("PSC.LotSize extra conversion!");
            
            if(iClose(Profit_ + AccountCurr, PERIOD_D1, 1) == 0) ConversitionRate = 0.0;
            else ConversitionRate = 1/iClose(Profit_ + AccountCurr, PERIOD_D1, 1);
            
            if (ConversitionRate == 0.0) {
            
               //Error Checking 
               Print("Could not find Converstion Symbol! - PSC.Lotsize");
               int Error = GetLastError();
               Print("PSC.Lotsize - Conversion Rate error: " + (string)Error);
               ResetLastError();
               
               return false;
            }
         }
      }
      
      double riskAmount = AccountSize * (Risk/100) * ConversitionRate;            
      double units = riskAmount/SL;
      double contractsize1 = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);
      double positionSize = units/contractsize1;
      
      //Allocate Results
      RiskPoints = SL_;
      RiskCurr = AccountSize * (Risk/100);
      TotalUnits = units;
      TotalLots = NormalizeDouble(positionSize,2);
      
      //Print Additional Info
      Print("PSC.Lotsize - Conversion Pair: "+AccountCurr + Profit_+" at "+DoubleToStr(ConversitionRate,Digits));
      
      //Populate Edit Boxes
      PSC_edit_Risk_in_Points.Text(DoubleToStr(RiskPoints,0));
      PSC_edit_Risk_in_Currency.Text(DoubleToStr(RiskCurr,2)+" "+AccountCurrency());
      PSC_edit_Total_Units.Text(DoubleToStr(TotalUnits,2));
      PSC_edit_Total_Lots.Text(DoubleToStr(TotalLots,2));
      
      return true;
   }   
   
   return true;
}  

//+------------------------------------------------------------------+
//| Position Size Calculator Custom Class - Calculate PosVal         |
//+------------------------------------------------------------------+
void CPosSizCal::Calculate_PosVal(void) {

   //Conversion
   string Base_         = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_BASE);
   string Profit_       = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_PROFIT);
   double contractsize1 = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);
   
   bool accountSameAsBaseCurrency = AccountCurrency() == Base_;
   double ConversitionRate_; 
   
   if (accountSameAsBaseCurrency) ConversitionRate_ = 1.0;
   else {
                               
      ConversitionRate_ = iClose(Base_ + AccountCurrency(), PERIOD_D1, 1);
      if (ConversitionRate_ == 0.0) {
         Print("PSC.Exposure extra conversion!");
         
         if(iClose(AccountCurrency()+Base_, PERIOD_D1, 1) == 0) ConversitionRate_ = 0.0;
         else ConversitionRate_ = 1/iClose(AccountCurrency()+Base_, PERIOD_D1, 1);
         
         if (ConversitionRate_ == 0.0) {
         
            //Error Checking 
            Print("Could not find Converstion Symbol! - PSC.Exposure");
            int Error = GetLastError();
            Print("PSC.Exposure - Conversion Rate error: " + (string)Error);
            ResetLastError();
            
            return;
         }
      }
   }
   TotalPosVal = Base_ == Profit_ ? 
                    (TotalLots*contractsize1) * ConversitionRate_ * iClose(Symbol(), PERIOD_D1, 1) :
                    (TotalLots*contractsize1) * ConversitionRate_;       

   if(TotalPosVal == 0.0){
      int Error = GetLastError();
      Print("PSC.Exposure Error: "+ (string)Error);
      ResetLastError();
      
      return;
   }
   
   //Print Additional Info
   Print("PSC.Exposure - Conversion Pair: "+Base_ + AccountCurrency()+" at "+DoubleToStr(ConversitionRate_,Digits));
   
   //Populate Edit Box
   PSC_edit_PosVal.Text(DoubleToStr(TotalPosVal,2)+" "+AccountCurrency());
}


//+------------------------------------------------------------------+
//| Position Size Calculator Custom Class - Track Bid Ask Prices     |
//+------------------------------------------------------------------+
int CPosSizCal::track_BidAsk(void) {

   static int check = 0;
   
   if(WCon.GetOBJ_CONTROL() == "Custom")    check = 1;
   if(WCon.GetOBJ_CONTROL() == "Bid")       check = 2;
   if(WCon.GetOBJ_CONTROL() == "Ask")       check = 3;
   if(WCon.GetOBJ_CONTROL() == "Calculate") check = 4;
   
   return check;
}

//+------------------------------------------------------------------+
//| Risk Setting Custom Class - Constructor                          |
//+------------------------------------------------------------------+
CRiskSettings::CRiskSettings(void) {

   //Max Values 
   MaxTrades = -1.0;
   MaxLots   = -1.0;
   MaxExpPer = -1.0;
   MaxExpCur = -1.0;
   MaxPosVal = -1.0;
}

//+------------------------------------------------------------------+
//| Total Exposure Custom Class - Constructor                        |
//+------------------------------------------------------------------+
CTotalExposure::CTotalExposure(void) {

   TotalTrades = 0.0;
   TotalLots   = 0.0;
   TotalExpCur = 0.0;
   TotalExpAcc = 0.0;
   TotalPosVal = 0.0;
}

//+------------------------------------------------------------------+
//| Total Exposure Custom Class - Check for short Trade with no SL   |
//+------------------------------------------------------------------+
void CTotalExposure::CheckTrade_withNoSL(void) {

   for(int i=0; i < OrdersTotal(); i++) {
   
      if(OrderSelect(i, SELECT_BY_POS)) {
      
         if(OrderStopLoss() == 0.0) {
            
            TotalExpCur = -10;
            TotalExpAcc = -10;
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Total Exposure Custom Class - Calculate Risk                     |
//+------------------------------------------------------------------+
void CTotalExposure::TotalExpAccAndCurr(void) {

   double Total_Currency_Exposure = 0.0;
   
   //Get Trade Info
   for(int i=0; i < OrdersTotal(); i++) {
      
      if(OrderSelect(i, SELECT_BY_POS)) {
         
         //Currency Info
         string AccountCurr = AccountCurrency();
         string Profit_ = SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_PROFIT);
         
         //Entry And Exit Price
         double EntryPrice = OrderOpenPrice();
         double ExitPrice = OrderStopLoss();
         
         //Points in risk
         double SL_points = MathAbs(EntryPrice - ExitPrice);
         
         //Trade Size
         double Lots = OrderLots();
         int    LotSize = (int)SymbolInfoDouble(OrderSymbol(), SYMBOL_TRADE_CONTRACT_SIZE);
         double Units = Lots * LotSize;
         
         //Risk in Currency
         double ExpInSymbolCurr;
         double ExpInAccounCurr;
         
         ExpInSymbolCurr = Units*SL_points;
         
         //Conversion
         bool accountSameAsCounterCurrency = AccountCurr == Profit_;
         double ConversitionRate; 
         
         if (accountSameAsCounterCurrency) ConversitionRate = 1.0;
         else {
                                      
            ConversitionRate = iClose(AccountCurr + Profit_, PERIOD_D1, 1);
            if (ConversitionRate == 0.0) {
            
               //Print("Totals.Risk extra conversion!");
               
               if(iClose(Profit_ + AccountCurr, PERIOD_D1, 1) == 0) ConversitionRate = 0.0;
               else ConversitionRate = 1/iClose(Profit_ + AccountCurr, PERIOD_D1, 1);
               
               if (ConversitionRate == 0.0) {
               
                  Print("Could not find Converstion Symbol! (Totals.Risk)");
                  int error = GetLastError();
                  Print("Totals.Risk - Conversion Rate error: " + (string)error + " " + OrderSymbol());
                  ResetLastError();
                  
                  return;
               }
            }
         }
         
         //CHECK IF TRADE IS IN PROFIT, IF IT IS THEN RISK IS ZERO
         bool BuyInProfit  = (OrderType() == OP_BUY ||
                              OrderType() == OP_BUYLIMIT || 
                              OrderType() == OP_BUYSTOP) &&
                             (ExitPrice >= EntryPrice);
                             
         bool SellInProfit = (OrderType() == OP_SELL || 
                              OrderType() == OP_SELLLIMIT || 
                              OrderType() == OP_SELLSTOP) &&
                             (ExitPrice <= EntryPrice);
         
         if(BuyInProfit || SellInProfit) ExpInAccounCurr = 0.0;
         else ExpInAccounCurr = ExpInSymbolCurr/ConversitionRate;
         
         Total_Currency_Exposure += ExpInAccounCurr;
      }
   }
   
   //Currency 
   TotalExpCur = Total_Currency_Exposure;
   
   //Account Percentage
   TotalExpAcc = (TotalExpCur*100)/AccountBalance();
   
   CheckTrade_withNoSL();
   
   //Display Resulst
   if(TotalExpAcc == -10 || TotalExpCur == -10) {
   
      if(WCon.GetTE() == 1) {
         RE_edit_Total_Exp.FontSize(WCon.GetsubFont_S());
         RE_edit_Total_Exp.Text("Use SL in All Trades!");
      }
      
      if(WCon.GetTE() == 2) {
         RE_edit_Total_Exp.FontSize(WCon.GetsubFont_S());
         RE_edit_Total_Exp.Text("Use SL in All Trades!");
      }
   }
   
   else {
      RE_edit_Total_Exp.FontSize(WCon.GetMainFont_S());
      if(WCon.GetTE() == 1) RE_edit_Total_Exp.Text(DoubleToStr(TotalExpAcc,2)+" %");
      if(WCon.GetTE() == 2) RE_edit_Total_Exp.Text(DoubleToStr(TotalExpCur,2)+" " +AccountCurrency());
   }   
}

//+------------------------------------------------------------------+
//| Total Exposure Custom Class - Total Value of Position Size       |
//+------------------------------------------------------------------+
void CTotalExposure::Total_PosVal(void) {

   double PosVal_= 0.0;
   double singularPosVal = 0.0;
   
   for(int i=0; i < OrdersTotal(); i++) {
      
      if(OrderSelect(i, SELECT_BY_POS)) {
      
         double Lots = OrderLots();
         double contractsize_ = SymbolInfoDouble(OrderSymbol(), SYMBOL_TRADE_CONTRACT_SIZE);
         double Units = Lots * contractsize_;
         string Base_ = SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_BASE);
         string Profit_ = SymbolInfoString(OrderSymbol(), SYMBOL_CURRENCY_PROFIT);

         
         //Conversion
         bool accountSameAsBaseCurrency = AccountCurrency() == Base_;
         double ConversitionRate_; 
         
         if (accountSameAsBaseCurrency) ConversitionRate_ = 1.0;
         else {
                                      
            ConversitionRate_ = iClose(Base_ + AccountCurrency(), PERIOD_D1, 1);
            if (ConversitionRate_ == 0.0) {
               //Print("Totals.Exposure extra conversion!");
               
               if(iClose(AccountCurrency()+Base_, PERIOD_D1, 1) == 0) ConversitionRate_ = 0.0;
               else ConversitionRate_ = 1/iClose(AccountCurrency()+Base_, PERIOD_D1, 1);
               
               if (ConversitionRate_ == 0.0) {
               
                  //Error Checking
                  Print("Could not find Converstion Symbol! (Totals.Exposure)");
                  int error = GetLastError();
                  Print("Totals.Exposure - Conversion Rate error: " + (string)error + " " + OrderSymbol());
                  ResetLastError();
                  
                  return;
               }
            }
         }
         singularPosVal = Base_ == Profit_ ? 
                          Units * ConversitionRate_ * iClose(OrderSymbol(), PERIOD_D1, 1) :
                          Units * ConversitionRate_;
        
         //Error Checking
         if(singularPosVal == 0) {
         
            //Error Checking
            int error = GetLastError();
            Print("Totals.Exposure Error:" + (string)error + " " + OrderSymbol());
            ResetLastError();
            
            return;
         }             
      }
      PosVal_+=singularPosVal;
   }
   TotalPosVal = PosVal_;
   RE_edit_Total_PosVal.Text(DoubleToStr(TotalPosVal,2) +" "+AccountCurrency());
}
//+------------------------------------------------------------------+
//| Total Exposure Custom Class - Is new Trade                       |
//+------------------------------------------------------------------+
bool CTotalExposure::IsNewTrade() {

   static int TradesOpen = -1; 
   if (OrdersTotal() == TradesOpen) return false;
   TradesOpen = OrdersTotal();
   return true;
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Constructor             |
//+------------------------------------------------------------------+
CIndTraExp::CIndTraExp(void) {

   SingularExp_Per = 0.0;
   SingularExp_Cur = 0.0;
   SingularPosVal  = 0.0;
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Add Trades to Combo Box |
//+------------------------------------------------------------------+
void CIndTraExp::AddToCB_Singular_Trades(void) {

   string List[100];
      
   for(int i=0; i < OrdersTotal(); i++) {
      
      if(OrderSelect(i, SELECT_BY_POS)) {
         
         switch (OrderType()) {
         
            case OP_BUY:       List[i] = "Long_" + OrderSymbol();
               break;
            
            case OP_SELL:      List[i] = "Short_" + OrderSymbol();
               break;
            
            case OP_BUYLIMIT:  List[i] = "Long Limit_" + OrderSymbol();
               break;
            
            case OP_BUYSTOP:   List[i] = "Long Stop_" + OrderSymbol();
               break;  
            
            case OP_SELLLIMIT: List[i] = "Short Limit_" + OrderSymbol();
               break;    
            
            case OP_SELLSTOP:  List[i] = "Short Stop_" + OrderSymbol();
               break;    
         }                                                     
      }
      RE_CB_Trade_Expo.AddItem(List[i]);
   }
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Check Combo Box Trade   |
//+------------------------------------------------------------------+
bool CIndTraExp::check_CB_TRADE(string x) {

   string List[100];
      
   for(int i=0; i < OrdersTotal(); i++) {
      
      if(OrderSelect(i, SELECT_BY_POS)) {
      
         string Asset = OrderSymbol();
         int    Type  = OrderType(); 
         
         switch (Type) {
         
            case OP_BUY:       List[i] = "Long_" + Asset;
               break;
            
            case OP_SELL:      List[i] = "Short_" + Asset;
               break;
            
            case OP_BUYLIMIT:  List[i] = "Long Limit_" + Asset;
               break;
            
            case OP_BUYSTOP:   List[i] = "Long Stop_" + Asset;
               break;  
            
            case OP_SELLLIMIT: List[i] = "Short Limit_" + Asset;
               break;    
            
            case OP_SELLSTOP:  List[i] = "Short Stop_" + Asset;
               break;    
         }                                                     
      }
      if(x==List[i]) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Check Short Trade With no SL
//+------------------------------------------------------------------+
void CIndTraExp::CheckTrade_withNoSL(string x) {

   string TRADES[2];
   StringSplit(x, '_', TRADES);
   
   int P_TYPE;
   
   if      (TRADES[0] == "Long")        P_TYPE = OP_BUY;
   else if (TRADES[0] == "Short")       P_TYPE = OP_SELL;
   else if (TRADES[0] == "Long Limit")  P_TYPE = OP_BUYLIMIT;
   else if (TRADES[0] == "Long Stop")   P_TYPE = OP_BUYSTOP;
   else if (TRADES[0] == "Short Limit") P_TYPE = OP_SELLLIMIT;
   else if (TRADES[0] == "Short Stop")  P_TYPE = OP_SELLSTOP;
   else                                 P_TYPE = -1;   
   
   for(int i=0; i < OrdersTotal(); i++) {
   
      if(OrderSelect(i, SELECT_BY_POS)) {
      
         if(OrderSymbol() == TRADES[1])
            if(OrderStopLoss() == 0.0) {
               SingularExp_Per = -10;
               SingularExp_Cur = -10;
            }  
      }
   }
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Get Singular Trades Risk|
//+------------------------------------------------------------------+
bool CIndTraExp::GetSingularTradesValues_Risk (void) {

   RE_CB_Trade_Expo.SelectByText(WCon.GetOBJ_CONTROL());
   
   string TRADES[2];
   
   StringSplit(WCon.GetOBJ_CONTROL(), '_', TRADES);
   
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
               CheckTrade_withNoSL(WCon.GetOBJ_CONTROL());
               
               if (SingularExp_Per == -10 || SingularExp_Cur == -10){
                  
                  if(WCon.GetITE() == 2) {
                     RE_edit_Trade_Exp.FontSize(WCon.GetsubFont_S());
                     RE_edit_Trade_Exp.Text("Trade with No SL!");
                  }
                  if(WCon.GetITE() == 1) {
                     RE_edit_Trade_Exp.FontSize(WCon.GetsubFont_S());
                     RE_edit_Trade_Exp.Text("Trade with No SL!");
                  }
               }
               else {
                  RE_edit_Trade_Exp.FontSize(WCon.GetMainFont_S());
                  if(WCon.GetITE() == 2) RE_edit_Trade_Exp.Text(DoubleToStr(SingularExp_Cur,2)+" " +AccountCurrency()); 
                  if(WCon.GetITE() == 1) RE_edit_Trade_Exp.Text(DoubleToStr(SingularExp_Per,2)+" %");
               }                
            }
   }
   return true;
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Get Singular Trades PosVal|
//+------------------------------------------------------------------+
void CIndTraExp::GetSingularTradesValues_PosVal(void) {

   RE_CB_Trade_Expo.SelectByText(WCon.GetOBJ_CONTROL());
   
   string TRADES[2];
   
   StringSplit(WCon.GetOBJ_CONTROL(), '_', TRADES);
   
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
//| Window Control Custom Class - Constructor                        |
//+------------------------------------------------------------------+
CWinControl::CWinControl(void) {

   MainWindowWidth = ScaledPixel(383); //Main Window Width
   MainFont_S      = ScaledFont(10);
   subFont_S       = ScaledFont(8);
   PSC_Height      = ScaledPixel(400);
   RE_Height       = ScaledPixel(520);
   PSC_CR_Shift    = ScaledPixel(-120); //Shifft
   RE_CR_Shift     = ScaledPixel(120);
   //CopyScale       = -1;
   
   /*Currency or Account Button*/
   RS  = 1;
   TE  = 1;
   ITE = 1;

   OPEN_TAB = 2;
   CopyFirstWindow = -1;
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Manual Version of Constructor      |
//+------------------------------------------------------------------+
void CWinControl::ResetContructor(void) {

   MainWindowWidth = ScaledPixel(383); //Main Window Width
   MainFont_S      = ScaledFont(10);
   subFont_S       = ScaledFont(8);
   PSC_Height      = ScaledPixel(400);
   RE_Height       = ScaledPixel(520);
   PSC_CR_Shift    = ScaledPixel(-120); //Shifft
   RE_CR_Shift     = ScaledPixel(120);
   //CopyScale       = -1;
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Scaled Font                        |
//+------------------------------------------------------------------+
int CWinControl::ScaledFont(int i) {

   int standard = 96;
   int DPI = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   return int((i*standard/DPI) * SCALE);
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Scaled Pixel                       |
//+------------------------------------------------------------------+
int CWinControl::ScaledPixel(int i) {
   
   return int(i*SCALE);
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Minimise                           |
//+------------------------------------------------------------------+
void CWinControl::WindowMin(void) {

   CopyRights.Hide();
   ButtonTabPSC.Hide();
   ButtonTabRisk.Hide();
   Hide_PSC();
   Hide_RE();
   MainWindow.Height(30);
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Is it Minimised                    |
//+------------------------------------------------------------------+
bool CWinControl::IsMin(void) {

   if (CopyRights.IsVisible() == false) return true;
   return false; 
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Show PSC                           |
//+------------------------------------------------------------------+
void CWinControl::Show_PSC(void) {

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
//| Window Control Custom Class - Hide PSC                           |
//+------------------------------------------------------------------+
void CWinControl::Hide_PSC(void) {

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
void CWinControl::Show_RE(void) {

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
void CWinControl::Hide_RE(void) {

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
//| Window Control Custom Class - Which Tab is open                  |
//+------------------------------------------------------------------+
int CWinControl::Check_Tab(void) {

   static int TAB;
   
   if (PSC_label_Risk_per_trade.IsVisible() == true) {
      TAB = 1;
      return TAB;
   }
   if (RE_label_MAX_int.IsVisible() == true) {
      TAB = 2;
      return TAB;
   }
   return TAB;
} 

//+------------------------------------------------------------------+
//| Window Control Custom Class - Maximise                           |
//+------------------------------------------------------------------+
void CWinControl::WindowMax(void) {

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