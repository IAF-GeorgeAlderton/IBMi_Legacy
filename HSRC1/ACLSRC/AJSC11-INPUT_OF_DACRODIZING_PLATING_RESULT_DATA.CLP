             PGM
/** AJSC11 *************************************************/
/* INPUT OF DACRODIZING PLATING RESULT DATA.               */
/*               CREATE DATE : 1997/MAR/10.                */
/*               AUTHOR      : S.OHTAKE.                   */
/* TCHK1 01/07/11 ADD COPY AJSWP94 TO AJSWP94A             */
/* TCHK2 11/15/13 ADD COPY AJSWP95 TO AJSWP95A             */
/***********************************************************/
             DCLF       FILE(AJSPW11)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWITCH) TYPE(*CHAR) LEN(8)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10)
             RTVJOBA    JOB(&WSID)   USER(&US)   SWS(&SWITCH)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     RUNPTY(40)

 STEP1:      SNDRCVF  DEV(&WSID)      RCDFMT(AJSPW111)
             IF       (&IN01 *EQ '1') GOTO END
             IF       (&IN05 *EQ '0') GOTO STEP1

             /***********************************************/
             /*  DACRODIZING PLATING ADMIT     RESULT DATA  */
             /***********************************************/
             CHKOBJ     OBJ(HWFILE1/AJSWP95) OBJTYPE(*FILE) AUT(*ALL)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP2))

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/AJSWP95) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(STEP2)) /* +
                          ファイルが０件かのチェック */
             OVRPRTF    FILE(QPRINT3) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          156) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT4) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          156) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1)
             CALL AJSR2A

/* TCHK2 */  CPYF       FROMFILE(HWFILE1/AJSWP95)  +
                          TOFILE(HWFILE1/AJSWP95A) +
                          MBROPT(*ADD)

             DLTOVR     FILE(QPRINT3)
             DLTOVR     FILE(QPRINT4)

             /***********************************************/
             /*  DACRODIZING PLATING DISCHARGE RESULT DATA  */
             /***********************************************/
 STEP2:      CHKOBJ     OBJ(HWFILE1/AJSWP94) OBJTYPE(*FILE) AUT(*ALL)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP3))

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/AJSWP94) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(STEP3)) /* +
                          ファイルが０件かのチェック */
             OVRPRTF    FILE(QPRINT3) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          156) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT4) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          156) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1)
             CALL AJSR2B

/* TCHK1 */  CPYF       FROMFILE(HWFILE1/AJSWP94)  +
                          TOFILE(HWFILE1/AJSWP94A) +
                          MBROPT(*ADD)

             DLTOVR     FILE(QPRINT3)
             DLTOVR     FILE(QPRINT4)

 /*          OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1) */
 /*          CALL AJSR2E                              */
 /*          DLTOVR     FILE(QPRINT)                  */

             /***********************************************/
             /*  DACRODIZING PLATING BREAKDOWN RESULT DATA  */
             /***********************************************/
 STEP3:      CHKOBJ     OBJ(HWFILE1/AJSWP96) OBJTYPE(*FILE) AUT(*ALL)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP4))

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/AJSWP96) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(STEP4)) /* +
                          ファイルが０件かのチェック */

             OVRPRTF    FILE(QPRINT3) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT4) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1)
             CALL AJSR2C
             DLTOVR     FILE(QPRINT3)
             DLTOVR     FILE(QPRINT4)

             /***********************************************/
             /*  DACRODIZING PLATING OPERATION RESULT DATA  */
             /***********************************************/
 STEP4:      CHKOBJ     OBJ(HWFILE1/AJSWP97) OBJTYPE(*FILE) AUT(*ALL)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(END))

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/AJSWP97) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(STEP5)) /* +
                          ファイルが０件かのチェック */

             OVRPRTF    FILE(QPRINT3) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT4) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1)
             CALL AJSR2D
             DLTOVR     FILE(QPRINT3)
             DLTOVR     FILE(QPRINT4)

             /***********************************/
             /*  WORKFILE CLAER                 */
             /***********************************/
 STEP5:      DLTF       FILE(HWFILE1/AJSWP94)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP94) RCDLEN(150) TEXT('WORK +
                          DACRODIZING PLATING DISCHARGE RESULT +
                          FILE') OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(HWFILE1/AJSWP95)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP95) RCDLEN(150) TEXT('WORK +
                          DACRODIZING PLATING ADMIT RESULT FILE') +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(HWFILE1/AJSWP96)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP96) RCDLEN(150) TEXT('WORK +
                          DACRODIZING PLATING BREAKDOWN RESULT FILE') +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(HWFILE1/AJSWP97)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP97) RCDLEN(150) TEXT('WORK +
                          DACRODIZING PLATING OPERATION RESULT FILE') +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

 END:        CHGJOB     RUNPTY(20)

             DLTOVR     FILE(*ALL)
             ENDPGM
