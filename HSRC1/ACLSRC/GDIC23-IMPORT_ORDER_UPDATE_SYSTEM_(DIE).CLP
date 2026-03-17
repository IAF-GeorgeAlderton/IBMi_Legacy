             PGM
             /** GDIC23 ***************************/
             /*  IMPORT ORDER UPDATE SYSTEM (DIE) */
             /*              K.YASUDA  2000/12/07 */
             /*************************** GDIC23 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGJOB     OUTQ(&PRTG) SWS(00000000)

             DLTF       FILE(GDIWP23)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDIWP23) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

       /*    CALL       PGM(GDIR23) PARM(&USER)   */
             CALL       PGM(GDIR26)

             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             DLTF       FILE(GDIWP23)
             MONMSG     MSGID(CPF3261 CPF2105)
             GOTO       END
             ENDDO

             DLTF       FILE(GDIWP24)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDIWP24) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/GDIWP23)) +
                          OUTFILE(&WLIB/GDIWP24) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDIS23) +
                          OPTION(*NOPRT)
             DLTF       FILE(GDIWP23)
             MONMSG     MSGID(CPF3261 CPF2105)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 80) +
                          RPLUNPRT(*YES) OUTQ(LANPRT02) FORMTYPE(K6S1)

      /*  現在保留中  */
      /*     CALL       PGM(GDIR24) PARM(&USER)   */

             DLTF       FILE(GDIWP24)
             MONMSG     MSGID(CPF3261 CPF2105)

 END:        ENDPGM
