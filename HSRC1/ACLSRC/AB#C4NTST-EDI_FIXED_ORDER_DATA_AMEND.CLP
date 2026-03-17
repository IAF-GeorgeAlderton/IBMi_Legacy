             PGM
/** AB#C4N ************************************************/
/*  TEST AB#R4N                                           */
/************************************************ AB#C4N **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC)   TYPE(*DEC) LEN(10 0) VALUE(0)

/* TCHK1 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK1 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK1 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&SR) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE(AB#WP40 *CAT &SR)
             CHGVAR     VAR(&FILE2) VALUE(AB#WP41 *CAT &SR)
             CHGVAR     VAR(&FILE3) VALUE(ALDWP69 *CAT &SR)

             DLTF       FILE(QTEMP/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALDWP69) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP40) TOFILE(QTEMP/&FILE1)
             OVRDBF     FILE(ALDWP69) TOFILE(QTEMP/&FILE3)
             CALL       PGM(TOBJ1/AB#R4N) PARM(&USER)



/** TEMP ********************************************/
GOTO ENDP
/****************************************************/



             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       NXT
             ENDDO

   /*|START| UPDATE LOG */
             CALL       PGM(AB#RL4)

             DLTF       FILE(QTEMP/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE2) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP41) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP40) TOFILE(QTEMP/&FILE1)
             OVRDBF     FILE(AB#WP41) TOFILE(QTEMP/&FILE2)
             CALL       PGM(AB#R41)

             OVRDBF     FILE(AB#WP41) TOFILE(QTEMP/&FILE2)
             CALL       PGM(AB#R42)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP41) TOFILE(QTEMP/&FILE2)
      /****  CALL       PGM(AB#R43)   ********/
   /*|END| UPDATE LOG */

   /* %0001  ALDWP69--->  AU#PP11                           */
      /*            --->  ALDPP65 (RCVR DATE UPDATE)        */
 NXT:
             RTVMBRD    FILE(QTEMP/&FILE3) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

      /* TEMP FOR TEST */
             CPYF       FROMFILE(QTEMP/&FILE3) +
                          TOFILE(SAKAKI/ALDWP69) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALDWP69) TOFILE(QTEMP/&FILE3)
             CALL       PGM(ALDR69)
             ENDDO

 ENDP:       DLTOVR     FILE(*ALL)

             ENDPGM
