//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Label.mqh> 

//+------------------------------------------------------------------+
//| Position Size Calculator Labels Class                            |
//+------------------------------------------------------------------+
class CLabelPSC {

public:

   // Components
   CLabel *riskPerTrade;
   CLabel *entryPrice;
   CLabel *stopLoss;
   CLabel *riskInPoints;
   CLabel *riskInCurrency;
   CLabel *contractSize;
   CLabel *totalUnits;
   CLabel *totalLots;
   CLabel *positionValue;
   
   // Constructor
   CLabelPSC();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CLabelPSC::CLabelPSC() {

   riskPerTrade   = new CLabel();
   entryPrice     = new CLabel();
   stopLoss       = new CLabel();
   riskInPoints   = new CLabel();
   riskInCurrency = new CLabel();
   contractSize   = new CLabel();
   totalUnits     = new CLabel();
   totalLots      = new CLabel();
   positionValue  = new CLabel();
}