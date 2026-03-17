             PGM

             /** AM#C29VW **********************/
             /* PACKING - CREATE/VIEW JSON FOR */
             /*   SKID BUILD.                  */
             /*   LEC.             2021.02.25  */
             /**********************************/

             DCLF       FILE(AM#PW29T) RCDFMT(DSP01)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20) VALUE('SKID')
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PATH) TYPE(*CHAR) LEN(250)
             DCL        VAR(&EXISTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRETTY) TYPE(*CHAR) LEN(1) VALUE('1')

  /********************************************************************/

             SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(#END))

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

             CHGVAR     VAR(&PATH) +
                          VALUE('/toyota/scs/masspro/json/post/skid/' +
                          *TCAT &FILE)

      /* Delete Old Files...       */
             CALL       PGM(AM#R421D) PARM(&APPID &FILE)

      /* Create JSON Data for TSCS skid build .....*/
             CALL       PGM(AM#R411) PARM(&WORKER &APPID &FILE +
                          &ORD# &NAMC &DOCK &PALT &SKID &PRETTY +
                          &EXISTS)


             IF         COND(&EXISTS = 'Y') THEN(DO)

  /********************************************************************/
  /* View JSON Data....        */
  /********************************************************************/

             CPYFRMSTMF FROMSTMF(&PATH) +
                          TOMBR('/QSYS.LIB/HWFILE1.LIB/TESTJSON.FILE/+
                          TESTJSON.MBR') MBROPT(*REPLACE) +
                          CVTDTA(*AUTO) ENDLINFMT(*ALL) TABEXPN(*YES)

             RUNQRY     QRY(VIEWJSON)

                        ENDDO

  /********************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

 #END:       ENDPGM
