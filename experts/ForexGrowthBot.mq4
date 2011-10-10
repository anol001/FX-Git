﻿/*
   Generated by EX4 TO MQ4 decompile Service 
   Website: http://www.ex4Tomq4.net 
   E-mail : info@ex4Tomq4.net 
*/
#property copyright "Copyright ï¿½ 2011, ForexGrowthBot"
#property link      "http://www.ForexGrowthBot.com"

#include <WinUser32.mqh>

#import "fxgrbot.dll"
   int initQuant(int a0, int a1, int a2, double a3, double a4, double a5, int a6, int a7, double a8, int a9, string a10);
   double GetVolatilityRatio(double& a0[], double& a1[], int a2, int a3, int a4, int a5);
   int GetQuantPositionChange(int a0, int a1, int a2, int a3, double a4, int a5, int a6, double a7, double a8, double a9, double a10, double a11);
   int getSlotCount(int a0, int a1);
   int SetPipsTrailSettings(int a0, double a1, double a2, double a3, int a4);
   int GetLicenseState(int a0);
   int getSystemID();
#import

int gi_76 = -100;
string gs_80 = " Basic 1.6 ";
extern double LotSize = 0.1;
extern int Magic = 456976;
extern bool FIFO = FALSE;
extern int ClosePreviousSessionOrders = 2;
extern bool Assign_PT_and_ST = FALSE;
extern bool InternalControl = TRUE;
extern bool ManualTradeControl = FALSE;
int gi_120 = 99;
string g_comment_124 = "Forex Growth Bot";
extern int FastVolatilityBase = 5;
extern int SlowVolatilityBase = 60;
extern double VolatilityFactor = 2.0;
double gd_148 = 0.5;
double gd_156 = 0.2;
int gi_164 = 50;
extern bool SmartExit = TRUE;
int gi_172 = 18;
double gd_176 = 0.65;
bool gi_184 = FALSE;
int gi_188 = 0;
int gi_192 = 0;
double gd_196 = 0.0;
bool gi_204 = FALSE;
string gs_208 = "40-80;40-80;40-80;40";
bool gi_unused_216 = FALSE;
int gi_220 = 25;
int gi_224 = 0;
int gi_228 = 0;
int gi_232 = 1;
bool gi_unused_236 = TRUE;
int g_datetime_240;
int gi_248 = 0;
double gd_252 = 1.0;
double gd_260 = 0.0;
int gi_unused_268 = -1000;
double gd_unused_272 = 0.0;
double gd_unused_280 = 0.0;
double gd_unused_288 = 0.0;
int gi_unused_296 = 0;
bool gi_unused_300 = FALSE;
double gd_304 = 100000.0;
double gd_312 = 250.0;
int gi_320 = 240;
int g_timeframe_324 = PERIOD_M15;
double gd_328 = 10.0;
bool gi_336 = TRUE;
bool gi_unused_340 = TRUE;
int gi_344 = 30;
int gi_348 = 7500;
bool gi_352 = TRUE;
int gi_356 = 0;
int gi_360 = 10000;
int g_fontsize_364 = 7;
string gs_tahoma_368 = "Tahoma";
bool gi_376 = TRUE;
int g_color_380 = White;
int gi_384 = 0;
int g_x_388 = 4;
int g_y_392 = 27;
double gd_396 = 0.0;
double gd_unused_404 = 0.0;
int gi_412 = 0;
int gi_416 = 0;
int gi_420 = -1;
int gi_424 = 0;
int gi_unused_428 = 5;
double gd_unused_432 = 3.0;

void UpdateState(string as_0) {
   if (InternalControl && (!ManualTradeControl) && (!Assign_PT_and_ST)) {
      ObjectDelete("fgbPosInfo" + gi_412);
      ObjectCreate("fgbPosInfo" + gi_412, OBJ_LABEL, 0, 0, 0);
      ObjectSetText("fgbPosInfo" + gi_412, "ForexGrowthBot PosState: " + as_0, g_fontsize_364, gs_tahoma_368, g_color_380);
      ObjectSet("fgbPosInfo" + gi_412, OBJPROP_CORNER, 0);
      ObjectSet("fgbPosInfo" + gi_412, OBJPROP_XDISTANCE, g_x_388);
      ObjectSet("fgbPosInfo" + gi_412, OBJPROP_YDISTANCE, g_y_392);
   }
}

double getPosSize() {
   double ld_0 = 0;
   for (int pos_8 = 0; pos_8 < OrdersTotal(); pos_8++) {
      if (OrderSelect(pos_8, SELECT_BY_POS, MODE_TRADES) == FALSE) {
         Print("SELECT ERROR");
         break;
      }
      if (OrderMagicNumber() != Magic || OrderSymbol() != Symbol()) continue;
      if (OrderType() == OP_BUY) ld_0 += OrderLots();
      if (OrderType() == OP_SELL) ld_0 -= OrderLots();
   }
   return (NormalizeDouble(ld_0, 2));
}

double normPrice(double ad_0) {
   return (NormalizeDouble(ad_0, Digits));
}

double RoundPrec(double ad_0, double ad_8) {
   return (MathRound(ad_0 / ad_8) * ad_8);
}

void WaitDLLCall() {
   if (!GlobalVariableCheck("TMSEC")) GlobalVariableSet("TMSEC", TimeSeconds(TimeCurrent()));
   if (!IsTesting()) {
      while (MathAbs(TimeSeconds(TimeCurrent()) - GlobalVariableGet("TMSEC")) == 0.0) {
         Sleep(500);
         RefreshRates();
      }
      GlobalVariableSet("TMSEC", TimeSeconds(TimeCurrent()));
   }
}

void LockInitCall() {
   if (!GlobalVariableCheck("FXLockInitCall")) GlobalVariableSet("FXLockInitCall", 0);
   if (!IsTesting()) {
      while (GlobalVariableGet("FXLockInitCall") == 1.0) {
         Sleep(250);
         RefreshRates();
      }
      GlobalVariableSet("FXLockInitCall", 1);
   }
}

void UnLockInitCall() {
   if (!GlobalVariableCheck("FXLockInitCall")) GlobalVariableSet("FXLockInitCall", 0);
   if (!IsTesting()) GlobalVariableSet("FXLockInitCall", 0);
}

void WaitUntilContex() {
   if (!IsTesting()) {
      while (IsTradeContextBusy() == TRUE) {
         Sleep(100);
         RefreshRates();
      }
   }
}

int CareCloseOrder(int a_ticket_0, int ai_4, double a_lots_8) {
   bool li_ret_16 = FALSE;
   color color_20 = CLR_NONE;
   int count_24 = 0;
   int error_28 = 0;
   double price_32 = 0;
   RefreshRates();
   if (ai_4 == 0) {
      price_32 = normPrice(Bid);
      color_20 = Green;
   } else {
      price_32 = normPrice(Ask);
      color_20 = Red;
   }
   bool is_closed_40 = FALSE;
   if (!IsTesting()) OrderClose(a_ticket_0, a_lots_8, price_32, 25, color_20);
   else {
      for (count_24 = 0; count_24 < gi_344; count_24++) {
         WaitUntilContex();
         is_closed_40 = OrderClose(a_ticket_0, a_lots_8, price_32, 25, color_20);
         error_28 = 0;
         if (!is_closed_40) error_28 = GetLastError();
         if (!is_closed_40) {
            Sleep(gi_348);
            RefreshRates();
            if (ai_4 == 0) {
               price_32 = normPrice(Bid);
               continue;
            }
            price_32 = normPrice(Ask);
         } else {
            li_ret_16 = TRUE;
            break;
         }
      }
   }
   return (li_ret_16);
}

void AdjustPosition(int ai_0) {
   double minlot_4 = MarketInfo(Symbol(), MODE_MINLOT);
   double ld_12 = RoundPrec(ai_0 * LotSize * gd_252, minlot_4);
   ld_12 = NormalizeDouble(ld_12, 2);
   double ld_unused_20 = 0;
   int count_28 = 0;
   int li_unused_32 = 0;
   int ticket_36 = 0;
   if (FIFO) {
      for (int pos_40 = 0; pos_40 < OrdersTotal(); pos_40++) {
         if (OrderSelect(pos_40, SELECT_BY_POS, MODE_TRADES) == FALSE) {
            Print("SELECT ERROR");
            break;
         }
         if (OrderMagicNumber() != Magic || OrderSymbol() != Symbol()) continue;
         if (OrderType() == OP_BUY && ld_12 < 0.0) {
            if (OrderLots() <= MathAbs(ld_12)) {
               ld_12 += OrderLots();
               ld_12 = NormalizeDouble(ld_12, 2);
               CareCloseOrder(OrderTicket(), 0, OrderLots());
               pos_40--;
            } else {
               if (OrderLots() > MathAbs(ld_12) && MathAbs(ld_12) != 0.0) {
                  CareCloseOrder(OrderTicket(), 0, MathAbs(ld_12));
                  ld_12 = 0;
                  pos_40--;
               }
            }
         }
         if (OrderType() == OP_SELL && ld_12 > 0.0) {
            if (OrderLots() <= MathAbs(ld_12)) {
               ld_12 -= OrderLots();
               ld_12 = NormalizeDouble(ld_12, 2);
               CareCloseOrder(OrderTicket(), 1, OrderLots());
               pos_40--;
               continue;
            }
            if (OrderLots() > MathAbs(ld_12) && MathAbs(ld_12) != 0.0) {
               CareCloseOrder(OrderTicket(), 1, MathAbs(ld_12));
               ld_12 = 0;
               pos_40--;
            }
         }
      }
   } else {
      for (pos_40 = OrdersTotal() - 1; pos_40 >= 0; pos_40--) {
         if (OrderSelect(pos_40, SELECT_BY_POS, MODE_TRADES) == FALSE) {
            Print("SELECT ERROR");
            break;
         }
         if (OrderMagicNumber() != Magic || OrderSymbol() != Symbol()) continue;
         if (OrderType() == OP_BUY && ld_12 < 0.0) {
            if (OrderLots() <= MathAbs(ld_12)) {
               ld_12 += OrderLots();
               ld_12 = NormalizeDouble(ld_12, 2);
               CareCloseOrder(OrderTicket(), 0, OrderLots());
            } else {
               if (OrderLots() > MathAbs(ld_12) && MathAbs(ld_12) != 0.0) {
                  CareCloseOrder(OrderTicket(), 0, MathAbs(ld_12));
                  ld_12 = 0;
               }
            }
         }
         if (OrderType() == OP_SELL && ld_12 > 0.0) {
            if (OrderLots() <= MathAbs(ld_12)) {
               ld_12 -= OrderLots();
               ld_12 = NormalizeDouble(ld_12, 2);
               CareCloseOrder(OrderTicket(), 1, OrderLots());
               continue;
            }
            if (OrderLots() > MathAbs(ld_12) && MathAbs(ld_12) != 0.0) {
               CareCloseOrder(OrderTicket(), 1, MathAbs(ld_12));
               ld_12 = 0;
            }
         }
      }
   }
   ld_12 = NormalizeDouble(ld_12, 2);
   if (ld_12 > 0.0) {
      if (IsTesting()) OrderSend(Symbol(), OP_BUY, MathAbs(ld_12), normPrice(Ask), 25, 0, 0, g_comment_124, Magic, 0, Green);
      else {
         WaitUntilContex();
         for (count_28 = 0; count_28 < gi_344; count_28++) {
            ticket_36 = OrderSend(Symbol(), OP_BUY, MathAbs(ld_12), normPrice(Ask), 25, 0, 0, g_comment_124, Magic, 0, Green);
            if (ticket_36 >= 0) break;
            Sleep(gi_348);
            RefreshRates();
         }
      }
   }
   if (ld_12 < 0.0) {
      if (IsTesting()) OrderSend(Symbol(), OP_SELL, MathAbs(ld_12), normPrice(Bid), 25, 0, 0, g_comment_124, Magic, 0, Red);
      else {
         WaitUntilContex();
         for (count_28 = 0; count_28 < gi_344; count_28++) {
            ticket_36 = OrderSend(Symbol(), OP_SELL, MathAbs(ld_12), normPrice(Bid), 25, 0, 0, g_comment_124, Magic, 0, Red);
            if (ticket_36 >= 0) break;
            Sleep(gi_348);
            RefreshRates();
         }
      }
   }
   if (gd_260 == 0.0) gd_260 = AccountEquity();
   if (ld_12 == 0.0 && gi_184 && getSlotCount(gi_76, 0) == 0) {
      if (AccountEquity() - gd_260 > 1500.0 && AccountEquity() - gd_260 < 3500.0) {
         LotSize += 0.05;
         gd_260 = AccountEquity();
      }
      if (AccountEquity() - gd_260 > 3500.0) {
         LotSize += 0.1;
         gd_260 = AccountEquity();
      }
   }
}

void postInit() {
   bool li_0;
   int li_unused_4;
   if (gi_352) {
      gi_352 = FALSE;
      MathSrand(TimeLocal());
      Sleep(5.0 * (1000.0 * (MathRand() + 0.0000001) / 32767.0));
      if (IsTesting()) gi_76 = 0;
      else gi_76 = getSystemID();
      gi_336 = TRUE;
      gd_260 = 0;
      gi_356 = 0;
      if (gd_196 != 0.0) {
         gd_196 = MathAbs(gd_196);
         if (!gi_204) {
            gs_208 = gd_196;
            gi_204 = TRUE;
         }
      }
      li_0 = FALSE;
      if (gi_204) li_0 = TRUE;
      li_unused_4 = 0;
      if (gi_76 < 0) li_unused_4 = 0;
      else
         if (gi_76 > 100) li_unused_4 = 99;
      g_timeframe_324 = Period();
      WaitDLLCall();
      LockInitCall();
      initQuant(AccountNumber(), gi_76, gd_328, gd_148, gd_156, gd_312, gi_320, g_timeframe_324, gd_304, li_0, gs_208);
      UnLockInitCall();
      g_datetime_240 = iTime(NULL, Period(), 0);
      gi_248 = 0;
      gd_unused_280 = LotSize;
   }
}

int init() {
   bool li_0;
   int li_unused_4;
   if (gi_120 < 1) gi_120 = 1;
   gi_412 = MathRand();
   gi_416 = 1974;
   gi_376 = TRUE;
   gi_384 = 0;
   gd_396 = 0;
   gd_unused_404 = 0;
   gi_420 = -1;
   gi_424 = 0;
   if (gi_376) {
      ObjectDelete("fgbLicenseInfo" + gi_416);
      ObjectCreate("fgbLicenseInfo" + gi_416, OBJ_LABEL, 0, 0, 0);
      ObjectSetText("fgbLicenseInfo" + gi_416, "ForexGrowthBot" + gs_80 + "license status: VERIFYING", g_fontsize_364, gs_tahoma_368, g_color_380);
      ObjectSet("fgbLicenseInfo" + gi_416, OBJPROP_CORNER, 0);
      ObjectSet("fgbLicenseInfo" + gi_416, OBJPROP_XDISTANCE, g_x_388);
      ObjectSet("fgbLicenseInfo" + gi_416, OBJPROP_YDISTANCE, 15);
      gi_376 = FALSE;
   }
   if (InternalControl && (!ManualTradeControl) && (!Assign_PT_and_ST)) {
      ObjectDelete("fgbPosInfo" + gi_412);
      ObjectCreate("fgbPosInfo" + gi_412, OBJ_LABEL, 0, 0, 0);
      ObjectSetText("fgbPosInfo" + gi_412, "ForexGrowthBot Position: Internal = 0.00, External = 0.00", g_fontsize_364, gs_tahoma_368, g_color_380);
      ObjectSet("fgbPosInfo" + gi_412, OBJPROP_CORNER, 0);
      ObjectSet("fgbPosInfo" + gi_412, OBJPROP_XDISTANCE, g_x_388);
      ObjectSet("fgbPosInfo" + gi_412, OBJPROP_YDISTANCE, g_y_392);
   }
   if (!SmartExit) gi_172 = FALSE;
   if (!gi_352) {
      MathSrand(TimeLocal());
      Sleep(5.0 * (1000.0 * (MathRand() + 0.0000001) / 32767.0));
      if (IsTesting()) gi_76 = 0;
      else gi_76 = 0;
      gi_336 = TRUE;
      gd_260 = 0;
      gi_356 = 0;
      if (gd_196 != 0.0) {
         gd_196 = MathAbs(gd_196);
         if (!gi_204) {
            gs_208 = gd_196;
            gi_204 = TRUE;
         }
      }
      li_0 = FALSE;
      if (gi_204) li_0 = TRUE;
      li_unused_4 = 0;
      if (gi_76 < 0) li_unused_4 = 0;
      else
         if (gi_76 > 100) li_unused_4 = 99;
      g_timeframe_324 = Period();
      WaitDLLCall();
      LockInitCall();
      initQuant(AccountNumber(), gi_76, gd_328, gd_148, gd_156, gd_312, gi_320, g_timeframe_324, gd_304, li_0, gs_208);
      UnLockInitCall();
      g_datetime_240 = iTime(NULL, Period(), 0);
      gi_248 = 0;
      gd_unused_280 = LotSize;
   }
   return (0);
}

int deinit() {
   ObjectDelete("fgbLicenseInfo" + gi_416);
   ObjectDelete("fgbPosInfo" + gi_412);
   return (0);
}

int start() {
   string text_0;
   bool is_closed_12;
   bool li_20;
   bool li_24;
   int mb_code_32;
   int error_36;
   int li_48;
   string text_52;
   double ld_60;
   int li_unused_68;
   double lda_72[];
   double lda_76[];
   double ld_80;
   int li_92;
   double ld_96;
   double ld_104;
   double ld_112;
   double ld_120;
   double ld_128;
   double ld_136;
   double ld_144;
   int li_152;
   double ld_156;
   double price_164;
   bool li_172;
   if (gi_384 == 0) {
      if (GetLicenseState(AccountNumber()) != 0) {
         gi_384 = GetLicenseState(AccountNumber());
         text_0 = "";
         if (gi_384 == 1) text_0 = "ForexGrowthBot" + gs_80 + "license status: ACTIVE";
         if (gi_384 == 2) text_0 = "ForexGrowthBot" + gs_80 + "license status: NOT ACTIVE! ACTIVATE AN ACCOUNT, PLEASE!";
         if (gi_384 > 0) {
            ObjectDelete("fgbLicenseInfo" + gi_416);
            ObjectCreate("fgbLicenseInfo" + gi_416, OBJ_LABEL, 0, 0, 0);
            ObjectSetText("fgbLicenseInfo" + gi_416, text_0, g_fontsize_364, gs_tahoma_368, g_color_380);
            ObjectSet("fgbLicenseInfo" + gi_416, OBJPROP_CORNER, 0);
            ObjectSet("fgbLicenseInfo" + gi_416, OBJPROP_XDISTANCE, g_x_388);
            ObjectSet("fgbLicenseInfo" + gi_416, OBJPROP_YDISTANCE, 15);
         }
      }
   }
   postInit();
   int count_8 = 0;
   if (gi_336 && (!IsTesting())) {
      gi_336 = FALSE;
      if (ClosePreviousSessionOrders <= 0) return (0);
      is_closed_12 = TRUE;
      li_20 = FALSE;
      li_24 = TRUE;
      if (ClosePreviousSessionOrders > 1) {
         li_20 = TRUE;
         li_24 = TRUE;
      }
      WaitUntilContex();
      for (int pos_28 = 0; pos_28 <= OrdersTotal(); pos_28++) {
         if (OrderSelect(pos_28, SELECT_BY_POS, MODE_TRADES) == FALSE) break;
         if (OrderMagicNumber() != Magic || OrderSymbol() != Symbol()) continue;
         if (!li_20) {
            li_20 = TRUE;
            mb_code_32 = MessageBox("Trades operated by Forex Growth Bot are still open.  We recommend closing them as they will not be tracked by the robot after MT4 has restart.",
               "Forex Growth Bot", MB_YESNO|MB_ICONQUESTION);
            if (mb_code_32 == IDNO) li_24 = FALSE;
         }
         for (count_8 = 0; count_8 < gi_344; count_8++) {
            RefreshRates();
            if (OrderType() == OP_BUY && li_24) {
               WaitUntilContex();
               is_closed_12 = OrderClose(OrderTicket(), OrderLots(), Bid, 10, Green);
            }
            if (OrderType() == OP_SELL && li_24) {
               WaitUntilContex();
               is_closed_12 = OrderClose(OrderTicket(), OrderLots(), Ask, 10, Red);
            }
            error_36 = GetLastError();
            if (!is_closed_12) {
               Sleep(gi_348);
               RefreshRates();
            } else {
               pos_28--;
               break;
            }
         }
      }
      return (0);
   }
   int timeframe_40 = Period();
   pos_28 = 0;
   int ticket_44 = 0;
   if (iTime(NULL, Period(), 0) - g_datetime_240 >= timeframe_40) {
      li_48 = GetLicenseState(AccountNumber());
      text_52 = "";
      if (li_48 == 1) text_52 = "ForexGrowthBot" + gs_80 + "license status: ACTIVE";
      if (li_48 == 2) text_52 = "ForexGrowthBot" + gs_80 + "license status: NOT ACTIVE! ACTIVATE AN ACCOUNT, PLEASE!";
      if (li_48 > 0) {
         ObjectDelete("fgbLicenseInfo" + gi_416);
         ObjectCreate("fgbLicenseInfo" + gi_416, OBJ_LABEL, 0, 0, 0);
         ObjectSetText("fgbLicenseInfo" + gi_416, text_52, g_fontsize_364, gs_tahoma_368, g_color_380);
         ObjectSet("fgbLicenseInfo" + gi_416, OBJPROP_CORNER, 0);
         ObjectSet("fgbLicenseInfo" + gi_416, OBJPROP_XDISTANCE, g_x_388);
         ObjectSet("fgbLicenseInfo" + gi_416, OBJPROP_YDISTANCE, 15);
      }
      gi_248 += Period();
      ld_60 = 0;
      for (ld_60 = gi_224; ld_60 <= gi_228; ld_60++) {
         li_unused_68 = 0;
         for (pos_28 = 0; pos_28 < gi_232; pos_28++) {
            if (ArraySize(Close) > 101) {
               ArrayCopy(lda_72, Close, 0, 1, 100);
               ArrayCopy(lda_76, Open, 0, 1, 100);
               ld_80 = 0;
               if (ld_60 > 0.0) {
                  for (int index_88 = 0; index_88 < ArraySize(lda_72); index_88++) {
                     if (MathRand() > 16383) ld_80 = (MathRand() + 0.0000001) / 32767.0 * (ld_60 * Point);
                     else ld_80 = (-(MathRand() + 0.0000001)) / 32767.0 * (ld_60 * Point);
                     lda_72[index_88] += ld_80;
                  }
                  for (index_88 = 0; index_88 < ArraySize(lda_76); index_88++) {
                     if (MathRand() > 16383) ld_80 = (MathRand() + 0.0000001) / 32767.0 * (ld_60 * Point);
                     else ld_80 = (-(MathRand() + 0.0000001)) / 32767.0 * (ld_60 * Point);
                     lda_76[index_88] += ld_80;
                  }
               }
            }
            li_92 = 0;
            ld_96 = 0;
            g_datetime_240 = iTime(NULL, Period(), 0);
            if (ArraySize(Close) > 101) {
               WaitDLLCall();
               ld_96 = GetVolatilityRatio(lda_72, lda_76, FastVolatilityBase, SlowVolatilityBase, 100, AccountNumber());
               if (MathAbs(ld_96) >= VolatilityFactor) {
                  if (ld_96 > 0.0) li_92 = 1;
                  else li_92 = -1;
                  gi_356 += li_92;
                  if (MathAbs(gi_356) > gi_360) {
                     gi_356 = gi_360 * (gi_356 / MathAbs(gi_356));
                     li_92 = 0;
                  }
               }
            }
            ld_104 = gd_148;
            ld_112 = gd_156;
            ld_120 = High[iHighest(NULL, 0, MODE_HIGH, gi_164, 1)] - Low[iLowest(NULL, 0, MODE_LOW, gi_164, 1)];
            ld_120 *= gd_304;
            if ((!Assign_PT_and_ST) || ManualTradeControl) {
               ld_128 = 1.0 * (gi_188 + 0.0) / MathPow(10, Digits);
               ld_136 = 1.0 * (gi_192 + 0.0) / MathPow(10, Digits);
               ld_144 = 0;
               WaitDLLCall();
               SetPipsTrailSettings(gi_76, ld_128, ld_136, ld_144, gi_120);
               li_152 = GetQuantPositionChange(AccountNumber(), gi_76, 0, gi_220, lda_72[0], li_92, gi_248, ld_104, ld_112, ld_120, gi_172, gd_176);
               gi_356 += li_152;
               gd_396 += NormalizeDouble(li_152 * LotSize, 2);
               if (li_152 != 0) {
                  UpdateState("Updating");
                  AdjustPosition(li_152);
                  gi_424 = TimeSeconds(TimeCurrent()) - 15;
               }
               if (li_92 != 0) {
               }
            } else {
               ld_156 = High[iHighest(NULL, 0, MODE_HIGH, gi_164, 1)] - Low[iLowest(NULL, 0, MODE_LOW, gi_164, 1)];
               price_164 = 0;
               if (li_92 == 1) {
                  price_164 = normPrice(Ask);
                  if (IsTesting()) {
                     ticket_44 = OrderSend(Symbol(), OP_BUY, LotSize, price_164, 25, 0, 0, g_comment_124, Magic, 0, Green);
                     OrderModify(ticket_44, price_164, price_164 - NormalizeDouble(ld_156 * gd_156, Digits), price_164 + NormalizeDouble(ld_156 * gd_148, Digits), 0, Green);
                  } else {
                     WaitUntilContex();
                     for (count_8 = 0; count_8 < gi_344; count_8++) {
                        ticket_44 = OrderSend(Symbol(), OP_BUY, LotSize, price_164, 25, 0, 0, g_comment_124, Magic, 0, Green);
                        if (ticket_44 >= 0) break;
                        Sleep(gi_348);
                        RefreshRates();
                        price_164 = normPrice(Ask);
                     }
                     if (ticket_44 >= 0 && (!ManualTradeControl)) {
                        for (count_8 = 0; count_8 < gi_344; count_8++) {
                           if (!(!OrderModify(ticket_44, price_164, normPrice(price_164) - NormalizeDouble(ld_156 * gd_156, Digits), normPrice(price_164) + NormalizeDouble(ld_156 * gd_148,
                              Digits), 0, Green))) break;
                           Sleep(gi_348);
                           RefreshRates();
                        }
                     }
                  }
               }
               if (li_92 == -1) {
                  price_164 = normPrice(Bid);
                  if (IsTesting()) {
                     ticket_44 = OrderSend(Symbol(), OP_SELL, LotSize, price_164, 25, 0, 0, g_comment_124, Magic, 0, Red);
                     OrderModify(ticket_44, price_164, price_164 + NormalizeDouble(ld_156 * gd_156, Digits), price_164 - NormalizeDouble(ld_156 * gd_148, Digits), 0, Red);
                     continue;
                  }
                  count_8 = 0;
                  WaitUntilContex();
                  while (count_8 < gi_344) {
                     ticket_44 = OrderSend(Symbol(), OP_SELL, LotSize, price_164, 100, 0, 0, g_comment_124, Magic, 0, Red);
                     if (ticket_44 >= 0) break;
                     Sleep(gi_348);
                     RefreshRates();
                     price_164 = normPrice(Bid);
                     count_8++;
                  }
                  if (ticket_44 >= 0 && (!ManualTradeControl)) {
                     for (count_8 = 0; count_8 < gi_344; count_8++) {
                        if (!(!OrderModify(ticket_44, price_164, normPrice(price_164) + NormalizeDouble(ld_156 * gd_156, Digits), normPrice(price_164) - NormalizeDouble(ld_156 * gd_148,
                           Digits), 0, Red))) break;
                        Sleep(gi_348);
                        RefreshRates();
                     }
                  }
               }
            }
         }
      }
   } else {
      if ((!ManualTradeControl) && !Assign_PT_and_ST && gi_192 > 0 || gi_188 > 0) {
         ld_104 = gd_148;
         ld_112 = gd_156;
         ld_120 = High[iHighest(NULL, 0, MODE_HIGH, gi_164, 1)] - Low[iLowest(NULL, 0, MODE_LOW, gi_164, 1)];
         ld_120 *= gd_304;
         ld_136 = 1.0 * (gi_192 + 0.0) / MathPow(10, Digits);
         ld_128 = 1.0 * (gi_188 + 0.0) / MathPow(10, Digits);
         WaitDLLCall();
         li_172 = FALSE;
         ld_144 = 1;
         WaitDLLCall();
         SetPipsTrailSettings(gi_76, ld_128, ld_136, ld_144, gi_120);
         li_152 = GetQuantPositionChange(AccountNumber(), gi_76, 0, gi_220, normPrice(Close[0]), li_172, gi_248, ld_104, ld_112, ld_120, gi_172, gd_176);
         gd_396 += NormalizeDouble(li_152 * LotSize, 2);
         gi_356 += li_152;
         if (li_152 != 0) {
            UpdateState("Updating");
            AdjustPosition(li_152);
            gi_424 = TimeSeconds(TimeCurrent()) - 15;
         }
      }
   }
   if ((TimeSeconds(TimeCurrent()) - gi_420 > 15 && gi_420 > 0) || TimeSeconds(TimeCurrent()) - gi_424 > 30 && InternalControl && (!ManualTradeControl) && (!Assign_PT_and_ST)) {
      ObjectDelete("fgbPosInfo" + gi_412);
      ObjectCreate("fgbPosInfo" + gi_412, OBJ_LABEL, 0, 0, 0);
      ObjectSetText("fgbPosInfo" + gi_412, "ForexGrowthBot Position: Internal = " + DoubleToStr(getPosSize(), 2) + ", External = " + DoubleToStr(gd_396, 2), g_fontsize_364,
         gs_tahoma_368, g_color_380);
      ObjectSet("fgbPosInfo" + gi_412, OBJPROP_CORNER, 0);
      ObjectSet("fgbPosInfo" + gi_412, OBJPROP_XDISTANCE, g_x_388);
      ObjectSet("fgbPosInfo" + gi_412, OBJPROP_YDISTANCE, g_y_392);
      if (gi_420 > 0) gi_420 = 0;
      gi_424 = TimeSeconds(TimeCurrent());
      if (MathAbs(NormalizeDouble(getPosSize(), 2) - NormalizeDouble(gd_396, 2)) > 0.001) {
         AdjustPosition((NormalizeDouble(gd_396, 2) - NormalizeDouble(getPosSize(), 2)) / LotSize);
         gi_424 = TimeSeconds(TimeCurrent()) - 15;
         UpdateState("Updating");
      }
   }
   return (0);
}
