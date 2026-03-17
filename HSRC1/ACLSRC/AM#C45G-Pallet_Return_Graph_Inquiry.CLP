             PGM        PARM(&WKCD &STDT &STHR)
             /** AM#C45G ***********************/
             /* PALLET RETURN GRAPH INQUIRY    */
             /*   LEC.             2019.11.14  */
             /**********************************/

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STDT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&STHR) TYPE(*CHAR) LEN(2)


  /*******************************************************************/

             DLTF       FILE(QTEMP/AM#WP45G)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AM#WP45G) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AM#WP45G)

             OVRDBF     FILE(AM#WP45G) TOFILE(QTEMP/AM#WP45G)

  /*******************************************************************/
             CALL       PGM(AM#R45W) PARM(&WKCD &STDT)

             CALL       PGM(AM#R45G) PARM(&STHR)

  /*******************************************************************/

             DLTOVR     FILE(*ALL)

             ENDPGM
