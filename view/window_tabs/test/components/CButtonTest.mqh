//+------------------------------------------------------------------+
//| Component Files                                                  |
//+------------------------------------------------------------------+
#include <Controls/Button.mqh> 

//+------------------------------------------------------------------+
//| Test Buttons class                                               |
//+------------------------------------------------------------------+
class CButtonTest {

public:

   // Components 
   CButton *tabTest;
   
   // Constructor
   CButtonTest();
   
   // Destructor
   ~CButtonTest();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CButtonTest::CButtonTest(void) {
   
   tabTest = new CButton();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CButtonTest::~CButtonTest(void) {
   
   delete tabTest;
}
