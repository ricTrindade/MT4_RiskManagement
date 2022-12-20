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
   void TotalExpAccAndCurr();
   void CheckTrade_withNoSL();
   void Total_PosVal();
   bool IsNewTrade();
};