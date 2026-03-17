             PGM
             /** AM#C29 ******************************/
             /* SERVICE PARTS - SHORTAGE REVERSALS   */
             /*   LEC.             2022.06.28        */
             /****************************************/
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

  /*  run program to scan short items to be reversed        */
             CALL       PGM(ALDR29) PARM(&WORKER &USER &PCMD3)

  /*  if user pressed F3 with no scans,  end the program    */
             IF         COND(&PCMD3 *EQ '1') THEN(GOTO CMDLBL(#END))

  /*  run program to Send Req Delv Due Date Adjustments for */
  /*    UNShorted Items to SP SCS.                          */
             CALL       PGM(AM#C4342)

  /*  run program to print reversals and Email to Recipients*/
             CALL       PGM(ALDC29P)

  /*  save workfile records to log file and clear           */
             CPYF       FROMFILE(HWFILE1/ALDWP29) +
                          TOFILE(HFILE1/ALDPP29) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(HWFILE1/ALDWP29)
             MONMSG     MSGID(CPF0000)


 #END:       ENDPGM
