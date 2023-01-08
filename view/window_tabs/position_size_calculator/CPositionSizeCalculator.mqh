//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include "components\CButtonPSC.mqh"
#include "components\CEditPSC.mqh"
#include "components\CLabelPSC.mqh"

//+------------------------------------------------------------------+
//| Position Size Calculator tab class                               |
//+------------------------------------------------------------------+
class CPositionSizeCalculatorTab {

public:

   int height;
   int crShift;

   // Components
   CButtonPSC *button;
   CLabelPSC  *label;
   CEditPSC   *edit;
   
   // Constructor
   CPositionSizeCalculatorTab();
   
   // Destructor
   ~CPositionSizeCalculatorTab();
   
   // Member Functions
   void show();
   void hide();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPositionSizeCalculatorTab::CPositionSizeCalculatorTab() {

   button = new CButtonPSC();
   label  = new CLabelPSC();
   edit   = new CEditPSC();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPositionSizeCalculatorTab::~CPositionSizeCalculatorTab() {

   delete button;
   delete label;
   delete edit;
}

//+------------------------------------------------------------------+
//| Show_PSC                                                         |
//+------------------------------------------------------------------+
void CPositionSizeCalculatorTab::show(void) {

   label.riskPerTrade.Show();
   edit.riskPerTrade.Show();
   label.entryPrice.Show();
   edit.entryPrice.Show();
   button.priceCustom.Show();
   button.priceBid.Show();
   button.priceAsk.Show();
   label.stopLoss.Show();
   edit.stopLoss.Show();
   button.calculate.Show();
   label.riskInPoints.Show();
   edit.riskInPoints.Show();
   label.riskInCurrency.Show();
   edit.riskInCurrency.Show();
   label.contractSize.Show();
   edit.contractSize.Show();
   label.totalUnits.Show();
   edit.totalLots.Show();
   label.totalLots.Show();
   edit.totalLots.Show();
   label.positionValue.Show();
   edit.positionValue.Show();
}

//+------------------------------------------------------------------+
//| Hide_PSC                                                         |
//+------------------------------------------------------------------+
void CPositionSizeCalculatorTab::hide(void) {

   label.riskPerTrade.Hide();
   edit.riskPerTrade.Hide();
   label.entryPrice.Hide();
   edit.entryPrice.Hide();
   button.priceCustom.Hide();
   button.priceBid.Hide();
   button.priceAsk.Hide();
   label.stopLoss.Hide();
   edit.stopLoss.Hide();
   button.calculate.Hide();
   label.riskInPoints.Hide();
   edit.riskInPoints.Hide();
   label.riskInCurrency.Hide();
   edit.riskInCurrency.Hide();
   label.contractSize.Hide();
   edit.contractSize.Hide();
   label.totalUnits.Hide();
   edit.totalLots.Hide();
   label.totalLots.Hide();
   edit.totalLots.Hide();
   label.positionValue.Hide();
   edit.positionValue.Hide();
}

