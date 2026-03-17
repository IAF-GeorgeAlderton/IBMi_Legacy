             PGM
             /*** ABBC21 *********************************************/
             /*      工程・工場別　集計内示（３ケ月）リスト        */
             /*          H.ITO                1991.07.11             */
             /*                                                      */
             /* TCHK  11/25/14 RE-MAKE                               */
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

             CALL       PGM(TOBJ1/ABBR21) PARM(&AYM &MYM +
                        &PARM11 &PARM12 &PARM13 &PARM14)

             IF         (%SWITCH(1XXXXXXX)) DO
             CALL       PGM(ABBR27) PARM(&@KUBN &@TNJU +
                        &MYM &PARM11 &PARM12 &PARM13 &PARM14)
             ENDDO

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF2128)

 @END:       CHGJOB     RUNPTY(20)

             ENDPGM
