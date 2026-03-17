     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // RCHK01
      // LEC          2022.02.28
      // This program checks the input parameter for invalid characters
      //************************************************************************

     D Pos             S              6S 0                                      position
     D ValidChars      S             37    inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ -    valid characters
     D                                     0123456879')
     D IsValid         S              1
     D In_Data         S             50
     D Out_Valid       S              1
      **********************************************************************************
      *
     C     *Entry        PList
     C                   Parm                    In_Data
     C                   Parm                    Out_Valid
      *
      **********************************************************************************
      *         M    A    I    N    L    I    N    E
      *
     C                   Eval      Out_Valid = 'N'

     C     ValidChars    Check     In_Data       Pos
     C                   If        Pos = *zero
     C                   Eval      Out_Valid = 'Y'
     C                   EndIf

     C                   Eval      *InLR = *On
     C                   Return
     **********************************************************************************
