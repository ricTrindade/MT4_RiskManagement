//+--------------------+
//| Preprocessor Check |
//+--------------------+
#ifndef CGuiControl_
   #define CGuiControl_

//+------------------------------------------------------------------+
//| Include MT4 Libraries & Resources                                |
//+------------------------------------------------------------------+
#include "\window_tabs\main_window\SMainWindow.mqh"
#include "\window_tabs\position_size_calculator\SPositionSizeCalculator.mqh"
#include "\window_tabs\risk_exposure\SRiskExposure.mqh"

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
   
   // Fields
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
   // ApplicationTabs
   //------------------------------
   SMainWindow             mainWindow;
   SPositionSizeCalculator positionSizeCalculator;
   SRiskExposure           riskExposure;

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
                            CAppDialog &mainWindows) {

   copyRights.Hide();
   tabPSC.Hide();
   tabRisk.Hide();
   Hide_PSC();
   Hide_RE();
   mainWindows.Height(30);
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

//+------------------------------------------------------------------+
//| Window Control Custom Class - Maximise                           |
//+------------------------------------------------------------------+
void CGuiControl::WindowMax(void) {

   if(OPEN_TAB == 1) {
      mainWindow.windowDialog.Height(PSC_Height);
      Show_PSC();
      mainWindow.copyRightsLabel.Show(); 
      positionSizeCalculator.button.tabPSC.Show();
      riskExposure.button.tabRiskExposure.Show();
   }
   
   if(OPEN_TAB == 2) {
      mainWindow.windowDialog.Height(RE_Height);
      Show_RE();
      mainWindow.copyRightsLabel.Show();
      mainWindow.copyRightsLabel.Show(); 
      positionSizeCalculator.button.tabPSC.Show();
      riskExposure.button.tabRiskExposure.Show();
   }
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Hide RE                            |
//+------------------------------------------------------------------+
void CGuiControl::Hide_RE(void) {

   riskExposure.label.maxInt.Hide();
   riskExposure.label.maxTrades.Hide();
   riskExposure.edit.maxTrades.Hide();
   riskExposure.bmpButton.maxTrades.Hide();
   riskExposure.label.maxLots.Hide();
   riskExposure.edit.maxLots.Hide();
   riskExposure.bmpButton.maxLots.Hide();
   riskExposure.label.maxExposure.Hide();
   riskExposure.edit.maxExposure.Hide();
   riskExposure.bmpButton.maxExposure.Hide();
   riskExposure.label.maxPositionValue.Hide();
   riskExposure.edit.maxPositionValue.Hide();
   riskExposure.bmpButton.maxPositionValue.Hide();
   riskExposure.label.totalExposure_int.Hide();
   riskExposure.button.currencyRiskSettings.Hide();
   riskExposure.button.percentageRiskSettings.Hide();
   
   riskExposure.label.totalTrades.Hide();
   riskExposure.edit.totalTrades.Hide();
   riskExposure.label.totalLots.Hide();
   riskExposure.edit.totalLots.Hide();
   riskExposure.label.totalExposure.Hide();
   riskExposure.edit.totalExposure.Hide();
   riskExposure.label.totalPositionValue.Hide();
   riskExposure.edit.totalPositionValue.Hide();
   riskExposure.button.currencyTotalExposure.Hide();
   riskExposure.button.percentageTotalExposure.Hide();
   
   riskExposure.label.tradeSelect.Hide();
   riskExposure.comboBox.tradeExposure.Hide();
   riskExposure.label.tradeExposure.Hide();
   riskExposure.label.tradeSelect_int.Hide();
   riskExposure.edit.tradeExposure.Hide();
   riskExposure.label.tradePositionValue.Hide();
   riskExposure.edit.tradePositionValue.Hide();
   riskExposure.button.currencyIndivualTradeExposure.Hide();
   riskExposure.button.percentageIndivualTradeExposure.Hide();
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Show RE                            |
//+------------------------------------------------------------------+
void CGuiControl::Show_RE(void) {

   riskExposure.label.maxInt.Show();
   riskExposure.label.maxTrades.Show();
   riskExposure.edit.maxTrades.Show();
   riskExposure.bmpButton.maxTrades.Show();
   riskExposure.label.maxLots.Show();
   riskExposure.edit.maxLots.Show();
   riskExposure.bmpButton.maxLots.Show();
   riskExposure.label.maxExposure.Show();
   riskExposure.edit.maxExposure.Show();
   riskExposure.bmpButton.maxExposure.Show();
   riskExposure.label.maxPositionValue.Show();
   riskExposure.edit.maxPositionValue.Show();
   riskExposure.bmpButton.maxPositionValue.Show();
   riskExposure.label.totalExposure_int.Show();
   riskExposure.button.currencyRiskSettings.Show();
   riskExposure.button.percentageRiskSettings.Show();
   
   riskExposure.label.totalTrades.Show();
   riskExposure.edit.totalTrades.Show();
   riskExposure.label.totalLots.Show();
   riskExposure.edit.totalLots.Show();
   riskExposure.label.totalExposure.Show();
   riskExposure.edit.totalExposure.Show();
   riskExposure.label.totalPositionValue.Show();
   riskExposure.edit.totalPositionValue.Show();
   riskExposure.button.currencyTotalExposure.Show();
   riskExposure.button.percentageTotalExposure.Show();
   
   riskExposure.label.tradeSelect.Show();
   riskExposure.comboBox.tradeExposure.Show();
   riskExposure.label.tradeExposure.Show();
   riskExposure.label.tradeSelect_int.Show();
   riskExposure.edit.tradeExposure.Show();
   riskExposure.label.tradePositionValue.Show();
   riskExposure.edit.tradePositionValue.Show();
   riskExposure.button.currencyIndivualTradeExposure.Show();
   riskExposure.button.percentageIndivualTradeExposure.Show();
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Hide positionSizeCalculator        |
//+------------------------------------------------------------------+
void CGuiControl::Hide_PSC(void) {

   positionSizeCalculator.label.riskPerTrade.Hide();
   positionSizeCalculator.edit.riskPerTrade.Hide();
   positionSizeCalculator.label.entryPrice.Hide();
   positionSizeCalculator.edit.entryPrice.Hide();
   positionSizeCalculator.button.priceCustom.Hide();
   positionSizeCalculator.button.priceBid.Hide();
   positionSizeCalculator.button.priceAsk.Hide();
   positionSizeCalculator.label.stopLoss.Hide();
   positionSizeCalculator.edit.stopLoss.Hide();
   positionSizeCalculator.button.calculate.Hide();
   positionSizeCalculator.label.riskInPoints.Hide();
   positionSizeCalculator.edit.riskInPoints.Hide();
   positionSizeCalculator.label.riskInCurrency.Hide();
   positionSizeCalculator.edit.riskInCurrency.Hide();
   positionSizeCalculator.label.contractSize.Hide();
   positionSizeCalculator.edit.contractSize.Hide();
   positionSizeCalculator.label.totalUnits.Hide();
   positionSizeCalculator.edit.totalLots.Hide();
   positionSizeCalculator.label.totalLots.Hide();
   positionSizeCalculator.edit.totalLots.Hide();
   positionSizeCalculator.label.positionValue.Hide();
   positionSizeCalculator.edit.positionValue.Hide();
}

//+------------------------------------------------------------------+
//| Window Control Custom Class - Show positionSizeCalculator        |
//+------------------------------------------------------------------+
void CGuiControl::Show_PSC(void) {

   positionSizeCalculator.label.riskPerTrade.Show();
   positionSizeCalculator.edit.riskPerTrade.Show();
   positionSizeCalculator.label.entryPrice.Show();
   positionSizeCalculator.edit.entryPrice.Show();
   positionSizeCalculator.button.priceCustom.Show();
   positionSizeCalculator.button.priceBid.Show();
   positionSizeCalculator.button.priceAsk.Show();
   positionSizeCalculator.label.stopLoss.Show();
   positionSizeCalculator.edit.stopLoss.Show();
   positionSizeCalculator.button.calculate.Show();
   positionSizeCalculator.label.riskInPoints.Show();
   positionSizeCalculator.edit.riskInPoints.Show();
   positionSizeCalculator.label.riskInCurrency.Show();
   positionSizeCalculator.edit.riskInCurrency.Show();
   positionSizeCalculator.label.contractSize.Show();
   positionSizeCalculator.edit.contractSize.Show();
   positionSizeCalculator.label.totalUnits.Show();
   positionSizeCalculator.edit.totalLots.Show();
   positionSizeCalculator.label.totalLots.Show();
   positionSizeCalculator.edit.totalLots.Show();
   positionSizeCalculator.label.positionValue.Show();
   positionSizeCalculator.edit.positionValue.Show();
}



//+--------------------+
//| Preprocessor Check |
//+--------------------+
#endif