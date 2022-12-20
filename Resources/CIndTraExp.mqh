//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CIndTraExp_
   #define CIndTraExp_
   
//+------------------------------------------------------------------+
//| Include MT4 Libraries & Resources                                |
//+------------------------------------------------------------------+
#include "PreExistingLibraries\MT4Libraries.mqh"

//+------------------------------------------------------------------+
//| Individual Trade Exposure Custom Class                           |
//+------------------------------------------------------------------+
class CIndTraExp {

private:      

   //Singular Trade Exp
   double SingularExp_Per;
   double SingularExp_Cur;
   double SingularPosVal;
    
public:

   //------------------------------
   //Constructor and Destructor
   //------------------------------
   CIndTraExp();
   
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
   void   AddToCB_Singular_Trades(CComboBox &tradeExposure);
   bool   GetSingularTradesValues_Risk();
   void   GetSingularTradesValues_PosVal();
   
   //string check_CB_TRADE();
   //void   GetSingularTradesValues(string x);
};

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
void CIndTraExp::AddToCB_Singular_Trades(CComboBox &tradeExposure) {

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
      tradeExposure.AddItem(List[i]);
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

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif