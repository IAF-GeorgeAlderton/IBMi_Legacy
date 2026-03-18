     H DATEDIT(*YMD.) OPTION(*NODEBUGIO)
      ** UEXR59H ***************************************************
      *  GET EDI824 INFORMATION (HONDA)                            *
      *  JW     2025.05.14                                         *
      **************************************************************
      *  CALLING SEQ.
      *                    CALL 'UEXR59H'
      *                    PARM           $SHID  10
      *                    PARM           $STT    3
      *                    PARM           $DATE   8
      *                    PARM           $TIME   6
      *   IN  $SHID  10A  SHID
      *   OUT $STT    3A  YES:ACCEPTED, NO:REJECTED, BLANK:NO ANSWER
      *   "   $DATE   8A  RECEIVE DATE
      *   "   $TIME   6A  RECEIVE TIME
      ***********************************************************
     FAB#PLE1   IF   E           K DISK
      ***********************************************************
     C                   EXSR      #INIT
      *
      *
     C     K#SHID        SETLL     AB#PLE1
      *
     C                   DO        *HIVAL
     C     K#SHID        READE     AB#PLE1                                51
     C   51              LEAVE
      *
      * SELECT HONDA ONLY
     C     M6PTRN        IFNE      'HONDA'
     C                   ITER
     C                   ENDIF
      *
     C                   ADD       1             @CNT
      * SET $STT
     C                   SELECT
     C                   WHEN      @CNT = 1
     C                   EVAL      @ACK  = M6ACKC
     C                   EVAL      @DATE = M6CRDT
     C                   EVAL      @TIME = M6CRTM
      *
     C                   OTHER
     C                   IF        (M6CRDT = @DATE) AND (M6CRTM = @TIME)
     C                             AND (M6ACKC = 'TR')
     C                   EVAL      @ACK = 'TR'
     C                   ITER
     C                   ENDIF
      *
     C                   IF        (M6CRDT = @DATE) AND (M6CRTM > @TIME)
     C                             AND (M6ACKC = 'TR')
     C                   EVAL      @ACK  = 'TR'
     C                   EVAL      @DATE = M6CRDT
     C                   EVAL      @TIME = M6CRTM
     C                   ITER
     C                   ENDIF
      *
     C                   IF        (M6CRDT = @DATE) AND (M6CRTM > @TIME)
     C                             AND (M6ACKC = 'TR')
     C                   EVAL      @ACK  = 'TR'
     C                   EVAL      @DATE = M6CRDT
     C                   EVAL      @TIME = M6CRTM
     C                   ITER
     C                   ENDIF
      *
     C                   IF        M6CRDT <> @DATE
     C                   EVAL      @ACK  = M6ACKC
     C                   EVAL      @DATE = M6CRDT
     C                   EVAL      @TIME = M6CRTM
     C                   ITER
     C                   ENDIF
      *
     C                   ENDSL
     C                   ENDDO
      *
     C                   SELECT
     C                   WHEN      @CNT = 0
     C                   MOVE      '   '         $STT
     C                   WHEN      @ACK = 'TR'
     C                   MOVE      'NO '         $STT
     C                   OTHER
     C                   MOVE      'YES'         $STT
     C                   ENDSL
      *
     C                   MOVEL     @DATE         $DATE
     C                   MOVEL     @TIME         $TIME
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      ***********************************************************
      * INITIAL SETTINGS
      ***********************************************************
     C     #INIT         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    $SHID            10
     C                   PARM                    $STT              3
     C                   PARM                    $DATE             8
     C                   PARM                    $TIME             6
      *
     C                   MOVEL     $SHID         K#SHID           15
     C                   CLEAR                   $STT
     C                   CLEAR                   @CNT              5 0
     C                   CLEAR                   @ACK              2
     C                   CLEAR                   @DATE             8 0
     C                   CLEAR                   @TIME             6 0
      *
     C                   ENDSR
