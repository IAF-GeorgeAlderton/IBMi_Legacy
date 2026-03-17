             PGM
             /** MBDCP4 **********************/
             /*NO RESULT  PART NUMBER LIST */
             /* I-HASADA 83.07.02 */
             /* H-AMANO  03.04.04                   */
             /********************** MBDCP4 **/
             DCLF       FILE(MBDPW41)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHYM1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHYM2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PKAGT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&PHYM2) VALUE(%SUBSTRING(&MCEDP01 1 6))
             CHGVAR     VAR(&PNO) VALUE('3')
             CHGVAR     VAR(&PKAGT) VALUE('2')
             CHGVAR     VAR(&PLSNO) VALUE('3')

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(MBDPW411)

             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&PNO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('REVERSING FIELD IS NOT INPUT')
             GOTO       STP1
             ENDDO

             IF         COND((&PNO *NE '1') *AND (&PNO *NE '2') *AND +
                          (&PNO *NE '3')) THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('REVERSING FIELD IS 1 2 3')
             GOTO       STP1
             ENDDO

             IF         COND(&PKAGT *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('REVERSING FIELD IS NOT INPUT')
             GOTO       STP1
             ENDDO

             IF         COND(&PNO *EQ '2') THEN(DO)

             IF         COND(&PKAGT *NE '1') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                        VALUE('IN CASE OF NEW PRODUCTION IS ONLY PAST 1 MONTH')
             GOTO       STP1
             ENDDO

             ENDDO
             ELSE       DO

             IF         COND((&PKAGT *NE '1') *AND (&PKAGT *NE '2') +
                          *AND (&PKAGT *NE '3') *AND (&PKAGT *NE +
                          '4') *AND (&PKAGT *NE '5') *AND (&PKAGT +
                          *NE '6')) THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PAST 1 MONTH - UNTIL PAST 6 MONTHS')
             GOTO       STP1
             ENDDO
             ENDDO

             IF         COND(&PLSNO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('REVERSING FIELD IS NOT INPUT')
             GOTO       STP1
             ENDDO

             IF         COND((&PLSNO *NE '1') *AND (&PLSNO *NE '2') +
                          *AND (&PLSNO *NE '3')) THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('REVERSING FIELD IS 1 2 3')
             GOTO       STP1
             ENDDO

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(STP1))

             DLTF       FILE(MBDWP421)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWP421) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(25000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(MBDWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWP41) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(25000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MBDR41) PARM(&PHYM1 &PHYM2 &PKAGT)

             DLTF       FILE(MBDWP441)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWP441) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(25000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(MBDWP442)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWP442) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(25000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MBDR44) PARM(&PNO &PHYM &PHYM2)
  /*TEST     DLTF       FILE(MBDWP41)   */

             /*------------------------------------*/
             /* THE PAST   MONTH NO RESULTS LIST   */
             /*------------------------------------*/
             IF         COND((&PNO *EQ '1') *OR (&PNO *EQ '3')) +
                          THEN(DO)

             IF         (%SWITCH(0XXXXXXX)) DO
   /*TEST    DLTF       FILE(MBDWP441)       */

             ENDDO
             ELSE       DO

             /*----------------------*/
             /* LISTS BY PART NUMBER    */
             /*----------------------*/
             IF         COND((&PLSNO *EQ '1') *OR (&PLSNO *EQ '3')) +
                          THEN(DO)

             DLTF       FILE(MBDWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWP42) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(25000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)


             FMTDTA     INFILE((HWFILE1/MBDWP441)) +
                          OUTFILE(HWFILE1/MBDWP42) SRCFILE(FMTSRC) +
                          SRCMBR(MBDS42) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRT) FORMTYPE(K6S1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(MBDR42) PARM(&USER '1' &PHYM &PHYM1 +
                          &PHYM2 &PKAGT)
             DLTOVR     FILE(QPRINT)
   /*TEST    DLTF       FILE(MBDWP42)    */

             ENDDO

             /*--------------------------*/
             /* LIST BY USER */
             /*--------------------------*/
             IF         COND((&PLSNO *EQ '2') *OR (&PLSNO *EQ '3')) +
                          THEN(DO)

             DLTF       FILE(MBDWP43)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWP43) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(25000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/MBDWP441)) +
                          OUTFILE(HWFILE1/MBDWP43) SRCFILE(FMTSRC) +
                          SRCMBR(MBDS43) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRT) FORMTYPE(K6S1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(MBDR43) PARM(&USER '1' &PHYM &PHYM1 +
                          &PHYM2 &PKAGT)
             DLTOVR     FILE(QPRINT)
 /*TEST      DLTF       FILE(MBDWP43)   */

             ENDDO

 /*TEST      DLTF       FILE(MBDWP441)  */
             ENDDO
             ENDDO

             /*----------------------------------------*/
             /* NEW PRODUCTION  1  MONTH NO RESULTS LIST */
             /*----------------------------------------*/
             IF         COND((&PNO *EQ '2') *OR (&PNO *EQ '3')) +
                          THEN(DO)

             IF         (%SWITCH(X0XXXXXX)) DO
  /*TEST     DLTF       FILE(MBDWP442)   */

             ENDDO
             ELSE       DO

             /*----------------------*/
             /*  LISTS BY PART NUMBER  */
             /*----------------------*/
             IF         COND((&PLSNO *EQ '1') *OR (&PLSNO *EQ '3')) +
                          THEN(DO)

             DLTF       FILE(MBDWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWP42) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(25000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/MBDWP442)) +
                          OUTFILE(HWFILE1/MBDWP42) SRCFILE(FMTSRC) +
                          SRCMBR(MBDS42) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRT) FORMTYPE(K6S1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(MBDR42) PARM(&USER '2' &PHYM &PHYM1 +
                          &PHYM2 &PKAGT)
             DLTOVR     FILE(QPRINT)
   /*TEST    DLTF       FILE(MBDWP42)   */

             ENDDO

             /*--------------------------*/
             /*LIST BY USER */
             /*--------------------------*/
             IF         COND((&PLSNO *EQ '2') *OR (&PLSNO *EQ '3')) +
                          THEN(DO)

             DLTF       FILE(MBDWP43)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWP43) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(25000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/MBDWP442)) +
                          OUTFILE(HWFILE1/MBDWP43) SRCFILE(FMTSRC) +
                          SRCMBR(MBDS43) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRT) FORMTYPE(K6S1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(MBDR43) PARM(&USER '2' &PHYM &PHYM1 +
                          &PHYM2 &PKAGT)
             DLTOVR     FILE(QPRINT)
   /*TEST    DLTF       FILE(MBDWP43)   */

             ENDDO

   /*TEST    DLTF       FILE(MBDWP442)  */
             ENDDO
             ENDDO

 END:        ENDPGM
