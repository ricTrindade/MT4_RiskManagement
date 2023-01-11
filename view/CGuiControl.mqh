//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CGuiControl_
   #define CGuiControl_

//+------------------------------------------------------------------+
//| Include MT4 Libraries & Resources                                |
//+------------------------------------------------------------------+
#include "\window_tabs\main_window\CMainWindow.mqh"
#include "\window_tabs\position_size_calculator\CPositionSizeCalculator.mqh"
#include "\window_tabs\risk_exposure\CRiskExposure.mqh"

//+------------------------------------------------------------------+
//| Window State Enum                                                |
//+------------------------------------------------------------------+
enum Window {

   PositionSizeCalculator, 
   RiskExposure, 
   Minimised,
   o
}; 

//+------------------------------------------------------------------+
//| Window Control Custom Class                                      |
//+------------------------------------------------------------------+
class CGuiControl {

private:  

   int    mainFont_S;      
   int    subFont_S;   
   double SCALE; 
   string OBJ_CONTROL;
   Window OPEN_TAB;
    
public:

   //------------------------------
   // ApplicationTabs
   //------------------------------
   CMainWindow                *mainWindow;
   CPositionSizeCalculatorTab *positionSizeCalculator;
   CRiskExposure              *riskExposure;

   //------------------------------
   //Constructor and Destructor
   //------------------------------
   CGuiControl();
   ~CGuiControl();
   
   //------------------------------
   //Accessor Functions
   //------------------------------
   int    GetMainFont_S()      {return mainFont_S;}
   int    GetsubFont_S()       {return subFont_S;}
   Window GetOPEN_TAB()        {return OPEN_TAB;}
   string GetOBJ_CONTROL()     {return OBJ_CONTROL;}
   double GetScale()           {return SCALE;}
    
   //------------------------------
   //'Set Value' Functions
   //------------------------------
   void SetMainFont_S      (int    value) {mainFont_S      = value;}
   void SetsubFont_S       (int    value) {subFont_S       = value;}
   void SetOPEN_TAB        (Window value) {OPEN_TAB        = value;}
   void SetOBJ_CONTROL     (string value) {OBJ_CONTROL     = value;}
   void SetScale           (double value) {SCALE           = value;}
   
   //------------------------------   
   //Member Functions
   //------------------------------
   void   ResetContructor();
   void   WindowMin();
   bool   IsMin();
   void   WindowMax();
   Window Check_Tab();
   int    ScaledFont(int i);
   int    ScaledPixel(int i);
};

//+------------------------------------------------------------------+
//| Window Control Custom Class - Constructor                        |
//+------------------------------------------------------------------+
CGuiControl::CGuiControl(void) {

   mainWindow             = new CMainWindow();
   positionSizeCalculator = new CPositionSizeCalculatorTab();
   riskExposure           = new CRiskExposure();


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

   OPEN_TAB = o;
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CGuiControl::~CGuiControl(void) {

   delete mainWindow;
   delete positionSizeCalculator;
   delete riskExposure;
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Manual Version of Constructor      |
//+------------------------------------------------------------------+
void CGuiControl::ResetContructor(void) {

   mainWindow.width               = ScaledPixel(383); //Main Window Width
   mainFont_S                     = ScaledFont(10);
   subFont_S                      = ScaledFont(8);
   positionSizeCalculator.height  = ScaledPixel(400);
   riskExposure.height            = ScaledPixel(520);
   positionSizeCalculator.crShift = ScaledPixel(-120); //Shift
   riskExposure.crShift           = ScaledPixel(120);
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Scaled Font                        |
//+------------------------------------------------------------------+
int CGuiControl::ScaledFont(int i) {

   int standard = 96;
   int DPI = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
   return int((i*standard/DPI) * SCALE);
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Scaled Pixel                       |
//+------------------------------------------------------------------+
int CGuiControl::ScaledPixel(int i) {
   
   return int(i*SCALE);
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Minimise                           |
//+------------------------------------------------------------------+
void CGuiControl::WindowMin(void) {

   mainWindow.copyRightsLabel.Hide();
   positionSizeCalculator.button.tabPSC.Hide();
   riskExposure.button.tabRiskExposure.Hide();
   positionSizeCalculator.hide();
   riskExposure.hide();
   mainWindow.windowDialog.Height(30);
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Is it Minimised                    |
//+------------------------------------------------------------------+
bool CGuiControl::IsMin(void) {

   if (mainWindow.copyRightsLabel.IsVisible() == false) return true;
   return false; 
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Which Tab is open                  |
//+------------------------------------------------------------------+
Window CGuiControl::Check_Tab(void) {

   static Window TAB;
   
   if (positionSizeCalculator.label.riskPerTrade.IsVisible() == true) {
      TAB = PositionSizeCalculator;
      return TAB;
   }
   else if (riskExposure.label.maxInt.IsVisible() == true) {
      TAB = RiskExposure;
      return TAB;
   }
   return TAB;
} 

//+------------------------------------------------------------------+
//| Window Control Custom Class - Maximise                           |
//+------------------------------------------------------------------+
void CGuiControl::WindowMax(void) {

   if(OPEN_TAB == PositionSizeCalculator) {
   
      mainWindow.windowDialog.Height(positionSizeCalculator.height);
      positionSizeCalculator.show();
      mainWindow.copyRightsLabel.Show(); 
      positionSizeCalculator.button.tabPSC.Show();
      riskExposure.button.tabRiskExposure.Show();
   }
   
   if(OPEN_TAB == RiskExposure) {
   
      mainWindow.windowDialog.Height(riskExposure.height);
      riskExposure.show();
      mainWindow.copyRightsLabel.Show();
      mainWindow.copyRightsLabel.Show(); 
      positionSizeCalculator.button.tabPSC.Show();
      riskExposure.button.tabRiskExposure.Show();
   }
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif