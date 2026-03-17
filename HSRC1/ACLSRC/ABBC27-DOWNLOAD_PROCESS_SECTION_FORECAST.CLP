             PGM
             /*** ABBC21 *********************************************/
             /* PROCESS/SECTN. FORECAST DOWNLOAD                     */
             /*          H.ITO                1991.07.11             */
             /*                                                      */
             /* TCHK  11/25/14 RE-MAKE                               */
             /* TCHK1 03/17/15 add 4,5,6mm                           */
             /********************************************* ABBC21 ***/
             DCLF       FILE(ABBPW27)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM11) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM12) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM13) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PARM14) TYPE(*CHAR) LEN(3)
/* TCHK1 */  DCL        VAR(&PARM15) TYPE(*CHAR) LEN(3)
/* TCHK1 */  DCL        VAR(&PARM16) TYPE(*CHAR) LEN(3)
/* TCHK1 */  DCL        VAR(&PARM17) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(2) VALUE(1)
             DCL        VAR(&@KTEI) TYPE(*CHAR) LEN(3)
             DCL        VAR(&@BMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&@KUBN) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        VAR(&@TNJU) TYPE(*CHAR) LEN(1) VALUE('K')

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&AYM) VALUE(%SST(&ABADS1 1 6))
             CHGVAR     VAR(&MYM) VALUE(%SST(&MCEDP01 1 6))
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGJOB     RUNPTY(50) SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CLRPFM     FILE(HWFILE1/ABBWP21)
             CLRPFM     FILE(HWFILE1/ABBWP27)
             MONMSG     MSGID(CPF0000)

 @001:       SNDRCVF    DEV(&WSID) RCDFMT(ABBPW271)

             IF         (&IN01 *EQ '1') GOTO @END
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN05 *EQ '0') GOTO @001

/* TCHK1 */  CALL       PGM(ABBR21) PARM(&AYM &MYM +
                        &PARM11 &PARM12 &PARM13 &PARM14 +
                        &PARM15 &PARM16 &PARM17)

             IF         COND(&PARM13 *EQ '000' *OR &PARM14 *EQ '000' +
                          *OR &PARM15 *EQ '000' *OR &PARM16 *EQ +
                          '000' *OR &PARM17 *EQ '000') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NEED TO REGISTER A-PICS +
                          CALENDER TILL N+5 MONTH')
             GOTO       @001
             ENDDO

/* TCHK1 */  IF         (%SWITCH(1XXXXXXX)) DO
             CALL       PGM(ABBR27) PARM(&@KUBN &@TNJU +
                        &MYM &PARM11 &PARM12 &PARM13 &PARM14 +
                        &PARM15 &PARM16 &PARM17)
             ENDDO

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF2128)

 @END:       CHGJOB     RUNPTY(20)

             ENDPGM
