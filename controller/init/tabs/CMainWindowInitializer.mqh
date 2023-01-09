//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

//+------------------------------------------------------------------+
//| Main Window Initialiser class                                    |
//+------------------------------------------------------------------+
class CMainWindowInitializer {

public:

   void create(CGuiControl &gui, double scale);
};

//+------------------------------------------------------------------+
//| create Method Defenition                                         |
//+------------------------------------------------------------------+
void CMainWindowInitializer::create(CGuiControl &gui, double scale) {
   
   //Reset Constructor if needed, adjust if user changes scale during the execution of the program
   gui.SetScale(scale);
   if(gui.GetCopyScale() != scale) gui.ResetContructor(); 
   
   if(gui.GetCopyFirstWindow() == -1 || gui.GetCopyScale() != scale) {
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