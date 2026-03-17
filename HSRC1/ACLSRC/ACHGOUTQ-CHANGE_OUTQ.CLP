 /*   ************************************************************************/
 /*   * PROGRAM  : CHGOUTQ                                                   */
 /*   ************************************************************************/
             PGM

                     DCL  &RETDATE  *CHAR     08
                     DCL  &PRTFILE  *CHAR     10
                     DCL  &USER     *CHAR     10
                     DCL  &JOBNAME  *CHAR     10
                     DCL  &JOBNBR   *CHAR     06
                     DCL  &SPLNBR   *CHAR     04
                     DCL  &SPLNBR#  *DEC    (  4 0)
                     DCL  &SPLDATE  *CHAR     08

                     DCLF QTEMP/SPOOL132

             DLTF       FILE(QTEMP/SPOOL132)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/SPOOL132) RCDLEN(132) SIZE(99999)

 /* Dｶｾｶﾔｶ ｲﾀﾙ ｶﾘｻﾐﾔｻﾀｸ QPRTSPLQ                                       */
 LOOP1:      DLTSPLF    FILE(QPRTSPLQ) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CNTNU01)
             GOTO       CMDLBL(LOOP1)

 CNTNU01:    WRKOUTQ    OUTQ(GENTRAN) OUTPUT(*PRINT)
             CPYSPLF    FILE(QPRTSPLQ) TOFILE(QTEMP/SPOOL132) +
                          SPLNBR(*LAST)

 LOOP2:      RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDPGM))
             CHGVAR     VAR(&JOBNBR) VALUE(%SST(&SPOOL132  93 6))

             CHGVAR     VAR(&SPLDATE)  VALUE(%SST(&SPOOL132 100 08))
             CHGVAR     VAR(&PRTFILE)  VALUE(%SST(&SPOOL132   2  10))
             CHGVAR     VAR(&USER)     VALUE(%SST(&SPOOL132  13  10))
             CHGVAR     VAR(&JOBNAME)  VALUE(%SST(&SPOOL132  82  10))
             CHGVAR     VAR(&SPLNBR)  VALUE(%SST(&SPOOL132  73  04))
             CHGVAR     VAR(&SPLNBR#)  VALUE(&SPLNBR)

             CHGSPLFA   FILE(&PRTFILE) JOB(&JOBNBR/&USER/&JOBNAME) +
                          SPLNBR(&SPLNBR#) OUTQ(QPRINTB)


             GOTO       CMDLBL(LOOP2)


 ENDPGM:

             DLTSPLF    FILE(QPRTSPLQ) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CNTNU01)
             ENDPGM


