             PGM
             /** GCGC10 **************************/
             /* LOCATION CODE SHIPMENT NUMBER OF BOXES DISPLAY TAG PUBLICATION*/
             /*        SETTING NUMBER AUTOMATIC HANDLING> */
             /* A-IDOTA 1994.08.22 */
             /****************************GCGC10**/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SKUB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WS)
             CALL       PGM(KZZR00) PARM(&WS &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRT)


             GOTO       STPA
 /* EXCLUSIVE PART NUMBER M/F CREATE */
 STP1:       CLRPFM     FILE(GCENP30)
             CALL       PGM(GCER33)


 /* SECTION CODE CHANGE */
 STPA:       CALL       PGM(GCGR12)


 /* CONTENTS OF LABEL CREATE */
 STP2:       DLTF       FILE(GCGWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCGWP10) RCDLEN(100) TEXT('FOR +
                          LOC PER DAY SHIP DISPLAY LABEL PUBLIC +
                          WORKFILE') OPTION(*NOLIST) SIZE(5000) +
                          LVLCHK(*NO)
             CALL       PGM(GCGR10)


 /* SORT */
 STP3:       DLTF       FILE(GCGWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCGWP11) RCDLEN(100) TEXT('FOR +
                          LOC PER DAY SHIP DISPLAY LABEL PUBLIC +
                          WORKFILE') OPTION(*NOLIST) SIZE(5000) +
                          LVLCHK(*NO)
             FMTDTA     INFILE((HWFILE1/GCGWP10)) +
                          OUTFILE(HWFILE1/GCGWP11) SRCFILE(FMTSRC) +
                          SRCMBR(GCGS10) OPTION(*NOPRT)
             DLTF       FILE(GCGWP10)


 /* LABEL PUBLICATION */
 STP4:       OVRPRTF    FILE(GCGPR11) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINTE) FORMTYPE(D997) /* +
                          LOCATION PER DAY SHIPMENT LABEL */
             MONMSG     MSGID(CPF5004)
             CALL       PGM(GCGR11)
             DLTOVR     FILE(GCGPR11)
             DLTF       FILE(GCGWP11)


 END:        ENDPGM
