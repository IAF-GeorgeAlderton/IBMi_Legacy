             PGM
             /** SYSC00 **********************************************/
             /*  SYSTEM OPERATION MENU                               */
             /*  JW    2017.12.04                                    */
             /********************************************************/
             DCLF       FILE(SYSPW00)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE(' ')
             CHGVAR     VAR(&IN41) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&XSEL *EQ 0) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('ENTER SELECTION!')
             CHGVAR     VAR(&IN41) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             IF         COND((&XSEL *NE 01) *AND (&XSEL *NE 02) +
                        *AND (&XSEL *NE 03) *AND (&XSEL *NE 04) +
                        *AND (&XSEL *NE 05) *AND (&XSEL *NE 06) +
                        *AND (&XSEL *NE 21)) +
                        THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('SELECTION IS INVALID!')

             CHGVAR     VAR(&IN41) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             IF         COND(&IN05 *NE '1') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PRESS F5 TO RUN, OR F1 TO +
                          END...')
             GOTO       CMDLBL(STP1)
             ENDDO

 /* IF F5:  */
 /* SEL=01 START GENTRAN JOB */
             IF         COND(&XSEL *EQ 01) THEN(CALL SYSC01)

 /* SEL=02 END   GENTRAN JOB */
             IF         COND(&XSEL *EQ 02) THEN(CALL SYSC02)

 /* SEL=03 START B2B     JOB */
             IF         COND(&XSEL *EQ 03) THEN(CALL SYSC03)

 /* SEL=04 END   B2B    JOB */
             IF         COND(&XSEL *EQ 04) THEN(CALL SYSC04)

 /* SEL=05 START EDI_R/S JOB */
             IF         COND(&XSEL *EQ 05) THEN(CALL SYSC05)

 /* SEL=06 END   EDI_R/S JOB */
             IF         COND(&XSEL *EQ 06) THEN(CALL SYSC65)

 /* SEL=21 INITIALIZE TAPE  */
             IF         COND(&XSEL *EQ 21) THEN(CALL SYSC21)

             GOTO       CMDLBL(STP1)

 END:        ENDPGM
