             PGM
             /** FBCC31 ************************************/
             /*  SALES EXPANSION RESULT                    */
             /*   T.SAKAKI 16.07.20  ADD MAIL            */
             /**********************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FBCWP31)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0)

        /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&PARM1)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2)    TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&TO1) VALUE('MARK.VANCE@IAFI.COM')
             CHGVAR     VAR(&SUB) VALUE('SALES EXPANSION RESULT ' +
                          *CAT &USER)
             CHGVAR     VAR(&FNAME) +
                          VALUE('SALES_EXPANSION_RESULT.CSV')

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             /*==================================================*/
             /*  CREATE CSV DATA                                 */
             /*==================================================*/
             CHGVAR     VAR(&FBCWP31) VALUE('FBCWP31')
             DLTF       FILE(&WLIB/&FBCWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FBCWP31) RCDLEN(210) +
                        IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                        SIZE(500 5000 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(FBCWP31) TOFILE(&FBCWP31)
      /*     CALL       PGM(FBCR31)  */
             CALL       PGM(FBCR34) PARM(&TO1)
             DLTOVR     FILE(FBCWP31)

             RTVMBRD    FILE(&WLIB/&FBCWP31) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(#STEP99))

             /*==================================================*/
             /*     SEND CSV DATA BY MAIL                        */
             /*==================================================*/
             CHGVAR     VAR(&PARM1) VALUE(&WLIB)
             CHGVAR     VAR(&PARM2) VALUE(&FBCWP31)

             CALL       PGM(APLC30) PARM(&TO1 &SUB &PARM1 &PARM2 +
                          &FNAME)

 #STEP99:
             ENDPGM
