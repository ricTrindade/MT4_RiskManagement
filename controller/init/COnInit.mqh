//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef COnInit_
   #define COnInit_

//+------------------------------------------------------------------+
//| Include External Resources                                       |
//+------------------------------------------------------------------+
#include "tabs\CMainWindowInitializer.mqh" 
#include "tabs\CPositionSizeCalculatorInitializer.mqh" 
#include "tabs\CRiskExposureInitializer.mqh" 

//+------------------------------------------------------------------+
//| Expert initialization Class                                      |
//+------------------------------------------------------------------+
class COnInit {

public:

   // Application Tabs
   CMainWindowInitializer             *mainWindow;
   CPositionSizeCalculatorInitializer *positionSizeCalculator;
   CRiskExposureInitializer           *riskExposure;
   
   // Constructor
   COnInit();
   
   // Destructor
   ~COnInit();

   // Methods 
   bool licenceValidation(string licenceKey);
};
//+------------------------------------------------------------------+
//| Constructor's Body                                               |
//+------------------------------------------------------------------+
COnInit::COnInit() {
   
   // Initialise Objects    
   mainWindow             = new CMainWindowInitializer(firstInit);
   positionSizeCalculator = new CPositionSizeCalculatorInitializer();
   riskExposure           = new CRiskExposureInitializer();
}

//+------------------------------------------------------------------+
//| Destructor's Body                                                |
//+------------------------------------------------------------------+
COnInit::~COnInit(void) {

   delete mainWindow;
   delete positionSizeCalculator;
   delete riskExposure;
}

//+------------------------------------------------------------------+
//| licenceValidation - Method's Body                                |
//+------------------------------------------------------------------+
bool COnInit::licenceValidation(string licenceKey) {
   
   string Pass;

   switch (Month()) {
   
      case 1:  Pass = ""; break;
      case 2:  Pass = ""; break;
      case 3:  Pass = ""; break;
      case 4:  Pass = ""; break;
      case 5:  Pass = ""; break;
      case 6:  Pass = ""; break;
      case 7:  Pass = ""; break;
      case 8:  Pass = ""; break;
      case 9:  Pass = ""; break;
      case 10: Pass = ""; break;
      case 11: Pass = ""; break;
      case 12: Pass = ""; break;
      default: Pass = ""; break;
   }
   
   if(Pass != licenceKey) {
   
      PlaySound("alert2");
      MessageBox("Incorrect Licence Key - Please enter a valid key. For more information" + 
      " contact MrPragmatic.","Invalid Licence",MB_OK);
      
      return false;
   }
   
   return true;
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif