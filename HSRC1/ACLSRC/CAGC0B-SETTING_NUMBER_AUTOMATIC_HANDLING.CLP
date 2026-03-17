             PGM        PARM(&IJUN2)
             /** CAGC0B *************************************/
             /*  ..SETTING NUMBER AUTOMATIC HANDLING        */
             /*     A-PICS INCREASE AND DECREASE FIXED LIST */
             /*  .. A-PICS2                                 */
             /*  .. CAGC01  CHANGE                          */
             /*  .. CAGC02  CHANGE                          */
             /*      I-HASADA                 93.10.18      */
             /************************************* CAGC0B **/
             DCL        VAR(&HIZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&YMJ) TYPE(*CHAR) LEN(7)
             DCL        VAR(&IJUN2) TYPE(*CHAR) LEN(1)
             RTVDTAARA  DTAARA(ABDDS1) RTNVAR(&HIZ)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&YMJ)
             CHGVAR     VAR(%SST(&YMJ 7 1)) VALUE(&IJUN2)
             CHGJOB     SWS(00000000)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1)
             CALL       PGM(CAGR01) PARM(&YMJ &HIZ)
             DLTOVR     FILE(*ALL)

             DLTF       FILE(CAGWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/CAGWP02) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 5) +
                          LVLCHK(*NO)

             CALL       PGM(CAGR02)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(CAGWP02)
             GOTO       END
             ENDDO

             DLTF       FILE(CAGWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/CAGWP03) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 5) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((CAGWP02)) OUTFILE(CAGWP03) +
                          SRCFILE(FMTSRC) SRCMBR(CAGS02) +
                          OPTION(*NOPRT)
             DLTF       FILE(CAGWP02)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1)
             CALL       PGM(CAGR03) PARM(&YMJ &HIZ)
             DLTF       FILE(CAGWP03)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
