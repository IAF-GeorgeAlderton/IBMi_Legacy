             PGM
             /** GCEC31 ********************************************/
             /* .. ISSUE LABEL DISPLAYING DAILY SHIPMENT OF AN ADDRESS */
             /*           A-IDOTA           1987.08.22             */
             /*                                                    */
             /*  APR/10/02                                         */
             /*    ASJ HAKO = 3 DAYS                               */
             /*     CALL GCER38 INSTEAD OF GCER32                  */
             /**********************************************GCEC31**/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SKUB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WS) USER(&USER)
             CHGJOB     RUNPTY(40) SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)
 STP1:
             MONMSG     MSGID(CPF9999)
             CHGJOB     OUTQ(&PRT)
 /* SELECT PART# */
              CALL       PGM(GCER30) PARM(&SKUB)
              IF         (%SWITCH(1XXXXXXX)) GOTO END
              /******/
  /* SPECIAL PART# */
              IF         COND(&SKUB = 'Y') THEN(DO)
              CLRPFM     FILE(GCENP30)
              CALL       PGM(GCER33)
              ENDDO
              /******/
  /* CONTENTS OF THE LABEL  */
             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) OVRFLW(63) +
                          RPLUNPRT(*YES) OUTQ(QPRINTC) +
                          FORMTYPE(K6S1) HOLD(*YES) /* KANBAN +
                          UNMATCH LIST */
              CALL       PGM(GCER38)
              DLTOVR     FILE(QPRINT)
              DLTF       FILE(GCEWP31)
              MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GCEWP31) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)
             DLTF       FILE(GCEWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GCEWP32) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)
             /******/
 /* CHECK DIFFERENCE  */
             CALL       PGM(GCER36)
             FMTDTA     INFILE((&WLIB/GCEWP31)) +
                          OUTFILE(&WLIB/GCEWP32) SRCFILE(FMTSRC) +
                          SRCMBR(GCES31) OPTION(*NOPRT)
             /******/
 /* ISSUE THE LABEL */
             OVRPRTF    FILE(GCEPR31) DEVTYPE(*AFPDS) LPI(6) +
                          FOLD(*YES) RPLUNPRT(*YES) OUTQ(QPRINTC) +
                          FORMTYPE(D997) /* LABEL PER LOCATION   */
             MONMSG     MSGID(CPF5004)
             CALL       PGM(GCER39)
             DLTOVR     FILE(GCEPR31)
             CLRPFM     FILE(GCEWP30)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
