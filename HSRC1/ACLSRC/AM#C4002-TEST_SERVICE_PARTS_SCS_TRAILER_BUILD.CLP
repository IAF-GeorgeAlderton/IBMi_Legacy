             PGM

  /** AM#C4002  **********************************/
  /* TEST --- SERVICE PARTS SCS TRAILER BUILD    */
  /*    LEC       2022.02.11                     */
  /***********************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&SURT) TYPE(*CHAR) LEN(9)
             DCL        VAR(&SHID) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SHIT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TRLR) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DRFN) TYPE(*CHAR) LEN(9)
             DCL        VAR(&DRLN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SUPPCD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&EXISTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRETTY) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&SCAC) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)
             DCL        VAR(&PATH) TYPE(*CHAR) LEN(500) +
                          VALUE('/toyota/scs/serviceparts/json/post/')
             DCL        VAR(&NEWPATH) TYPE(*CHAR) LEN(500)

  /*******************************************************************/
  /*   consume SP response -- extract TOKEN                          */

             ADDLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&APPID) VALUE('TOKEN')
             CHGVAR     VAR(&FILE)  VALUE('RESPONSE.JSON')

             CALL       PGM(AM#R406) PARM(&APPID &FILE &TOKEN)

  /********************************************************************/
  /*     Get Input parameters for Trailer Build...                    */
  /********************************************************************/

             CALL       PGM(AM#R21PR) PARM(&SURT &SHID &SHIT &TRLR +
                          &DRFN &DRLN &PCMD &SCAC)

             IF         COND(&PCMD *NE '03') THEN(DO)


  /********************************************************************/
  /*   create SP trailer build json data...                          */

             CHGVAR     VAR(&APPID) VALUE('SPTRAILER')
             CHGVAR     VAR(&SUPPCD) VALUE('0242C')
             CHGVAR     VAR(&FILE) VALUE(&SHID *TCAT '_' *TCAT &SURT +
                          *TCAT '_' *TCAT &SUPPCD *TCAT '.json')

             CALL       PGM(AM#R403) PARM(&WORKER &SUPPCD &SURT +
                          &SHID &SHIT &TRLR &DRFN &DRLN &APPID +
                          &EXISTS &PRETTY &SCAC &FILE)

  /*******************************************************************/
  /*   post service parts json file to toyota website api...         */

             ADDLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)
  /*                                                                 */

             IF         COND(&EXISTS = 'Y') THEN(DO)

             CALL       PGM(AM#R407) PARM(&APPID &FILE &TOKEN)

  /*******************************************************************/
  /*   process results received from trailer build POST...           */

             CALL       PGM(AM#R409) PARM(&APPID &SHID &SHIT &TRLR +
                          &DRFN &DRLN &SURT &SCAC &SUPPCD &WORKER)

  /*******************************************************************/
  /*   pull json from IFS into workfile to be transferred to text    */

             CHGVAR     VAR(&NEWPATH) VALUE(&PATH *TCAT &APPID *TCAT +
                          '/' *TCAT &FILE)

             CPYFRMSTMF FROMSTMF(&NEWPATH) +
                          TOMBR('/QSYS.LIB/HWFILE1.LIB/TESTJSON.FILE/+
                          TESTJSON.MBR') MBROPT(*REPLACE) +
                          CVTDTA(*AUTO) ENDLINFMT(*ALL) TABEXPN(*YES)

  /*******************************************************************/
                          ENDDO

                   ENDDO

  /*******************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ENDPGM
