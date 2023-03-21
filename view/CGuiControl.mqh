//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CGuiControl_
   #define CGuiControl_

//+------------------------------------------------------------------+
//| Include External Resources                                       |
//+------------------------------------------------------------------+
#include "\window_tabs\main_window\CMainWindow.mqh"
#include "\window_tabs\position_size_calculator\CPositionSizeCalculator.mqh"
#include "\window_tabs\risk_exposure\CRiskExposure.mqh"
#include "\window_tabs\test\CTest.mqh"

//+------------------------------------------------------------------+
//| Window State Enum                                                |
//+------------------------------------------------------------------+
enum Window {

   PositionSizeCalculator, 
   RiskExposure, 
   Test,
   Minimised,
}; 

//+------------------------------------------------------------------+
//| Window Control Class                                             |
//+------------------------------------------------------------------+
class CGuiControl {

private:  

   // Fields 
   int    mainFont_S;      
   int    subFont_S;   
   double SCALE; 
   string OBJ_CONTROL;
   Window OPEN_TAB;
    
public:

   // Application Tabs
   CMainWindow                *mainWindow;
   CPositionSizeCalculatorTab *positionSizeCalculator;
   CRiskExposure              *riskExposure;
   CTestTab                   *test;   

   // Constructor
   CGuiControl(double scale);
   
   // Destructor
   ~CGuiControl();
   
   // Getters
   int    GetMainFont_S()  {return mainFont_S;}
   int    GetsubFont_S()   {return subFont_S;}
   Window GetOPEN_TAB()    {return OPEN_TAB;}
   string GetOBJ_CONTROL() {return OBJ_CONTROL;}
    
   // Setters
   void SetMainFont_S  (int    value) {mainFont_S      = value;}
   void SetsubFont_S   (int    value) {subFont_S       = value;}
   void SetOPEN_TAB    (Window value) {OPEN_TAB        = value;}
   void SetOBJ_CONTROL (string value) {OBJ_CONTROL     = value;}
   
   // Methods
   void   ResetContructor();
   void   WindowMin();
   bool   IsMin();
   void   WindowMax();
   Window Check_Tab();
   int    ScaledFont(int i);
   int    ScaledPixel(int i);
};

//+------------------------------------------------------------------+
//| Constructor's Body                                               |
//+------------------------------------------------------------------+
CGuiControl::CGuiControl(double scale) {

   mainWindow             = new CMainWindow();
   positionSizeCalculator = new CPositionSizeCalculatorTab();
   riskExposure           = new CRiskExposure();
   test                   = new CTestTab();

   SCALE                          = scale;
   mainWindow.width               = ScaledPixel(383); //Main Window Width
   mainFont_S                     = ScaledFont(10);
   subFont_S                      = ScaledFont(8);
   positionSizeCalculator.height  = ScaledPixel(400);
   riskExposure.height            = ScaledPixel(520);
   positionSizeCalculator.crShift = ScaledPixel(-120); //Shift
   riskExposure.crShift           = ScaledPixel(120);
   
   /*Currency or Account Button*/
   riskExposure.RS  = 1;
   riskExposure.TE  = 1;
   riskExposure.ITE = 1;
}

//+------------------------------------------------------------------+
//| Destructor's Body                                                |
//+------------------------------------------------------------------+
CGuiControl::~CGuiControl(void) {

   delete mainWindow;
   delete positionSizeCalculator;
   delete riskExposure;
   delete test;
}

//+------------------------------------------------------------------+
//| Scaled Font - Method's Body                                      |
//+------------------------------------------------------------------+
int CGuiControl::ScaledFont(int i) {

   int standard = 96;
   int DPI = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   return int((i*standard/DPI) * SCALE);
}

//+------------------------------------------------------------------+
//| Scaled Pixel - Method's Body                                     |
//+------------------------------------------------------------------+
int CGuiControl::ScaledPixel(int i) {
   
   return int(i*SCALE);
}

//+------------------------------------------------------------------+
//| Minimise - Method's Body                                         |
//+------------------------------------------------------------------+
void CGuiControl::WindowMin(void) {

   mainWindow.copyRightsLabel.Hide();
   positionSizeCalculator.button.tabPSC.Hide();
   riskExposure.button.tabRiskExposure.Hide();
   test.button.tabTest.Hide();
   positionSizeCalculator.hide();
   riskExposure.hide();
   test.hide();
   mainWindow.windowDialog.Height(30);
}

//+------------------------------------------------------------------+
//| Is it Minimised - Method's Body                                  |
//+------------------------------------------------------------------+
bool CGuiControl::IsMin(void) {

   if (mainWindow.copyRightsLabel.IsVisible() == false) return true;
   return false; 
}

//+------------------------------------------------------------------+
//| Which Tab is open - Method's Body                                |
//+------------------------------------------------------------------+
Window CGuiControl::Check_Tab(void) {

   static Window TAB;
   
   if (positionSizeCalculator.label.riskPerTrade.IsVisible() == true) {
      TAB = PositionSizeCalculator;
      return TAB;
   }
   if (riskExposure.label.maxInt.IsVisible() == true) {
      TAB = RiskExposure;
      return TAB;
   }
   else if (test.label.test_label.IsVisible() == true) {
      TAB = Test;
      return TAB;
   }
   return TAB;
} 

//+------------------------------------------------------------------+
//| Maximise - Method's Body                                         |
//+------------------------------------------------------------------+
void CGuiControl::WindowMax(void) {

   if(OPEN_TAB == PositionSizeCalculator) {
   
      mainWindow.windowDialog.Height(positionSizeCalculator.height);
      positionSizeCalculator.show();
      mainWindow.copyRightsLabel.Show(); 
      test.button.tabTest.Show();
      positionSizeCalculator.button.tabPSC.Show();
      riskExposure.button.tabRiskExposure.Show();
   }
   
   if(OPEN_TAB == RiskExposure) {
   
      mainWindow.windowDialog.Height(riskExposure.height);
      riskExposure.show();
      mainWindow.copyRightsLabel.Show();
      test.button.tabTest.Show(); 
      positionSizeCalculator.button.tabPSC.Show();
      riskExposure.button.tabRiskExposure.Show();
   }
   
   if(OPEN_TAB == Test) {
      
      mainWindow.windowDialog.Height(test.height);
      test.show();
      mainWindow.copyRightsLabel.Show();
      test.button.tabTest.Show(); 
      positionSizeCalculator.button.tabPSC.Show();
      riskExposure.button.tabRiskExposure.Show();
   }
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif