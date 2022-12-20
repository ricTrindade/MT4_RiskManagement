//+------------------------------------------------------------------+
//| Include MT4 Defined Libraries                                    |
//+------------------------------------------------------------------+
#include "WINDOW_ENUM.mqh"

//+------------------------------------------------------------------+
//| Window Control Custom Class                                      |
//+------------------------------------------------------------------+
class CWinControl {

private:  
   
   int MainWindowWidth;
   int MainFont_S;      
   int subFont_S;      
   int PSC_Height;
   int RE_Height;     
   int PSC_CR_Shift;  
   int RE_CR_Shift;   
   
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
   CWinControl();
   
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
   
   //------------------------------   
   //Member Functions
   //------------------------------
   void ResetContructor();
   void WindowMin();
   bool IsMin();
   void WindowMax();
   int  Check_Tab();
   int  ScaledFont(int i);
   int  ScaledPixel(int i);
   void Show_PSC();
   void Hide_PSC();
   void Show_RE();
   void Hide_RE();
};