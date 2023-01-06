//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef COnInit_
   #define COnInit_

//+------------------------------------------------------------------+
//| Include 'Tabs' Classes                                           |
//+------------------------------------------------------------------+
#include "tabs\CMainWindowInitializer.mqh" 
#include "tabs\CPositionSizeCalculatorInitializer.mqh" 
#include "tabs\CRiskExposureInitializer.mqh" 

//+------------------------------------------------------------------+
//| Expert initialization Class                                      |
//+------------------------------------------------------------------+
class COnInit {

private:  

public:

   // Tabs
   CMainWindowInitializer             *mainWindow;
   CPositionSizeCalculatorInitializer *positionSizeCalculator;
   CRiskExposureInitializer           *riskExposure;
   
   // Constructor
   COnInit();

   // Methods 
   bool licenceValidation(string licenceKey);
   void finaliseSetUp(CGuiControl &gui, Window firstWindow, double scale);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
COnInit::COnInit() {
      
   mainWindow             = new CMainWindowInitializer;
   positionSizeCalculator = new CPositionSizeCalculatorInitializer;
   riskExposure           = new CRiskExposureInitializer;
}

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
//| finaliseSetUp Method Defenition                                  |
//+------------------------------------------------------------------+
void finaliseSetUp(CGuiControl &gui, Window firstWindow, double scale) {
      
   if (gui.GetCopyFirstWindow() == -1 || gui.GetCopyScale() != scale){

      //PositionSizeCalculator
      if(firstWindow == PositionSizeCalculator) {

         gui.SetOPEN_TAB(PositionSizeCalculator);
         gui.riskExposure.hide(); 
         gui.positionSizeCalculator.show(); 
         gui.mainWindow.windowDialog.Height(gui.positionSizeCalculator.height); 
         gui.mainWindow.copyRightsLabel.Shift(gui.ScaledPixel(5),gui.positionSizeCalculator.height-gui.ScaledPixel(50));
      }
      
      //RiskExposure
      if(firstWindow == RiskExposure) {
      
         gui.SetOPEN_TAB(RiskExposure); 
         gui.positionSizeCalculator.hide();
         gui.riskExposure.show(); 
         gui.mainWindow.windowDialog.Height(gui.riskExposure.height);
         gui.mainWindow.copyRightsLabel.Shift(gui.ScaledPixel(5),gui.riskExposure.height-gui.ScaledPixel(50));
      }   
      
      //Minimised
      if (firstWindow == Minimised) {
         
         gui.mainWindow.minMaxBmpButton.Pressed(true);
         gui.WindowMin();
         if (gui.GetOPEN_TAB() == 2) gui.mainWindow.copyRightsLabel.Shift(gui.ScaledPixel(5),gui.riskExposure.height-gui.ScaledPixel(50));
         else gui.mainWindow.copyRightsLabel.Shift(gui.ScaledPixel(5),gui.positionSizeCalculator.height-gui.ScaledPixel(50));
      }
   }

   else {
   
      //PositionSizeCalculator
      if(gui.GetCopyFirstWindow() == PositionSizeCalculator) {

         gui.SetOPEN_TAB(PositionSizeCalculator);
         gui.riskExposure.hide();
         gui.positionSizeCalculator.show();
         gui.mainWindow.windowDialog.Height(gui.positionSizeCalculator.height);
         gui.mainWindow.copyRightsLabel.Shift(gui.ScaledPixel(5),gui.positionSizeCalculator.height-gui.ScaledPixel(50));
      }
      
      //RiskExposure
      if(gui.GetCopyFirstWindow() == RiskExposure) {
      
         gui.SetOPEN_TAB(RiskExposure);
         gui.positionSizeCalculator.hide();
         gui.riskExposure.show();
         gui.mainWindow.windowDialog.Height(gui.riskExposure.height);
         gui.mainWindow.copyRightsLabel.Shift(gui.ScaledPixel(5),gui.riskExposure.height-gui.ScaledPixel(50));
      }   
      
      //Minimised
      if (gui.GetCopyFirstWindow() == Minimised) {
         
         gui.mainWindow.minMaxBmpButton.Pressed(true);
         gui.WindowMin();
         if (gui.GetOPEN_TAB() == 2) gui.mainWindow.copyRightsLabel.Shift(5,gui.riskExposure.height-50);
         else gui.mainWindow.copyRightsLabel.Shift(gui.ScaledPixel(5),gui.positionSizeCalculator.height-gui.ScaledPixel(50));
      }
   }  
   
   //****************************************************************
   //Run Everything on Main Window
   //****************************************************************
   gui.mainWindow.windowDialog.Run(); 
   
   gui.SetCopyScale(scale);
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif