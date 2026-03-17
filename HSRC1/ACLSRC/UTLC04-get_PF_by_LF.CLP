             /** UTLC04 ******************************************/
             /*  UTILITY - GET PF BY LF                          */
             /*--------------------------------------------------*/
             /*  CALLING SEQ.                                    */
             /*                    CALL 'UTLC04'                 */
             /*                    PARM           $FILE  10      */
             /*                    PARM           $PF    10      */
             /*                    PARM           $ATR   10      */
             /*                    PARM           $RTN    1      */
             /*   IN  $FILE  : 10A LF                            */
             /*   OUT $PF    : 10A PF                            */
             /*       $ATR   : 10A ATTRIBUTE (PF/LF/PRTF/DSPF)   */
             /*       $RTN   :  1A RETURN CODE (BLANK/*)         */
             /****************************************************/
             PGM        PARM(&FILE &PF &ATR &RTN)

             DCL        VAR(&FILE ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PF   ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATR  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR04) PARM(&FILE &PF &RTN)

             MONMSG     MSGID(CPF9812) EXEC(DO)
             CHGVAR     VAR(&RTN) VALUE('1')
             GOTO ENDP
             ENDDO

       /*    RTVOBJD    OBJ(&FILE) OBJTYPE(*FILE) RTNLIB(&A) +       */
       /*                 OBJATR(&B) USRDFNATR(&C) OWNER(&D) +       */
       /*                 PGP(&E) OBJASPDEV(&F) OBJASPGRP(&G) +      */
       /*                 LIBASPDEV(&H) LIBASPGRP(&I) CRTUSER(&J) +  */
       /*                 STG(&K) SAVCMD(&L) SAVDEV(&M) SAVF(&N) +   */
       /*                 SAVFLIB(&O) SRCF(&P) SRCFLIB(&Q) +         */
       /*                 SRCMBR(&R) PTF(&S) APAR(&T) OBJAUD(&U)     */

             RTVOBJD    OBJ(&FILE) OBJTYPE(*FILE) OBJATR(&ATR)

             MONMSG     MSGID(CPF9812 CPF0001) EXEC(DO)
             CHGVAR     VAR(&RTN) VALUE('1')
             GOTO ENDP
             ENDDO

 ENDP:       ENDPGM
