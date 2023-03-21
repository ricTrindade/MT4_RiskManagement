//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include "components\CButtonTest.mqh"
#include "components\CLabelTest.mqh"

//+------------------------------------------------------------------+
//| Test tab class                                                   |
//+------------------------------------------------------------------+
class CTestTab {

public:

   int height;
   int crShift;

   // Components
   CButtonTest *button;
   CLabelTest  *label;
   
   // Constructor
   CTestTab();
   
   // Destructor
   ~CTestTab();
   
   // Member Functions
   void show();
   void hide();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTestTab::CTestTab() {

   button = new CButtonTest();
   label  = new CLabelTest();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTestTab::~CTestTab() {

   delete button;
   delete label;
}

//+------------------------------------------------------------------+
//| Show                                                             |
//+------------------------------------------------------------------+
void CTestTab::show(void) {

   label.test_label.Show();
}

//+------------------------------------------------------------------+
//| Hide                                                             |
//+------------------------------------------------------------------+
void CTestTab::hide(void) {

   label.test_label.Hide();
}

