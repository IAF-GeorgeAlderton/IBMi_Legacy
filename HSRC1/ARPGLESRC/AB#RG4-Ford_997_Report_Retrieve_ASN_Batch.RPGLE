     F***************************************************
     F*  Generate 997 Report.                           *
     F*  Write to temporary 80 byte file.               *
     F*  To Compile program, enter command:             *
     F*    CRTPF FILE(QTEMP/CMPFIL) RCDLEN(80)          *
     F***************************************************
     FAb#pp6u   IF   E           K Disk
     FAudrecl6  IF   E           K Disk
     FOutdta    IF   E           K Disk
     FCmpfil    O  A E             Disk    Rename(Cmpfil:Cmpfilr)
     F                                     Prefix(X:1)
     D Group#          S                   Like(Afdgnb)
     D Holdgroup       S                   Like(M6ak102)
     D Batch#          S                   Like(Afdcbm)
     D Batchp          S                   Like(Oqdbsq)
      /Free
        Read Ab#pp6u;
        Dow not %eof(Ab#pp6U);
          If M6ak102 = HoldGroup;
            Read Ab#pp6u;
            Iter;
          Endif;
          HoldGroup = M6ak102;
          Group# = %Editc(M6ak102:'X');
          Setll (M6ptrn:'      ':'S':'SH':Group#) Audrecl6;
          Reade (M6ptrn:'      ':'S':'SH':Group#) Audrecl6;
          Batch# = *Blanks;
          Dow not %eof(Audrecl6);
            Batch# = Afdcbm;
            Reade (M6ptrn:'      ':'S':'SH':Group#) Audrecl6;
          Enddo;
          If Batch# <> *Blanks;
            Batchp = %Dec(Batch#:7:0);
            Setll Batchp Outdta;
            Reade Batchp Outdta;
            Dow Not %Eof(Outdta);
              Xmpfil = Oqddta;
              Write Cmpfilr;
              Reade Batchp Outdta;
            Enddo;
          Endif;
        Read Ab#pp6u;
        Enddo;
        *Inlr = *On;
      /End-Free
