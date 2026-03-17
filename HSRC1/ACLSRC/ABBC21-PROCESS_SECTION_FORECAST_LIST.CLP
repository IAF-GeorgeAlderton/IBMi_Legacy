             PGM
             /*** ABBC21 *********************************************/
             /*      工程・工場別　集計内示（３ケ月）リスト        */
             /*          H.ITO                1991.07.11             */
             /********************************************* ABBC21 ***/
             DCLF       FILE(ABBPW21)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
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

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&AYM) VALUE(%SST(&ABADS1 1 6))
             CHGVAR     VAR(&MYM) VALUE(%SST(&MCEDP01 1 6))
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE('ABBWP21' *CAT &WS)
             CHGJOB     RUNPTY(50) SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 @001:       SNDRCVF    DEV(&WSID) RCDFMT(ABBPW211)
             IF         (&IN01 *EQ '1') GOTO @END
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN13) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&@KTEI = '   ') DO
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT PROCESS CODE          ')
             GOTO @001
             ENDDO

             IF         (&@BMON = '    ') DO
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT SECTION CODE          ')
             GOTO @001
             ENDDO

             IF         ((&@KUBN *NE 'Y') *AND (&@KUBN *NE 'N')) DO
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DETAILS  IS < Y OR N >      ')
             GOTO @001
             ENDDO

             IF         ((&@TNJU *NE 'S') *AND (&@TNJU *NE 'K')) DO
             CHGVAR     VAR(&IN13) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('WEIGHT IS < S OR K >    ')
             GOTO @001
             ENDDO

             IF         (&IN05 *EQ '0') GOTO @001

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(134) +
                        OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                        AUT(*ALL)

             OVRDBF     FILE(ABBWP21) TOFILE(&FILE1)
/* TCHK2     CALL       PGM(ABBR21) PARM(&@KTEI &@BMON &AYM &MYM + */
/* TCHK2 */  CALL       PGM(ABBR21A) PARM(&@KTEI &@BMON &AYM &MYM +
                        &PARM11 &PARM12 &PARM13 &PARM14)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FILE1)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THERE IS NO PERTINENT DATA.')
             GOTO @001
             ENDDO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(MONTHLY) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES) IGCDTA(&PIGCD)
             CALL       PGM(ABBR22) PARM(&@KTEI &@BMON &@KUBN &@TNJU +
                        &MYM &PARM11 &PARM12 &PARM13 &PARM14)
             DLTF       FILE(&FILE1)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF2128)

 @END:       CHGJOB     RUNPTY(20)

             ENDPGM
