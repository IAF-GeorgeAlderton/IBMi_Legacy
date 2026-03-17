             PGM
             /** AM#C19PL **********************/
             /* PACKING - UNSHORTS PACKING LIST*/
             /*   LEC.             2020.09.17  */
             /**********************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             DLTF       FILE(QTEMP/AB#WP37)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WP37) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(AB#WP37) TOFILE(QTEMP/AB#WP37)

  /*  summarize unshorts workfile (AM#WP19) into Packing List WF (AB#WP37)   */
             CALL       PGM(AM#R19S)

  /*  print packing list...                                                  */
             OVRPRTF    FILE(AB#PR3K) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(LANPRT03) FORMTYPE(K6S1) COPIES(2) +
                          SAVE(*YES) EXPDATE(*DAYS) DAYS(14)

  /*  save workfile for just in case...                                      */
             CPYF       FROMFILE(QTEMP/AB#WP37) +
                          TOFILE(HFILE1/AB#HP37) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)


             CALL       PGM(AB#R30)


             ENDPGM
