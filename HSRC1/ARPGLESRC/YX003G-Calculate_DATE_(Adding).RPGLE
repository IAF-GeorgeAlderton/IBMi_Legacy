     F** YX003G ********************************************
     F*Calcullate DATE (Adding)                          *
     F*      T.SAKASHITA                   2011.06.01      *
     F******************************************** DATR20 **
     D INPDATE         S             26Z
     D OUTDATE         S             26Z
      * PARAMETER
     C     *ENTRY        PLIST
     C                   PARM                    PIDATE           26 0
     C                   PARM                    PF                1
     C                   PARM                    PA                5 0
     C                   PARM                    PODATE           26 0
      *
     C                   MOVE      PIDATE        INPDATE
      *
     C     PF            IFEQ      'Y'
     C     INPDATE       ADDDUR    PA:*YEARS     OUTDATE
     C                   ENDIF
     C     PF            IFEQ      'M'
     C     INPDATE       ADDDUR    PA:*MONTHS    OUTDATE
     C                   ENDIF
     C     PF            IFEQ      'D'
     C     INPDATE       ADDDUR    PA:*DAYS      OUTDATE
     C                   ENDIF
     C     PF            IFEQ      'J'
     C     INPDATE       ADDDUR    PA:*HOURS     OUTDATE
     C                   ENDIF
     C     PF            IFEQ      'F'
     C     INPDATE       ADDDUR    PA:*MN        OUTDATE
     C                   ENDIF
     C     PF            IFEQ      'B'
     C     INPDATE       ADDDUR    PA:*S         OUTDATE
     C                   ENDIF
      *
     C                   MOVE      OUTDATE       PODATE
      *
     C                   RETURN
