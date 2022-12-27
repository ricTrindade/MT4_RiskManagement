//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef COnInit_
   #define COnInit_

//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files\OANDA - MetaTrader\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 


//+------------------------------------------------------------------+
//| Expert initialization Class                                      |
//+------------------------------------------------------------------+
class COnInit {

private:  

public:

   bool licenceValidation(string licenceKey);
   void createMainWindow(CGuiControl &gui, double scale);
   void createPositionSizeCalculatorTab(CGuiControl &gui);
   void createRiskExposureTab(CGuiControl &gui);
};

//+------------------------------------------------------------------+
//| licenceValidation Method Defenition                              |
//+------------------------------------------------------------------+

/*
This method is responsible for check the licenceKey 
that the user has entered
*/

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
void COnInit::createMainWindow(CGuiControl &gui, double scale) {
   
   //Reset Constructor if needed, adjust if user changes scale during the execution of the program
   gui.SetScale(scale);
   if(gui.GetCopyScale() != scale) gui.ResetContructor(); 
   
   if(gui.GetCopyFirstWindow()==-1 || gui.GetCopyScale() != scale) {
      gui.mainWindow.windowDialog.Create(0,"MainWindow",0,0,0,gui.mainWindow.width,gui.riskExposure.height);        
      gui.mainWindow.windowDialog.Shift(gui.ScaledPixel(400),0);
   }
   
   //Remember the position of the windown when Changing Assets or TimeFrames
   else gui.mainWindow.windowDialog.Create(0,
                          "MainWindow",
                          0,
                          gui.mainWindow.windowDialog.Left(),
                          gui.mainWindow.windowDialog.Top(),
                          gui.mainWindow.width+gui.mainWindow.windowDialog.Left(),
                          gui.riskExposure.height+gui.mainWindow.windowDialog.Top());
   
   gui.mainWindow.windowDialog.Caption("Risk Manager v2.00 BETA");
   ObjectSetInteger(0,gui.mainWindow.windowDialog.Name()+"Caption",OBJPROP_FONTSIZE,gui.GetMainFont_S());
   
   //CopyRights
   CAppDialog *g = gui.mainWindow.windowDialog;
   gui.mainWindow.copyRightsLabel.Create(0,"CopyRights",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   gui.mainWindow.windowDialog.Add(gui.mainWindow.copyRightsLabel);
   gui.mainWindow.copyRightsLabel.Text("©MrPragmatic");
   gui.mainWindow.copyRightsLabel.FontSize(gui.GetMainFont_S());
   
   //Personalised Min/Max Button
   gui.mainWindow.windowDialog.m_button_minmax.Hide();
   gui.mainWindow.minMaxBmpButton.Create(0,"Min_Max",0,0,0,0,0);
   gui.mainWindow.minMaxBmpButton.BmpNames("::Include\\Controls\\res\\Up.bmp",
                    "::Include\\Controls\\res\\Down.bmp"); 
   gui.mainWindow.windowDialog.Add(gui.mainWindow.minMaxBmpButton);
   gui.mainWindow.minMaxBmpButton.Shift(gui.ScaledPixel(340),-18);
}

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif