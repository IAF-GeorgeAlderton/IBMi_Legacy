     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // REFR02
      // LEC          2017/04/24
      // This program retrieves the delivery code for the IC code passed in.
      //************************************************************************

     FABFPP55   IF   E           K DISK
     D IC_Code_In      S              5
     D DelvCode_Out    S              4

     C     *Entry        PList
     C                   Parm                    IC_Code_In
     C                   Parm                    DelvCode_Out

      **********************************************************************************
      *         M    A    I    N    L    I    N    E
      *
      *
     C                   Eval      DelvCode_Out = *blanks
     C     IC_Code_In    Chain     ABFPP55                            50
     C                   DoW       *In50 = *Off
     C                   If        FCSKJY = ' '
     C                   Eval      DelvCode_Out = %char(FCNONY)
     C                   Leave
     C                   EndIf
     C     IC_Code_In    ReadE     ABFPP55                                50
     C                   EndDo
      *
     C                   Eval      *InLR = *On
     C                   Return
      **********************************************************************************
