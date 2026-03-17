             PGM
             /** ABNC11 *****************************************/
             /* LOCATION INFO                                   */
             /*   SAKAKI.          2019.04.12                   */
             /*   JW1   2019.05.13 OUPPUT DATA TO CSV           */
             /***************************************************/
             DCLF       FILE(ABNPW11)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STEP1:      SNDRCVF    RCDFMT(DSP01)

             IF         COND((&IN01 = '1') *OR (&IN03 = '1')) +
                          THEN(GOTO CMDLBL(ENDP))

             IF         COND(&IN05 *NE '1') THEN(GOTO CMDLBL(STEP1))

             CHGJOB     OUTQ(&PRTG)

             CLRPFM     FILE(ABNPP11)
             CLRPFM     FILE(ABNPP11A)

             CALL       PGM(ABNR11)
             CALL       PGM(ABNR12)
             CALL       PGM(ABNR14)
             CALL       PGM(ABNR15)
             CALL       PGM(ABNR16)
             CALL       PGM(ABNR17)
             CALL       PGM(ABNR18)
             CALL       PGM(ABNR19)

 /* JW1 OUTPUT DATA TO J:DRIVE */
             CALL       PGM(ABNR13)

 /* TRANSFER TO DIRECTORY */
             CHGVAR     VAR(&FNAM) VALUE('LOCATION INF')
             CALL       PGM(APLC96) PARM('2' 'ABNPP11A' 'HFILE1' +
                          &FNAM 'Y' ' ')

ENDP:        ENDPGM
