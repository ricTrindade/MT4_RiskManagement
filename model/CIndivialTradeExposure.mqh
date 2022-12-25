//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CIndivialTradeExposure_
   #define CIndivialTradeExposure_
   
//+------------------------------------------------------------------+
//| Include Resources                                                |
//+------------------------------------------------------------------+
//CGuiControl.mqh
#include "C:\Program Files\OANDA - MetaTrader\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh"


//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class                           |
//+------------------------------------------------------------------+
class CIndivialTradeExposure {

private:      

   //Singular Trade Exp
   double SingularExp_Per;
   double SingularExp_Cur;
   double SingularPosVal;
    
public:

   //------------------------------
   //Constructor and Destructor
   //------------------------------
   CIndivialTradeExposure();
   
   //------------------------------
   //Accessor Functions
   //------------------------------
   double GetSingularExp_Per() {return SingularExp_Per;}
   double GetSingularExp_Cur() {return SingularExp_Cur;}
   double GetSingularPosVal()  {return SingularPosVal;}
   
   //------------------------------
   //'Set Value' Functions
   //------------------------------
   void SetSingularExp_Per (double value) {SingularExp_Per = value;}
   void SetSingularExp_Cur (double value) {SingularExp_Cur = value;}
   void SetSingularPosVal  (double value) {SingularPosVal  = value;}
   
   //------------------------------
   //Member Functions
   //------------------------------
   bool   check_CB_TRADE(string x);
   void   CheckTrade_withNoSL(string x);
   void   AddToCB_Singular_Trades(CGuiControl &gui);
   bool   GetSingularTradesValues_Risk(CGuiControl &gui);
   void   GetSingularTradesValues_PosVal(CGuiControl &gui);
   
   //string check_CB_TRADE();
   //void   GetSingularTradesValues(string x);
};

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Constructor             |
//+------------------------------------------------------------------+
CIndivialTradeExposure::CIndivialTradeExposure(void) {

   SingularExp_Per = 0.0;
   SingularExp_Cur = 0.0;
   SingularPosVal  = 0.0;
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Add Trades to Combo Box |
//+------------------------------------------------------------------+
void CIndivialTradeExposure::AddToCB_Singular_Trades(CGuiControl &gui) {

   string List[100];
      
   for(int i=0; i < OrdersTotal(); i++) {
      
      if(OrderSelect(i, SELECT_BY_POS)) {
         
         switch (OrderType()) {
         
            case OP_BUY:       List[i] = "Long_"        + OrderSymbol(); break;
            case OP_SELL:      List[i] = "Short_"       + OrderSymbol(); break; 
            case OP_BUYLIMIT:  List[i] = "Long Limit_"  + OrderSymbol(); break;     
            case OP_BUYSTOP:   List[i] = "Long Stop_"   + OrderSymbol(); break;      
            case OP_SELLLIMIT: List[i] = "Short Limit_" + OrderSymbol(); break;         
            case OP_SELLSTOP:  List[i] = "Short Stop_"  + OrderSymbol(); break;    
         }                                                     
      }
      gui.riskExposure.comboBox.tradeExposure.AddItem(List[i]);
   }
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Check Combo Box Trade   |
//+------------------------------------------------------------------+
bool CIndivialTradeExposure::check_CB_TRADE(string x) {

   string List[100];
      
   for(int i=0; i < OrdersTotal(); i++) {
      
      if(OrderSelect(i, SELECT_BY_POS)) {
      
         string Asset = OrderSymbol();
         int    Type  = OrderType(); 
         
         switch (Type) {
         
            case OP_BUY:       List[i] = "Long_"        + Asset; break;           
            case OP_SELL:      List[i] = "Short_"       + Asset; break;      
            case OP_BUYLIMIT:  List[i] = "Long Limit_"  + Asset; break;         
            case OP_BUYSTOP:   List[i] = "Long Stop_"   + Asset; break;     
            case OP_SELLLIMIT: List[i] = "Short Limit_" + Asset; break;          
            case OP_SELLSTOP:  List[i] = "Short Stop_"  + Asset; break;    
         }                                                     
      }
      if(x==List[i]) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Check Short Trade With no SL
//+------------------------------------------------------------------+
void CIndivialTradeExposure::CheckTrade_withNoSL(string x) {

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
bool CIndivialTradeExposure::GetSingularTradesValues_Risk (CGuiControl &gui) {

   gui.riskExposure.comboBox.tradeExposure.SelectByText(gui.GetOBJ_CONTROL());
   
   string TRADES[2];
   
   StringSplit(gui.GetOBJ_CONTROL(), '_', TRADES);
   
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
               CheckTrade_withNoSL(gui.GetOBJ_CONTROL());
               
               if (SingularExp_Per == -10 || SingularExp_Cur == -10){
                  
                  if(gui.GetITE() == 2) {
                     gui.riskExposure.edit.tradeExposure.FontSize(gui.GetsubFont_S()); 
                     gui.riskExposure.edit.tradeExposure.Text("Trade with No SL!");
                  }
                  if(gui.GetITE() == 1) {
                     gui.riskExposure.edit.tradeExposure.FontSize(gui.GetsubFont_S());
                     gui.riskExposure.edit.tradeExposure.Text("Trade with No SL!");
                  }
               }
               else {
                  gui.riskExposure.edit.tradeExposure.FontSize(gui.GetMainFont_S());
                  if(gui.GetITE() == 2) gui.riskExposure.edit.tradeExposure.Text(DoubleToStr(SingularExp_Cur,2)+" " +AccountCurrency()); 
                  if(gui.GetITE() == 1) gui.riskExposure.edit.tradeExposure.Text(DoubleToStr(SingularExp_Per,2)+" %");
               }                
            }
   }
   return true;
}

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class - Get Singular Trades PosVal|
//+------------------------------------------------------------------+
void CIndivialTradeExposure::GetSingularTradesValues_PosVal(CGuiControl &gui) {

   gui.riskExposure.comboBox.tradeExposure.SelectByText(gui.GetOBJ_CONTROL());
   
   string TRADES[2];
   
   StringSplit(gui.GetOBJ_CONTROL(), '_', TRADES);
   
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
               gui.riskExposure.edit.tradePositionValue.Text(DoubleToStr(singularPosVal,2)+" "+AccountCurrency());
            }
   }         
}




//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif