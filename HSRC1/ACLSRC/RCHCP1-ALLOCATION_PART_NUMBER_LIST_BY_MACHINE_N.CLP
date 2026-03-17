             PGM
             /** RCHCP1 **************************************************/
             /*  ALLOCATION PART NUMBER LIST BY MACHINE NO CREATE OP-EDP */
             /*    M-OKUDA      1983.11.10                               */
             /*    N-HYOTO      2001.03.06                               */
             /*    J-WATANABE   2016.06.23  CHG FILE CAPACITY            */
             /*    JW1          2018.09.07  CHG MESSAGE                  */
             /************************************************************/
             DCLF       FILE(RCHPW10) RCDFMT(RCHPW101)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DYY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DYYMM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&AYY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SWITCH) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AAVACT' 'RCHCP1' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ')  THEN(GOTO END)
/* =================================================================*/

             CHGJOB     RUNPTY(40) SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

 STEP00:     SNDRCVF  DEV(&WSID) RCDFMT(RCHPW101)
             IF         (&IN01 *EQ '1') GOTO ENDP
             CHGVAR   VAR(&IN99) VALUE('0')

             IF         (%SUBSTRING(&YYMM 1 4) *LT '1980') GOTO STEPE1
             IF         (%SUBSTRING(&YYMM 5 2) *GT   '12') GOTO STEPE2
             IF         (%SUBSTRING(&YYMM 5 2) *LT   '01') GOTO STEPE2

             IF         (&KADO *GT '25') GOTO STEPE3
             IF         (&KADO *LT '15') GOTO STEPE3

             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGVAR     VAR(&DYY) VALUE(%SUBSTRING(&MCEDP01 1 4))
             CHGVAR     VAR(&DYYMM) VALUE(%SUBSTRING(&MCEDP01 1 6))
             CHGVAR     VAR(&AYY) VALUE(%SUBSTRING(&YYMM 1 4))

             IF         (&DYYMM *LT &YYMM) GOTO STEPEE
             GOTO       STEPST

 STEPE1:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RESULT MONTH YY <YY> IS LOGICAL ERROR')
             GOTO       STEP00

 STEPE2:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RESULT MONTH MM <MM> IS LOGICAL ERROR')
             GOTO       STEP00

 STEPE3:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('A VALUE OF OPERATION DAYS IS LOGICAL +
             ERROR')
             GOTO       STEP00

 STEPEE:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RESULT DATE IS NOT MADE YET')
             GOTO       STEP00

STEPST:
      /*JW1  STEPST: CHKOBJ     OBJ(AAVACT) OBJTYPE(*DTAARA)                 */
      /*     MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEPAA))             */
      /*                                                                     */
      /*     STEPTA: SNDPGMMSG  MSG('( G ) PRESENT PRECEDING PROCESS M/F +   */
      /*             WAIT FOR LIST MAKING FOR A WHILE !!') TOMSGQ(&WSID) +   */
      /*             KEYVAR(&MBAN)                                           */
      /*     RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +             */
      /*                MSG(&KOTAE)                                          */
      /*     IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +       */
      /*                  THEN(GOTO CMDLBL(STEPTA))                          */
      /*     RETURN                                                          */
      /*     GOTO       END                                                  */
      /*                                                                     */
      /*     STEPAA: CRTDTAARA  DTAARA(HFILE1/AAVACT) TYPE(*CHAR) LEN(10)    */

             DLTF       FILE(&WLIB/RCHWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/RCHWP11) RCDLEN(7) +
                          OPTION(*NOLIST *NOSOURCE) SIZE(30 1 1) +
                          LVLCHK(*NO)

             GRTOBJAUT  OBJ(RCHWP11) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)
             CALL       PGM(RCHR11)
             RTVJOBA    SWS(&SWITCH)

             IF         (%SUBSTRING(&SWITCH 1 1) *EQ '1') GOTO STEP99
             IF         (%SUBSTRING(&SWITCH 8 1) *EQ '1') GOTO STEP77

 STEPCR:     CHKOBJ     OBJ(FCADP2) OBJTYPE(*DTAARA) /* PRECEDING +
                          PROCESS USED CHECK */
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP77))

 STEP78:     SNDPGMMSG  MSG('( G.R ) PRESENT TEN DAYS RESULT FILE CREATING +
                          WAIT FOR A WHILE !!') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'R') *OR (&KOTAE *EQ 'r')) +
                          THEN(GOTO CMDLBL(STEPCR))
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(STEP78))
             DLTDTAARA  DTAARA(AAVACT)
             RETURN
             GOTO       ENDP

 STEP77:     IF         (%SUBSTRING(&SWITCH 2 1) *EQ '0') GOTO STEP30

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) OVRFLW(80) RPLUNPRT(*YES ' ') +
                          OUTQ(&PRT) FORMTYPE(K8H2) IGCDTA(&PIGCD)
             DLTF       FILE(RCHWPP1)
             MONMSG     MSGID(CPF3261 CPF2105)

       /*JW  CRTPF      FILE(HWFILE1/RCHWPP1) RCDLEN(512) +       */
       /*                 OPTION(*NOLIST) SIZE(2000 1000 2) +     */
       /*                 LVLCHK(*NO) AUT(*ALL)                   */
       /*JW CHG 2,000 --> 50,000*/
             CRTPF      FILE(HWFILE1/RCHWPP1) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(50000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(HWFILE1/RCHWPP1)
             CALL       PGM(RCHR12) PARM(&US &YYMM &KADO)
             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(OUTPUT1)
             GOTO       STEP99

 STEP30:     OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) OVRFLW(80) RPLUNPRT(*YES ' ') +
                          OUTQ(&PRT) FORMTYPE(K8H2) IGCDTA(&PIGCD)
             CALL       PGM(RCHR13) PARM(&US &YYMM &KADO)
             DLTOVR     FILE(QPRINT)

 STEP99:     DLTF       FILE(RCHWP11)
 ENDP:
      /*JW1**DLTDTAARA  DTAARA(AAVACT)****************/
             CALL CHKC45 ('AAVACT' 'RCHCP1' 'N'  '' '')

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
