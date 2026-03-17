             PGM

  /** AM#C46SH ***********************************/
  /* SHIPPING PRODUCTION ANALYSIS BOARD          */
  /*    LEC       2020.04.14                     */
  /***********************************************/

             DCL        VAR(&SECT) TYPE(*CHAR) LEN(3) VALUE('SHP')
             DCL        VAR(&DATTIM) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)



 /* get current system date and time...                             */
 #START:     RTVJOBA    DATETIME(&DATTIM)
             CHGVAR     VAR(&DATE) VALUE(%SST(&DATTIM 1 8))
             CHGVAR     VAR(&TIME) VALUE(%SST(&DATTIM 9 6))

 /* create new work file for shipping planned data...               */
             DLTF       FILE(QTEMP/AM#WP446P)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AM#WP446P) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 /* create new work file for shipping actual data...                */
             DLTF       FILE(QTEMP/AM#WL446S)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/AM#WP446S)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AM#WP446S) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 /* create new work file logical for shipping actual data...        */
             CRTDUPOBJ  OBJ(AM#WL446S) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 /* run pgm to calculate "planned" data based on current date/time... */
             OVRDBF     FILE(AM#WP446P) TOFILE(QTEMP/AM#WP446P)
             CALL       PGM(AM#R446P) PARM(&SECT &DATE &TIME)

 /* run pgm to calculate "actual" data based on current date/time...  */
             OVRDBF     FILE(AM#WP446S) TOFILE(QTEMP/AM#WP446S)
             CALL       PGM(AM#R446A2)

 /* run pgm to consolidate TL, Dock, and Coverage TMs into one   ...  */
             OVRDBF     FILE(AM#WP446S) TOFILE(QTEMP/AM#WP446S)
             CALL       PGM(AM#R446C)

 /* run pgm to display PAB....                                        */
             OVRDBF     FILE(AM#WP446S) TOFILE(QTEMP/AM#WP446S)
             CALL       PGM(AM#R446S) PARM(&PCMD)

 /* if F1 was pressed to End...                                       */
             IF         COND(&PCMD *EQ '1') THEN(GOTO CMDLBL(#END))

             GOTO       CMDLBL(#START)

 #END:       SIGNOFF

             ENDPGM
