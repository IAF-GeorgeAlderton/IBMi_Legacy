             PGM
             /** AM#C27 ************************/
             /* SERVICE PARTS - SHORTAGES      */
             /*   LEC.             2021.05.21  */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD3) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

  /*   have TM enter worker code                            */
             CALL       PGM(AM#R17W) PARM(&WORKER &PCMD3)

  /*  if user pressed F3,  end the program                  */
             IF         COND(&PCMD3 *EQ '1') THEN(GOTO CMDLBL(#END))

  /*  run program to scan short items                       */
             CALL       PGM(ALDR27) PARM(&WORKER &USER)

  /*  run program to Send Req Delv Due Date Adjustments for */
  /*      Shorted Items to SP SCS.                          */
             CALL       PGM(AM#C434)

  /*  run program to print Shortages and Email to Recipients*/
             CALL       PGM(ALDC27P)

 #END:       ENDPGM
