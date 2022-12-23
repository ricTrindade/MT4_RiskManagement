//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef COnInit_
   #define COnInit_

//+------------------------------------------------------------------+
//| Expert initialization Class                                      |
//+------------------------------------------------------------------+
class COnInit {

private:  

public:

   bool licenceValidation(string licenceKey);
   void createMainWindow();
};

//+------------------------------------------------------------------+
//| licenceValidation Method Defenition                              |
//+------------------------------------------------------------------+
bool COnInit::licenceValidation(string licenceKey) {
   
   string Pass;

   switch (Month()) {
   
      case 1:  Pass = " "; break;
      case 2:  Pass = " "; break;
      case 3:  Pass = " "; break;
      case 4:  Pass = " "; break;
      case 5:  Pass = " "; break;
      case 6:  Pass = " "; break;
      case 7:  Pass = " "; break;
      case 8:  Pass = " "; break;
      case 9:  Pass = " "; break;
      case 10: Pass = " "; break;
      case 11: Pass = " "; break;
      case 12: Pass = " "; break;
      default: Pass = " "; break;
   }
   
   if(Pass != licenceKey) {
   
      PlaySound("alert2");
      MessageBox("Incorrect Licence Key - Please enter a valid key. For more information" + 
      " contact MrPragmatic.","Invalid Licence",MB_OK);
      
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| createMainWindow Method Defenition                               |
//+------------------------------------------------------------------+
void COnInit::createMainWindow() {
   
   
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif