//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CTotalExposure_
   #define CTotalExposure_

//+------------------------------------------------------------------+
//| Include MT4 Libraries & Resources                                |
//+------------------------------------------------------------------+
#include "PreExistingLibraries\MT4Libraries.mqh"

//+------------------------------------------------------------------+
//| Include Custom Libraries                                         |
//+------------------------------------------------------------------+
#include "CWinControl.mqh"

//+------------------------------------------------------------------+
//| Total Exposure Custom Class                                      |
//+------------------------------------------------------------------+
class CTotalExposure {

private:      

   //Current Total Values 
   double TotalTrades;
   double TotalLots;
   double TotalExpCur;
   double TotalExpAcc;
   double TotalPosVal;
    
public:

   //------------------------------
   //Constructor and Destructor
   //------------------------------
   CTotalExposure();
   
   //------------------------------
   //Accessor Functions
   //------------------------------
   double GetTotalTrades()  {return TotalTrades;}
   double GetTotalLots()    {return TotalLots;}
   double GetTotalExpCur()  {return TotalExpCur;}
   double GetTotalExpAcc()  {return TotalExpAcc;}
   double GetTotalPosVal()  {return TotalPosVal;}
   
   //------------------------------
   //'Set Value' Functions
   //------------------------------
   void SetTotalTrades (double value) {TotalTrades = value;}
   void SetTotalLots   (double value) {TotalLots   = value;}
   void SetTotalExpCur (double value) {TotalExpCur = value;}
   void SetTotalExpAcc (double value) {TotalExpAcc = value;}
   void SetTotalPosVal (double value) {TotalPosVal = value;}
   
   //------------------------------
   //Member Functions
   //------------------------------
   void TotalExpAccAndCurr(CWinControl &windowControl,
                           CEdit &totalExposure);
   void CheckTrade_withNoSL();
   void Total_PosVal(CEdit &totalPositionValue);
   bool IsNewTrade();
};

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
void CTotalExposure::TotalExpAccAndCurr(CWinControl &windowControl,
                                        CEdit &totalExposure) {

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
   
      if(windowControl.GetTE() == 1) {
         totalExposure.FontSize(windowControl.GetsubFont_S());
         totalExposure.Text("Use SL in All Trades!");
      }
      
      if(windowControl.GetTE() == 2) {
         totalExposure.FontSize(windowControl.GetsubFont_S());
         totalExposure.Text("Use SL in All Trades!");
      }
   }
   
   else {
      totalExposure.FontSize(windowControl.GetMainFont_S());
      if(windowControl.GetTE() == 1) totalExposure.Text(DoubleToStr(TotalExpAcc,2)+" %");
      if(windowControl.GetTE() == 2) totalExposure.Text(DoubleToStr(TotalExpCur,2)+" " +AccountCurrency());
   }   
}

//+------------------------------------------------------------------+
//| Total Exposure Custom Class - Total Value of Position Size       |
//+------------------------------------------------------------------+
void CTotalExposure::Total_PosVal(CEdit &totalPositionValue) {

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
            int error1 = GetLastError();
            Print("Totals.Exposure Error:" + (string)error1 + " " + OrderSymbol());
            ResetLastError();
            
            return;
         }             
      }
      PosVal_+=singularPosVal;
   }
   TotalPosVal = PosVal_;
   totalPositionValue.Text(DoubleToStr(TotalPosVal,2) +" "+AccountCurrency());
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

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif