             PGM        PARM(&MFBC &WORKER)

             /** AM#C29 ************************/
             /* PACKING - CREATE/SEND JSON FOR */
             /*   SKID BUILD.                  */
             /*   LEC.             2021.02.18  */
             /**********************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MFBC) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ORD#) TYPE(*CHAR) LEN(12)
             DCL        VAR(&NAMC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DOCK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PALT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SKID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20) VALUE('SKID')
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&EXISTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRETTY) TYPE(*CHAR) LEN(1) VALUE('1')

  /***     PARSE OUT THE MANIFEST BAR CODE      ***********************/
             CHGVAR     VAR(&ORD#) VALUE(%SST(&MFBC 13 12))
             CHGVAR     VAR(&NAMC) VALUE(%SST(&MFBC 1 5))
             CHGVAR     VAR(&DOCK) VALUE(%SST(&MFBC 11 2))
             CHGVAR     VAR(&PALT) VALUE(%SST(&MFBC 37 2))
             CHGVAR     VAR(&SKID) VALUE(%SST(&MFBC 41 3))

             IF         COND(&ORD# = ' ') THEN(GOTO CMDLBL(#END))

  /********************************************************************/

             ADDLIBLE   LIB(YAJL) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GETURI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

  /********************************************************************/
  /*   Create Skid Build                                              */
  /********************************************************************/

             CHGVAR     VAR(&FILE) VALUE(&ORD# *TCAT '_' *TCAT &NAMC +
                          *TCAT '_' *TCAT &DOCK *TCAT '_' *TCAT +
                          &PALT *TCAT '_' *TCAT &SKID *TCAT '.json')

      /* Delete Old Files...       */
             CALL       PGM(AM#R421D) PARM(&APPID &FILE)

      /* Create JSON Data for TSCS skid build .....*/
             CALL       PGM(AM#R411) PARM(&WORKER &APPID &FILE +
                          &ORD# &NAMC &DOCK &PALT &SKID &PRETTY +
                          &EXISTS)


             IF         COND(&EXISTS = 'Y') THEN(DO)

  /********************************************************************/
  /* Send JSON Data To TSCS....*/
  /********************************************************************/

             CALL       PGM(AM#R401) PARM(&APPID &FILE)

  /* Process result messages to Outfile and Log the Transaction...*/
             CALL       PGM(AM#R412) PARM(&APPID &WORKER &ORD# &NAMC +
                                          &DOCK &PALT &SKID)
                        ENDDO

  /********************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

 #END:       ENDPGM
