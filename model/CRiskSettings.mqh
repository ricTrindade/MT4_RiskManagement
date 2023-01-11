//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CRiskSettings_
   #define CRiskSettings_

//+------------------------------------------------------------------+
//| Risk Settings Class                                              |
//+------------------------------------------------------------------+
class CRiskSettings {

private:   

   // Fields 
   double MaxTrades;
   double MaxLots;
   double MaxExpPer;
   double MaxExpCur;
   double MaxPosVal;
    
public:
   
   // Constructor
   CRiskSettings();
   
   // Getters
   double GetMaxTrades() {return MaxTrades;}
   double GetMaxLots()   {return MaxLots;}
   double GetMaxExpPer() {return MaxExpPer;}
   double GetMaxExpCur() {return MaxExpCur;}
   double GetMaxPosVal() {return MaxPosVal;}
   
   // Setters
   void SetMaxTrades (double value) {MaxTrades = value;}
   void SetMaxLots   (double value) {MaxLots   = value;}
   void SetMaxExpPer (double value) {MaxExpPer = value;}
   void SetMaxExpCur (double value) {MaxExpCur = value;}
   void SetMaxPosVal (double value) {MaxPosVal = value;}
};

//+------------------------------------------------------------------+
//| Constructor's Body                                               |
//+------------------------------------------------------------------+
CRiskSettings::CRiskSettings(void) {

   //Max Values 
   MaxTrades = -1.0;
   MaxLots   = -1.0;
   MaxExpPer = -1.0;
   MaxExpCur = -1.0;
   MaxPosVal = -1.0;
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif