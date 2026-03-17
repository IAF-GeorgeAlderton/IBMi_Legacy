             PGM
             /** AM#CEE ********************************/
             /* SHIPPING - SPECIAL PERMISSION PGM MENU */
             /*   LEC.             2020.06.19          */
             /******************************************/
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WKNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

  /*   get worker code                                      */
             CALL       PGM(AM#R10) PARM(&WORKER &WKNM &VALID)

  /*  if valid, run scan program for original paperwork supplemental orders  */
             IF         COND(&VALID *EQ 'Y') THEN(CALL PGM(AM#REE) +
                          PARM(&WORKER &WKNM))

             SIGNOFF

 #END:       ENDPGM
