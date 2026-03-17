             PGM

  /** AM#C46PR ***********************************/
  /* PALLET UNLOAD PRODUCTION ANALYSIS BOARD     */
  /*    LEC       2020.03.31                     */
  /***********************************************/

             DCL        VAR(&SECT) TYPE(*CHAR) LEN(3) VALUE('PR')
             DCL        VAR(&DATTIM) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)



 /* get current system date and time...                             */
 #START:     RTVJOBA    DATETIME(&DATTIM)
             CHGVAR     VAR(&DATE) VALUE(%SST(&DATTIM 1 8))
             CHGVAR     VAR(&TIME) VALUE(%SST(&DATTIM 9 6))

 /* create new work file for pallet unload planned data...          */
             DLTF       FILE(QTEMP/AM#WP446P)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AM#WP446P) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 /* create new work file for pallet unload actual data...           */
             DLTF       FILE(QTEMP/AM#WP446A)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AM#WP446A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 /* run pgm to calculate "planned" data based on current date/time... */
             OVRDBF     FILE(AM#WP446P) TOFILE(QTEMP/AM#WP446P)
             CALL       PGM(AM#R446P) PARM(&SECT &DATE &TIME)

 /* run pgm to calculate "actual" data based on current date/time...  */
             OVRDBF     FILE(AM#WP446A) TOFILE(QTEMP/AM#WP446A)
             CALL       PGM(AM#R446A)

 /* run pgm to display PAB....                                        */
             CALL       PGM(AM#R447P) PARM(&PCMD)

 /* if F1 was pressed to End...                                       */
             IF         COND(&PCMD *EQ '1') THEN(GOTO CMDLBL(#END))

             GOTO       CMDLBL(#START)

 #END:       SIGNOFF

             ENDPGM
