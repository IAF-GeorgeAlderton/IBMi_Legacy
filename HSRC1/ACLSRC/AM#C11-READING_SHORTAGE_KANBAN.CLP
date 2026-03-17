             PGM
    /*       PGM        PARM(&WORKER &WUSRID)        */
             /** AM#C11 ************************/
             /* READING SHORTAGE KANBAN        */
             /*   ITS.             2015.06.01  */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WUSRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1PPUL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9TICK) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AB#WP40) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR) TYPE(*CHAR) LEN(2)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&SR) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&AB#WP40) VALUE(AB#WP40 *CAT &SR)
             CHGVAR     VAR(&FILE2) VALUE(AB#WP41 *CAT &SR)
             DLTF       FILE(QTEMP/&AB#WP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&AB#WP40) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CHGJOB     OUTQ(&PRTG)

             OVRDBF     FILE(AB#WP40) TOFILE(QTEMP/&AB#WP40)
       /*    CALL       PGM(AM#R11) PARM(&WORKER &WUSRID &PCMD)   */
             CALL       PGM(AM#R11)
             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       CMDLBL(END)
             ENDDO

             CALL       PGM(AB#RL4)

             DLTF       FILE(QTEMP/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE2) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP41) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP40) TOFILE(QTEMP/&AB#WP40)
             OVRDBF     FILE(AB#WP41) TOFILE(QTEMP/&FILE2)
             CALL       PGM(AB#R41)

             OVRDBF     FILE(AB#WP41) TOFILE(QTEMP/&FILE2)
             CALL       PGM(AB#R42)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP41) TOFILE(QTEMP/&FILE2)
   /******   CALL       PGM(AB#R43)   **********/

 END:        DLTOVR     FILE(*ALL)
             ENDPGM
