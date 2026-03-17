             PGM
             /*** AL#C39 ***********************************/
             /* FIX IAF BIN# AND PALLET#                   */
             /*  ITS.              2015.05.20              */
             /*  JW1   2021.04.21 CHG "EXCLUSIVE CONTROL"  */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AL#WP39) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN1 ) TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AL#C39' 'AL#C39' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO END   )
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AL#WP39) VALUE('AL#WP39' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP00:
      /**JW1 CRTDTAARA  DTAARA(&WLIB/AL#C39ACT) TYPE(*CHAR) LEN(1)     **/
      /**    MONMSG     MSGID(CPF1023) EXEC(DO)                        **/
      /**    CHGVAR     VAR(&MSGTXT) VALUE('SOMEONE ELSE USING THIS +  **/
      /**                 MENU. WAIT A WHILE.(G)')                     **/
      /**    CHGVAR     VAR(&PKINP) VALUE('G    ')                     **/
      /**    CHGVAR     VAR(&PKOUT) VALUE(' ')                         **/
      /**    CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)  **/
      /**    GOTO       CMDLBL(END)                                    **/
      /**    ENDDO                                                     **/
 #STP10:
             DLTF       FILE(&WLIB/&AL#WP39)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP39) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AL#WP39) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WP39) TOFILE(&WLIB/&AL#WP39)
             CALL       PGM(AL#R39)
 #STP20:
             OVRDBF     FILE(AL#WP39) TOFILE(&WLIB/&AL#WP39)
             CALL       PGM(AL#R38) PARM(&PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(#STP99)
             ENDDO
 #STP30:
             CLRPFM     FILE(AL#PP11)
      /* AL#R36 ---> AL#R02(AL#PP11)  */
             CALL       PGM(AL#R36)
 #STP40:
             CALL       PGM(AO#C03)
        /*   GOTO       CMDLBL(#STP10)   */
 #STP99:
      /**JW1 DLTDTAARA  DTAARA(&WLIB/AL#C39ACT)  **/
             CALL CHKC45 ('AL#C39' 'AL#C39' 'N'  '' '')
 END:
             ENDPGM
