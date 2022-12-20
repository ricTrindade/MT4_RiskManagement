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
   void   AddToCB_Singular_Trades();
   bool   GetSingularTradesValues_Risk();
   void   GetSingularTradesValues_PosVal();
   
   //string check_CB_TRADE();
   //void   GetSingularTradesValues(string x);
};