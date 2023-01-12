//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include "components\CBMPbuttonRE.mqh"
#include "components\CButtonRE.mqh"
#include "components\CComboBoxRE.mqh"
#include "components\CEditRE.mqh"
#include "components\CLabelRE.mqh"

//+------------------------------------------------------------------+
//| Risk Exposure tab class                                          |
//+------------------------------------------------------------------+
class CRiskExposure {

public:

   // Setting
   int height;
   int crShift;
   
   /*Currency or Account Button*/
   int RS;
   int TE;
   int ITE;

   // Components
   CButtonRE    *button;
   CLabelRE     *label;
   CEditRE      *edit;
   CComboBoxRE  *comboBox;
   CBMPbuttonRE *bmpButton;
   
   // Constructor
   CRiskExposure();
   
   // Destructor
   ~CRiskExposure();
   
   // Member Functions
   void show();
   void hide();
   
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CRiskExposure::CRiskExposure() {

   button    = new CButtonRE();
   label     = new CLabelRE();
   edit      = new CEditRE();
   comboBox  = new CComboBoxRE();
   bmpButton = new CBMPbuttonRE();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CRiskExposure::~CRiskExposure() {

   delete button;
   delete label;
   delete edit;
   delete comboBox;
   delete bmpButton;
}

//+------------------------------------------------------------------+
//| Show RE                                                          |
//+------------------------------------------------------------------+
void CRiskExposure::show(void) {

   label.maxInt.Show();
   label.maxTrades.Show();
   edit.maxTrades.Show();
   bmpButton.maxTrades.Show();
   label.maxLots.Show();
   edit.maxLots.Show();
   bmpButton.maxLots.Show();
   label.maxExposure.Show();
   edit.maxExposure.Show();
   bmpButton.maxExposure.Show();
   label.maxPositionValue.Show();
   edit.maxPositionValue.Show();
   bmpButton.maxPositionValue.Show();
   label.totalExposure_int.Show();
   button.currencyRiskSettings.Show();
   button.percentageRiskSettings.Show();
   
   label.totalTrades.Show();
   edit.totalTrades.Show();
   label.totalLots.Show();
   edit.totalLots.Show();
   label.totalExposure.Show();
   edit.totalExposure.Show();
   label.totalPositionValue.Show();
   edit.totalPositionValue.Show();
   button.currencyTotalExposure.Show();
   button.percentageTotalExposure.Show();
   
   label.tradeSelect.Show();
   comboBox.tradeExposure.Show();
   label.tradeExposure.Show();
   label.tradeSelect_int.Show();
   edit.tradeExposure.Show();
   label.tradePositionValue.Show();
   edit.tradePositionValue.Show();
   button.currencyIndivualTradeExposure.Show();
   button.percentageIndivualTradeExposure.Show();
}

//+------------------------------------------------------------------+
//| Hide_RE                                                          |
//+------------------------------------------------------------------+
void CRiskExposure::hide(void) {

   label.maxInt.Hide();
   label.maxTrades.Hide();
   edit.maxTrades.Hide();
   bmpButton.maxTrades.Hide();
   label.maxLots.Hide();
   edit.maxLots.Hide();
   bmpButton.maxLots.Hide();
   label.maxExposure.Hide();
   edit.maxExposure.Hide();
   bmpButton.maxExposure.Hide();
   label.maxPositionValue.Hide();
   edit.maxPositionValue.Hide();
   bmpButton.maxPositionValue.Hide();
   label.totalExposure_int.Hide();
   button.currencyRiskSettings.Hide();
   button.percentageRiskSettings.Hide();
   
   label.totalTrades.Hide();
   edit.totalTrades.Hide();
   label.totalLots.Hide();
   edit.totalLots.Hide();
   label.totalExposure.Hide();
   edit.totalExposure.Hide();
   label.totalPositionValue.Hide();
   edit.totalPositionValue.Hide();
   button.currencyTotalExposure.Hide();
   button.percentageTotalExposure.Hide();
   
   label.tradeSelect.Hide();
   comboBox.tradeExposure.Hide();
   label.tradeExposure.Hide();
   label.tradeSelect_int.Hide();
   edit.tradeExposure.Hide();
   label.tradePositionValue.Hide();
   edit.tradePositionValue.Hide();
   button.currencyIndivualTradeExposure.Hide();
   button.percentageIndivualTradeExposure.Hide();
}
