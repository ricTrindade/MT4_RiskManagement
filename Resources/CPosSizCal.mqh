//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CPosSizCal
   #define CPosSizCal_

//+------------------------------------------------------------------+
//| Include MT4 Libraries & Resources                                |
//+------------------------------------------------------------------+
#include "PreExistingLibraries\MT4Libraries.mqh"

//+------------------------------------------------------------------+
//| Include Custom Libraries                                         |
//+------------------------------------------------------------------+
#include "CWinControl.mqh"

//+------------------------------------------------------------------+
//| Position Size Calculator Custom Class                            |
//+------------------------------------------------------------------+
class CPosSizCal {

private:   
   
   double RiskPoints;
   double RiskCurr;
   double TotalUnits;
   double TotalLots;
   double TotalPosVal;

public:

   //------------------------------
   //Constructor and Destructor
   //------------------------------
   CPosSizCal();
   
   //------------------------------
   //Accessor Functions
   //------------------------------
   double GetRiskPoints()  {return RiskPoints;}
   double GetRiskCurr()    {return RiskCurr;}
   double GetTotalUnits()  {return TotalUnits;}
   double GetTotalLots()   {return TotalLots;}
   double GetTotalPosVal() {return TotalPosVal;}
   
   //------------------------------
   //'Set Value' Functions
   //------------------------------
   void SetRiskPoints  (double value) {RiskPoints  = value;}
   void SetRiskCurr    (double value) {RiskCurr    = value;}
   void SetTotalUnits  (double value) {TotalUnits  = value;}
   void SetTotalLots   (double value) {TotalLots   = value;}
   void SetTotalPosVal (double value) {TotalPosVal = value;}
   
   //------------------------------
   //Member Functions
   //------------------------------
   bool Calculate_Lot(CEdit &Entry,
                      CEdit &SL,
                      CEdit &Risk_Per_Trade,
                      CEdit &Risk_in_Points,
                      CEdit &Risk_in_Currency,
                      CEdit &Total_Units,
                      CEdit &Total_Lots);
                      
   void Calculate_PosVal (CEdit &positionValue);
   int  track_BidAsk     (CWinControl &windowControl);
};

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
bool CPosSizCal::Calculate_Lot(CEdit &Entry,
                               CEdit &StopLoss,
                               CEdit &Risk_Per_Trade,
                               CEdit &Risk_in_Points,
                               CEdit &Risk_in_Currency,
                               CEdit &Total_Units,
                               CEdit &Total_Lots) {

   // General Variables
   double EntryPrice = StrToDouble(Entry.Text());
   double ExitPrice  = StrToDouble(StopLoss.Text());
   double Risk       = StrToDouble(Risk_Per_Trade.Text());
   
   if (EntryPrice <= 0 ||
       ExitPrice  <= 0 ||  
       Risk       <= 0) {
       
       PlaySound("alert2");
       MessageBox("Please Enter Valid Values for 'Risk on Trade'" + 
                  ", 'EntryPrice' or 'StopLoss'",
                  "Error: Wrong Value!",
                  MB_OK);
       
       return false;
   } 
   
   else {
   
      // General Variables
      double AccountSize = AccountInfoDouble(ACCOUNT_BALANCE);
      string AccountCurr = AccountCurrency();
      double SL_         = MathAbs(EntryPrice - ExitPrice) / SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE);
      double SL          = SL_ * SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE);
      
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
      
      double riskAmount    = AccountSize * (Risk/100) * ConversitionRate;            
      double units         = riskAmount/SL;
      double contractsize1 = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);
      double positionSize  = units/contractsize1;
      
      //Allocate Results
      RiskPoints = SL_;
      RiskCurr   = AccountSize * (Risk/100);
      TotalUnits = units;
      TotalLots  = NormalizeDouble(positionSize,2);
      
      //Print Additional Info
      Print("PSC.Lotsize - Conversion Pair: "+AccountCurr + Profit_+" at "+DoubleToStr(ConversitionRate,Digits));
      
      //Populate Edit Boxes
      Risk_in_Points.Text(DoubleToStr(RiskPoints,0));
      Risk_in_Currency.Text(DoubleToStr(RiskCurr,2)+" "+AccountCurrency());
      Total_Units.Text(DoubleToStr(TotalUnits,2));
      Total_Lots.Text(DoubleToStr(TotalLots,2));
      
      return true;
   }   
   
   return true;
}  

//+------------------------------------------------------------------+
//| Position Size Calculator Custom Class - Track Bid Ask Prices     |
//+------------------------------------------------------------------+
int CPosSizCal::track_BidAsk(CWinControl &windowControl) {

   static int check = 0;
   
   if(windowControl.GetOBJ_CONTROL() == "Custom")    check = 1;
   if(windowControl.GetOBJ_CONTROL() == "Bid")       check = 2;
   if(windowControl.GetOBJ_CONTROL() == "Ask")       check = 3;
   if(windowControl.GetOBJ_CONTROL() == "Calculate") check = 4;
   
   return check;
}

//+------------------------------------------------------------------+
//| Position Size Calculator Custom Class - Calculate PosVal         |
//+------------------------------------------------------------------+
void CPosSizCal::Calculate_PosVal(CEdit &positionValue) {

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
      int error = GetLastError();
      Print("PSC.Exposure Error: "+ (string)error);
      ResetLastError();
      
      return;
   }
   
   //Print Additional Info
   Print("PSC.Exposure - Conversion Pair: "+Base_ + AccountCurrency()+" at "+DoubleToStr(ConversitionRate_,Digits));
   
   //Populate Edit Box
   positionValue.Text(DoubleToStr(TotalPosVal,2)+" "+AccountCurrency());
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif