      PGM       (&FILE_L &MBR &SEQ &OPT1 &OPT2 &OPT3 &OPT4)
/** #FIXDTA **********************************************************/
/*  FIX FILE DATA                                                    */
/*  IAF IT   2024.08.16                                              */
/*********************************************************************/

        DCL        &FILE_L *CHAR  20
        DCL        &FILE   *CHAR  10 ' '
        DCL        &LIB    *CHAR  10 ' '
        DCL        &MBR    *CHAR  10
        DCL        &SEQ    *CHAR   4
        DCL        &OPT1   *CHAR   1
        DCL        &OPT2   *CHAR   1
        DCL        &OPT3   *CHAR   1
        DCL        &OPT4   *CHAR   1
        DCL        &MSGID  *CHAR   7 ' '
        DCL        &MSGF   *CHAR  10 ' '
        DCL        &MSGL   *CHAR  10 ' '
        DCL        &MSG    *CHAR 256 ' '
        MONMSG CPF0000      EXEC(GOTO  @ERR)

        CHGVAR     &FILE %SST(&FILE_L 1 10)
        CHGVAR     &LIB %SST(&FILE_L 11 10)
        CHKOBJ     &LIB/&FILE *FILE &MBR

        IF (&MBR = '*FIRST')   +
          DO
            OVRDBF     INPUT1 &LIB/&FILE WAITRCD(2) LVLCHK(*NO)
            OVRDBF     INPUT2 &LIB/&FILE WAITRCD(2) LVLCHK(*NO)
            OVRDBF     OUTPUT &LIB/&FILE WAITRCD(2) LVLCHK(*NO)
          ENDDO
        ELSE                   +
          DO
            OVRDBF     INPUT1 &LIB/&FILE &MBR WAITRCD(2) LVLCHK(*NO)
            OVRDBF     INPUT2 &LIB/&FILE &MBR WAITRCD(2) LVLCHK(*NO)
            OVRDBF     OUTPUT &LIB/&FILE &MBR WAITRCD(2) LVLCHK(*NO)
          ENDDO
        OVRDSPF    EDTDTAD QGPL/EDTDTAD
        OVRDBF     QADSPFFD QTEMP/QADSPFFD LVLCHK(*NO)
        OVRDBF     QADSPFL1 QTEMP/QADSPFL1 LVLCHK(*NO)
        OVRDBF     QAFDACCP QTEMP/QAFDACCP LVLCHK(*NO)
        OVRDBF     QAFDSEL1 QTEMP/QAFDSEL1 LVLCHK(*NO)
        OVRDBF     PRTDTAP QTEMP/PRTDTAP FRCRATIO(1) LVLCHK(*NO)
        OVRDBF     PRTDTAL1 QTEMP/PRTDTAL1 LVLCHK(*NO)
        OVRDBF     PRTDTAL2 QTEMP/PRTDTAL2 LVLCHK(*NO)
        OVRDBF     PRTDTAL3 QTEMP/PRTDTAL3 LVLCHK(*NO)
        OVRPRTF    QPRINT PAGESIZE(*N 198) CPI(15) HOLD(*YES)
        OVRPRTF    QPDDSSRC SPOOL(*NO)

/***    CALL       QGPL/EDTDTAR (&SEQ &OPT1 &OPT2 &OPT3 &OPT4)  ***/
        CALL       HOBJ1/FIXDTAR (&SEQ &OPT1 &OPT2 &OPT3 &OPT4)

        DLTOVR     (INPUT1 INPUT2 OUTPUT EDTDTAD QADSPFFD QADSPFL1 +
                     QAFDACCP QAFDSEL1 PRTDTAP PRTDTAL1 PRTDTAL2 +
                     PRTDTAL3 QPRINT QPDDSSRC)
        RETURN

 @ERR:  RCVMSG     MSGTYPE(*DIAG) RMV(*NO) MSGDTA(&MSG) MSGID(&MSGID) +
                     MSGF(&MSGF) MSGFLIB(&MSGL)
        IF (&MSGID ¬= ' ')    +
          DO
            SNDPGMMSG  *N &MSGID &MSGL/&MSGF &MSG MSGTYPE(*DIAG)
            GOTO       @ERR
          ENDDO
        RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&MSG) MSGID(&MSGID) +
                     MSGF(&MSGF) MSGFLIB(&MSGL)
        SNDPGMMSG  *N &MSGID &MSGL/&MSGF &MSG MSGTYPE(*ESCAPE)

        RETURN

      ENDPGM
