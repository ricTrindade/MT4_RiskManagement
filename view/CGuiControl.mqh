//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CGuiControl_
   #define CGuiControl_

//+------------------------------------------------------------------+
//| Include MT4 Libraries & Resources                                |
//+------------------------------------------------------------------+
#include "PreExistingLibraries\MT4Libraries.mqh"

//+------------------------------------------------------------------+
//| Window State Enum                                                |
//+------------------------------------------------------------------+
enum Window {PositionSizeCalculator, 
             RiskExposure, 
             Minimised}; 

//+------------------------------------------------------------------+
//| Window Control Custom Class                                      |
//+------------------------------------------------------------------+
class CGuiControl {

private:  
   
   int    MainWindowWidth;
   int    MainFont_S;      
   int    subFont_S;      
   int    PSC_Height;
   int    RE_Height;     
   int    PSC_CR_Shift;  
   int    RE_CR_Shift;  
   double SCALE; 
   double CopyScale;
   
   /*Currency or Account Button*/
   int RS;
   int TE;
   int ITE;
   
   string OBJ_CONTROL;
   int    OPEN_TAB;
   
   Window CopyFirstWindow;
    
public:

   //------------------------------
   //Constructor and Destructor
   //------------------------------
   CGuiControl();
   
   //------------------------------
   //Accessor Functions
   //------------------------------
   int    GetMainWindowWidth() {return MainWindowWidth;}
   int    GetMainFont_S()      {return MainFont_S;}
   int    GetsubFont_S()       {return subFont_S;}
   int    GetPSC_Height()      {return PSC_Height;}
   int    GetRE_Height()       {return RE_Height;}
   int    GetPSC_CR_Shift()    {return PSC_CR_Shift;}
   int    GetRE_CR_Shift()     {return RE_CR_Shift;}
   
   int    GetRS()              {return RS;}
   int    GetTE()              {return TE;}
   int    GetITE()             {return ITE;}
   
   int    GetOPEN_TAB()        {return OPEN_TAB;}
   string GetOBJ_CONTROL()     {return OBJ_CONTROL;}
   Window GetCopyFirstWindow() {return CopyFirstWindow;}
   double GetCopyScale()       {return CopyScale;}
   double GetScale()           {return SCALE;}
    
   //------------------------------
   //'Set Value' Functions
   //------------------------------
   void SetMainWindowWidth (int value)    {MainWindowWidth = value;}
   void SetMainFont_S      (int value)    {MainFont_S      = value;}
   void SetsubFont_S       (int value)    {subFont_S       = value;}
   void SetPSC_Height      (int value)    {PSC_Height      = value;}
   void SetRE_Height       (int value)    {RE_Height       = value;}
   void SetPSC_CR_Shift    (int value)    {PSC_CR_Shift    = value;}
   void SetRE_CR_Shift     (int value)    {RE_CR_Shift     = value;}
   
   void SetRS              (int value)    {RS  = value;}
   void SetTE              (int value)    {TE  = value;}
   void SetITE             (int value)    {ITE = value;}
   
   void SetOPEN_TAB        (int    value) {OPEN_TAB        = value;}
   void SetOBJ_CONTROL     (string value) {OBJ_CONTROL     = value;}
   void SetCopyFirstWindow (Window value) {CopyFirstWindow = value;}
   
   void SetCopyScale       (double value) {CopyScale = value;}
   void SetScale           (double value) {SCALE = value;}
   
   //------------------------------   
   //Member Functions
   //------------------------------
   void ResetContructor();
   void WindowMin(CLabel &copyRights,
                  CButton &tabPSC,
                  CButton &tabRisk,
                  CAppDialog &mainWindow);
   bool IsMin(CLabel &copyRights);
   void WindowMax();
   int  Check_Tab(CLabel &riskPerTrade, CLabel &maxInt);
   int  ScaledFont(int i);
   int  ScaledPixel(int i);
   void Show_PSC();
   void Hide_PSC();
   void Show_RE();
   void Hide_RE();
};

//+------------------------------------------------------------------+
//| Window Control Custom Class - Constructor                        |
//+------------------------------------------------------------------+
CGuiControl::CGuiControl(void) {

   MainWindowWidth = ScaledPixel(383); //Main Window Width
   MainFont_S      = ScaledFont(10);
   subFont_S       = ScaledFont(8);
   PSC_Height      = ScaledPixel(400);
   RE_Height       = ScaledPixel(520);
   PSC_CR_Shift    = ScaledPixel(-120); //Shifft
   RE_CR_Shift     = ScaledPixel(120);
   //CopyScale       = -1;
   
   /*Currency or Account Button*/
   RS  = 1;
   TE  = 1;
   ITE = 1;

   OPEN_TAB = 2;
   CopyFirstWindow = -1;
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Manual Version of Constructor      |
//+------------------------------------------------------------------+
void CGuiControl::ResetContructor(void) {

   MainWindowWidth = ScaledPixel(383); //Main Window Width
   MainFont_S      = ScaledFont(10);
   subFont_S       = ScaledFont(8);
   PSC_Height      = ScaledPixel(400);
   RE_Height       = ScaledPixel(520);
   PSC_CR_Shift    = ScaledPixel(-120); //Shifft
   RE_CR_Shift     = ScaledPixel(120);
   //CopyScale       = -1;
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
void CGuiControl::WindowMin(CLabel &copyRights,
                            CButton &tabPSC,
                            CButton &tabRisk,
                            CAppDialog &mainWindow) {

   copyRights.Hide();
   tabPSC.Hide();
   tabRisk.Hide();
   Hide_PSC();
   Hide_RE();
   mainWindow.Height(30);
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Is it Minimised                    |
//+------------------------------------------------------------------+
bool CGuiControl::IsMin(CLabel &copyRights) {

   if (copyRights.IsVisible() == false) return true;
   return false; 
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Which Tab is open                  |
//+------------------------------------------------------------------+
int CGuiControl::Check_Tab(CLabel &riskPerTrade, CLabel &maxInt) {

   static int TAB;
   
   if (riskPerTrade.IsVisible() == true) {
      TAB = 1;
      return TAB;
   }
   if (maxInt.IsVisible() == true) {
      TAB = 2;
      return TAB;
   }
   return TAB;
} 

//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif