//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Edit.mqh> 

//+------------------------------------------------------------------+
//| Position Size Calculator Edit Class                              |
//+------------------------------------------------------------------+
class CEditPSC {

public :

   // Components 
   CEdit *riskPerTrade;
   CEdit *entryPrice;
   CEdit *stopLoss;
   CEdit *riskInPoints;
   CEdit *riskInCurrency;
   CEdit *contractSize;
   CEdit *totalUnits;
   CEdit *totalLots;
   CEdit *positionValue;
   
   // Constructor
   CEditPSC();
   
   // Destructor
   ~CEditPSC();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CEditPSC::CEditPSC() {
   
   riskPerTrade   = new CEdit();
   entryPrice     = new CEdit();
   stopLoss       = new CEdit();
   riskInPoints   = new CEdit();
   riskInCurrency = new CEdit();
   contractSize   = new CEdit();
   totalUnits     = new CEdit();
   totalLots      = new CEdit();
   positionValue  = new CEdit();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CEditPSC::~CEditPSC() {
   
   delete riskPerTrade;
   delete entryPrice;
   delete stopLoss;
   delete riskInPoints;
   delete riskInCurrency;
   delete contractSize;
   delete totalUnits;
   delete totalLots;
   delete positionValue;
}
