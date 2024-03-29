//+------------------------------------------------------------------+
//| Include GUI Components                                           |
//+------------------------------------------------------------------+
#include "C:\Program Files (x86)\MetaTrader 4\MQL4\Experts\MT4_RiskManagement\view\CGuiControl.mqh" 

//+------------------------------------------------------------------+
//| Main Window Initialiser class                                    |
//+------------------------------------------------------------------+
class CMainWindowInitializer {

   bool firstInit;

public:
   
   // Constructor
   CMainWindowInitializer(bool first_Init) {firstInit = first_Init;}
   
   void create(CGuiControl &gui);
   void finaliseSetUp(CGuiControl &gui, Window firstWindow);
};

//+------------------------------------------------------------------+
//| create Method Defenition                                         |
//+------------------------------------------------------------------+
void CMainWindowInitializer::create(CGuiControl &gui) {
   
   // Main Window
   CAppDialog *window = gui.mainWindow.windowDialog;
   window.Create(0,"MainWindow",0,0,0,gui.mainWindow.width,gui.riskExposure.height);        
   window.Shift(gui.ScaledPixel(400),0);
   window.Caption("Risk Manager v2.00 BETA");
   ObjectSetInteger(0,window.Name()+"Caption",OBJPROP_FONTSIZE,gui.GetMainFont_S());
   
   //CopyRights
   CLabel *copyRights = gui.mainWindow.copyRightsLabel;
   copyRights.Create(0,"CopyRights",0,0,0,gui.ScaledPixel(45),gui.ScaledPixel(5));
   window.Add(copyRights);
   copyRights.Text("©MrPragmatic");
   copyRights.FontSize(gui.GetMainFont_S());
   
   //Personalised Min/Max Button
   CBmpButton *minMax = gui.mainWindow.minMaxBmpButton;
   window.m_button_minmax.Hide();
   minMax.Create(0,"Min_Max",0,0,0,0,0);
   minMax.BmpNames("::Include\\Controls\\res\\Up.bmp",
                   "::Include\\Controls\\res\\Down.bmp"); 
   window.Add(minMax);
   minMax.Shift(gui.ScaledPixel(340),-18);
}

//+------------------------------------------------------------------+
//| finaliseSetUp Method Defenition                                  |
//+------------------------------------------------------------------+
void CMainWindowInitializer::finaliseSetUp(CGuiControl &gui, Window firstWindow) {
   
   // Pointers 
   CAppDialog *window = gui.mainWindow.windowDialog;
   CBmpButton *minMax = gui.mainWindow.minMaxBmpButton;
   CLabel *copyRights = gui.mainWindow.copyRightsLabel;

   //PositionSizeCalculator
   if(firstWindow == PositionSizeCalculator) {

      gui.SetOPEN_TAB(PositionSizeCalculator);
      gui.riskExposure.hide(); 
      gui.positionSizeCalculator.show(); 
      window.Height(gui.positionSizeCalculator.height); 
      copyRights.Shift(gui.ScaledPixel(5),gui.positionSizeCalculator.height-gui.ScaledPixel(50));
   }
   
   //RiskExposure
   else if(firstWindow == RiskExposure) {
   
      gui.SetOPEN_TAB(RiskExposure); 
      gui.positionSizeCalculator.hide();
      gui.riskExposure.show(); 
      window.Height(gui.riskExposure.height);
      copyRights.Shift(gui.ScaledPixel(5),gui.riskExposure.height-gui.ScaledPixel(50));
   }   
   
   //Minimised
   else if (firstWindow == Minimised) {
      
      gui.SetOPEN_TAB(PositionSizeCalculator);
      gui.riskExposure.hide(); 
      gui.positionSizeCalculator.show(); 
      window.Height(gui.positionSizeCalculator.height); 
      copyRights.Shift(gui.ScaledPixel(5),gui.positionSizeCalculator.height-gui.ScaledPixel(50));
      minMax.Pressed(true);
      gui.WindowMin();
   }
   
   //****************************************************************
   //Run Everything on Main Window
   //****************************************************************
   window.Run(); 
}