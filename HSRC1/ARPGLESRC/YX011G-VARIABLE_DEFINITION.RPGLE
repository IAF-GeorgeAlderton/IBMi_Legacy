     D**************************************************************************
     D* VARIABLE  DEFINITION
     D**************************************************************************
     D W@TIMESTAMP     S               Z
     D*
     D                SDS
     D PARMS             *PARMS
     C     *ENTRY        PLIST
     C                   PARM                    W@DATE1           8 0
     C                   PARM                    W@DATE2           8 0
     C                   PARM                    W@TIME1           6 0
     C                   PARM                    W@TIME2           6 0
     C                   PARM                    W@DIFF           10 0
     C**************************************************************************
     C* MAIN
     C**************************************************************************
           /FREE

              // TIME1 と TIME2 の時間差（秒）を求める
               W@DIFF = %DIFF(%TIME(W@TIME2:*HMS):%TIME(W@TIME1:*HMS):*SECONDS);

               *INLR = *ON;
               RETURN;
           /END-FREE
