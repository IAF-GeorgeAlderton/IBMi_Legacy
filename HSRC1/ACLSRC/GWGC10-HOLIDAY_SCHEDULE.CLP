             PGM
             /*** GWGC10 ***************************/
             /* HOLIDAY SCHEDULE                           */
             /*                                    */
             /*************************** GWGC10 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCLF       FILE(GWGPW10)

             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
  @SKIP:
             SNDRCVF    RCDFMT(DSP01)
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@SKIP))

             CLRPFM     FILE(&WLIB/GWSHP01)
             CLRPFM     FILE(&WLIB/GWPTP01)
             CLRPFM     FILE(&WLIB/GWMAT01)

             CALL       PGM(GWGR10)
             CALL       PGM(GWGR11)
             CALL       PGM(GWGR12)


 @END:       ENDPGM
