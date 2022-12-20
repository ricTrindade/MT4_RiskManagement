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
   bool Calculate_Lot();
   void Calculate_PosVal();
   int  track_BidAsk();
};