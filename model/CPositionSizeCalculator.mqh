//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CPositionSizeCalculator
   #define CPositionSizeCalculator_

//+------------------------------------------------------------------+
//| Include External Resources                                       |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh"


//+------------------------------------------------------------------+
//| Position Size Calculator Class                                   |
//+------------------------------------------------------------------+
class CPositionSizeCalculator {

private:   
   
   // Fields
   double RiskPoints;
   double RiskCurr;
   double TotalUnits;
   double TotalLots;
   double TotalPosVal;

public:

   // Constructor
   CPositionSizeCalculator();
   
   // Getters
   double GetRiskPoints()  {return RiskPoints;}
   double GetRiskCurr()    {return RiskCurr;}
   double GetTotalUnits()  {return TotalUnits;}
   double GetTotalLots()   {return TotalLots;}
   double GetTotalPosVal() {return TotalPosVal;}
   
   // Setters
   void SetRiskPoints  (double value) {RiskPoints  = value;}
   void SetRiskCurr    (double value) {RiskCurr    = value;}
   void SetTotalUnits  (double value) {TotalUnits  = value;}
   void SetTotalLots   (double value) {TotalLots   = value;}
   void SetTotalPosVal (double value) {TotalPosVal = value;}
   
   // Methods
   bool Calculate_Lot    (CGuiControl &gui);      
   void Calculate_PosVal (CGuiControl &gui);
   int  track_BidAsk     (CGuiControl &gui);
};

//+------------------------------------------------------------------+
//| Constructor's Body                                               |
//+------------------------------------------------------------------+
CPositionSizeCalculator::CPositionSizeCalculator(void) {

   RiskPoints  = 0.0;
   RiskCurr    = 0.0;
   TotalUnits  = 0.0;
   TotalLots   = 0.0;
   TotalPosVal = 0.0;
}

//+------------------------------------------------------------------+
//| Calculate Lot Size - Method's Body                               |
//+------------------------------------------------------------------+
bool CPositionSizeCalculator::Calculate_Lot(CGuiControl &gui) {

   // General Variables
   double EntryPrice = StrToDouble(gui.positionSizeCalculator.edit.entryPrice.Text()); 
   double ExitPrice  = StrToDouble(gui.positionSizeCalculator.edit.stopLoss.Text());
   double Risk       = StrToDouble(gui.positionSizeCalculator.edit.riskPerTrade.Text());
   
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
      gui.positionSizeCalculator.edit.riskInPoints.Text(DoubleToStr(RiskPoints,0));
      gui.positionSizeCalculator.edit.riskInCurrency.Text(DoubleToStr(RiskCurr,2)+" "+AccountCurrency());
      gui.positionSizeCalculator.edit.totalUnits.Text(DoubleToStr(TotalUnits,2));
      gui.positionSizeCalculator.edit.totalLots.Text(DoubleToStr(TotalLots,2));
      
      return true;
   }   
   
   return true;
}  

//+------------------------------------------------------------------+
//|  Track Bid Ask Prices - Method's Body                            |
//+------------------------------------------------------------------+
int CPositionSizeCalculator::track_BidAsk(CGuiControl &gui) {

   static int check = 0;
   
   if(gui.GetOBJ_CONTROL() == "Custom")    check = 1;
   if(gui.GetOBJ_CONTROL() == "Bid")       check = 2;
   if(gui.GetOBJ_CONTROL() == "Ask")       check = 3;
   if(gui.GetOBJ_CONTROL() == "Calculate") check = 4;
   
   return check;
}

//+------------------------------------------------------------------+
//| Calculate Position Value - Method's Body                         |
//+------------------------------------------------------------------+
void CPositionSizeCalculator::Calculate_PosVal(CGuiControl &gui) {

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
   gui.positionSizeCalculator.edit.positionValue.Text(DoubleToStr(TotalPosVal,2)+" "+AccountCurrency());
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif