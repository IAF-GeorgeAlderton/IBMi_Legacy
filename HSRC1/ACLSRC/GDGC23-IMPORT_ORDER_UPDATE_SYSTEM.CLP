             PGM
             /** GDGC23 *********************/
             /*  IMPORT ORDER UPDATE SYSTEM */
             /*        K.YASUDA  2000/12/06 */
             /*                             */
             /*  GDGR24 OUTQ-> IMPORT       */
             /********************* GDGC23 **/
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

             DLTF       FILE(GDGWP23)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDGWP23) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(GDGR26)

             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             DLTF       FILE(GDGWP23)
             MONMSG     MSGID(CPF3261 CPF2105)
             GOTO       END
             ENDDO

             DLTF       FILE(GDGWP24)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDGWP24) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/GDGWP23)) +
                          OUTFILE(&WLIB/GDGWP24) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDGS23) +
                          OPTION(*NOPRT)
             DLTF       FILE(GDGWP23)
             MONMSG     MSGID(CPF3261 CPF2105)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) RPLUNPRT(*YES) +
                          OUTQ(IMPORT) FORMTYPE(K6S1) HOLD(*YES)
      /*  現在保留中  */
      /*     CALL       PGM(GDGR24) PARM(&USER)    */

             DLTF       FILE(GDGWP24)
             MONMSG     MSGID(CPF3261 CPF2105)
 END:        ENDPGM
