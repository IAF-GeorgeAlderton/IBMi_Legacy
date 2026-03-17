             PGM
             /** NCHC10 **************************/
             /*   EXPLANATION MATERIAL FOR FACILITY ABILITY EXAMINATION   */
             /* A.IDOTA 1993.05.10 */
             /* JW1   2018.09.07 CHG ERROR MSG FOR USING OTHER */
             /************************** NCHC10 **/
             DCLF       FILE(NCHPW10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WHIZ1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WHIZ2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WHIZ3) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WHIZ)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WYY) TYPE(*DEC) LEN(4) VALUE(0)
             DCL        VAR(&WMM) TYPE(*DEC) LEN(2) VALUE(0)
             DCL        VAR(&WKADO) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ABBDS2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AAVACT' 'NCHC10' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ')  THEN(GOTO SEND)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&US)
             RTVDTAARA  DTAARA(ABBDS2) RTNVAR(&ABBDS2)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

      /*JW1  CHKOBJ     OBJ(AAVACT) OBJTYPE(*DTAARA)                      */
      /*     MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))            */
      /*                                                                  */
      /*     STP2: SNDPGMMSG  MSG('( G ) PART INFORMATION M/F UPDATE +    */
      /*                  HANDLING BECAUSE SYSTEM IS ACTIVE,WAIT +        */
      /*                  FOR A WHILE..') TOMSGQ(&WSID) +                 */
      /*                  MSGTYPE(*INQ) KEYVAR(&MBAN)                     */
      /*     RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +          */
      /*                  MSG(&KOTE)                                      */
      /*     IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +      */
      /*                  THEN(GOTO CMDLBL(STP2))                         */
      /*     GOTO       SEND                                              */
      /*                                                                  */
      /*     STP1: CRTDTAARA  DTAARA(HFILE1/AAVACT) TYPE(*CHAR) LEN(10) + */
      /*           TEXT('PART INFORMATION M/F UPDATE SYSTEM IS ACTIVE') + */
      /*           AUT(*ALL)                                              */

             CHGVAR     VAR(&N2HZ1) VALUE(&ABBDS2)
             CHGVAR     VAR(&WYY) VALUE(%SST(&ABBDS2 1 4))
             CHGVAR     VAR(&WMM) VALUE(%SST(&ABBDS2 5 2))

             IF         (&WMM *EQ 12) DO
             CHGVAR     VAR(&WYY) VALUE(&WYY+1)
             CHGVAR     VAR(&WMM) VALUE(01)
             ENDDO
             ELSE DO
             CHGVAR     VAR(&WMM) VALUE(&WMM+1)
             ENDDO
             CHGVAR     VAR(%SST(&WHIZ 1 4)) VALUE(&WYY)
             CHGVAR     VAR(%SST(&WHIZ 5 2)) VALUE(&WMM)
             CHGVAR     VAR(&N2HZ2) VALUE(&WHIZ)

             IF         (&WMM *EQ 12) DO
             CHGVAR     VAR(&WYY) VALUE(&WYY+1)
             CHGVAR     VAR(&WMM) VALUE(01)
             ENDDO
             ELSE DO
             CHGVAR     VAR(&WMM) VALUE(&WMM+1)
             ENDDO
             CHGVAR     VAR(%SST(&WHIZ 1 4)) VALUE(&WYY)
             CHGVAR     VAR(%SST(&WHIZ 5 2)) VALUE(&WMM)
             CHGVAR     VAR(&N2HZ3) VALUE(&WHIZ)

             CHGVAR     VAR(&N1HZ3) VALUE(&N2HZ2)
             CHGVAR     VAR(&N1HZ2) VALUE(&N2HZ1)

             CHGVAR     VAR(&WYY) VALUE(%SST(&ABBDS2 1 4))
             CHGVAR     VAR(&WMM) VALUE(%SST(&ABBDS2 5 2))

             IF         (&WMM *EQ 01) DO
             CHGVAR     VAR(&WYY) VALUE(&WYY-1)
             CHGVAR     VAR(&WMM) VALUE(12)
             ENDDO
             ELSE DO
             CHGVAR     VAR(&WMM) VALUE(&WMM-1)
             ENDDO
             CHGVAR     VAR(%SST(&WHIZ 1 4)) VALUE(&WYY)
             CHGVAR     VAR(%SST(&WHIZ 5 2)) VALUE(&WMM)
             CHGVAR     VAR(&N1HZ1) VALUE(&WHIZ)

             CHGVAR     VAR(&NPATN) VALUE('2')

 STP3:       SNDRCVF    RCDFMT(NCHPW101)

             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&NBMON *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('LIST MAKING SECTION IS NOT INPUT+
                          ')
             GOTO       STP3
             ENDDO

             IF         (&NJIHZ *EQ '    ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RESULTS DATE IS NOT INPUT')
             GOTO       STP3
             ENDDO

             IF       ((%SST(&NJIHZ 1 4) *LT '1986') *OR (%SST(&NJIHZ +
                          5 2) *LT '01') *OR (%SST(&NJIHZ 5 2) *GT +
                          '12')) DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RESULTS DATE IS NOT RIGHT')
             GOTO       STP3
             ENDDO

             IF         ((&NYOSI *NE 'K6H1') *AND (&NYOSI *NE 'K6H2') +
                          *AND (&NYOSI *NE 'K6H3')) DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PAPER INSTRUCTION IS <K6H1 +
                          K6H2 K6H3>')
             GOTO       STP3
             ENDDO

             IF         ((&NPATN *NE '1') *AND (&NPATN *NE '2')) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PRODUCT DEMAND FORECAST +
                          PATTERN INSTRUCTION IS <1 2>')
             GOTO       STP3
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP3

             IF         (&NPATN *EQ '1') DO
             CHGVAR     VAR(&WHIZ1) VALUE(&N1HZ1)
             CHGVAR     VAR(&WHIZ2) VALUE(&N1HZ2)
             CHGVAR     VAR(&WHIZ3) VALUE(&N1HZ3)
             ENDDO
             ELSE       DO
             CHGVAR     VAR(&WHIZ1) VALUE(&N2HZ1)
             CHGVAR     VAR(&WHIZ2) VALUE(&N2HZ2)
             CHGVAR     VAR(&WHIZ3) VALUE(&N2HZ3)
             ENDDO

             CLRPFM     FILE(NCHNP02)
             CALL       PGM(NCHR10) PARM(&NJIHZ &WHIZ1 &WKADO)

             OVRPRTF    FILE(NCHPR11) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) SPOOL(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(&NYOSI)
             CALL       PGM(NCHR11) PARM(&NBMON &NKINO &NJIHZ &WHIZ1 +
                          &WHIZ2 &WHIZ3 &US &WKADO)
             DLTOVR     FILE(NCHPR11)
             CLRPFM     FILE(NCHNP02)

 END:
       /*JW1*DLTDTAARA  DTAARA(AAVACT)******************/
             CALL CHKC45 ('AAVACT' 'NCHC10' 'N'  '' '')

 SEND:       ENDPGM
