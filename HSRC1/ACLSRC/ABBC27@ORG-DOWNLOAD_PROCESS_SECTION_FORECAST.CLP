             PGM
             /*** ABBC21 *********************************************/
             /*      工程・工場別　集計内示（３ケ月）リスト        */
             /*          H.ITO                1991.07.11             */
             /* TCH62    TCH   DOWN LOAD VERSION OF ABBC21 04/12/05  */
             /* TCHK1 05/09/07 CHG                                   */
             /* TCHK2 02/14/14 ADD SUPPLIER                          */
             /********************************************* ABBC21 ***/
             DCLF       FILE(ABBPW27)
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
/* TCHK2     DCL        VAR(&COUNT) TYPE(*DEC) LEN(1) VALUE(1) */
/* TCHK2 */  DCL        VAR(&COUNT) TYPE(*DEC) LEN(2) VALUE(1)
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
             CHGVAR     VAR(&FILE1) VALUE('ABBWP21' *CAT &WS)
             CHGJOB     RUNPTY(50) SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CLRPFM     FILE(HWFILE1/ABBWP27)
             MONMSG     MSGID(CPF0000)

 @001:       SNDRCVF    DEV(&WSID) RCDFMT(ABBPW271)

/* TCHK1 */  IF         (&IN01 *EQ '1') GOTO @END
/* TCHK1 */  CHGVAR     VAR(&IN99) VALUE('0')
/* TCHK1 */
/* TCHK1 */  IF         (&IN05 *EQ '0') GOTO @001
/* TCHK1 */
 @002:       IF         (&COUNT *EQ 1)           DO
             CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&@KTEI) VALUE('DS ')
             CHGVAR     VAR(&@BMON) VALUE('2222')
             ENDDO
             IF         (&COUNT *EQ 2)           DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('PC ')
             CHGVAR     VAR(&@BMON) VALUE('2222')
             ENDDO
             IF         (&COUNT *EQ 3)           DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('BZ ')
             CHGVAR     VAR(&@BMON) VALUE('2222')
             ENDDO
             IF         (&COUNT *EQ 4)           DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('BZ ')
             CHGVAR     VAR(&@BMON) VALUE('2444')
             ENDDO
             IF         (&COUNT *EQ 5)           DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('BZ ')
             CHGVAR     VAR(&@BMON) VALUE('2777')
             ENDDO
             IF         (&COUNT *EQ 6)           DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('SD ')
             CHGVAR     VAR(&@BMON) VALUE('2255')
             ENDDO
             IF         (&COUNT *EQ 7)           DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('SD ')
             CHGVAR     VAR(&@BMON) VALUE('2111')
             ENDDO
             IF         (&COUNT *EQ 8)           DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('SK ')
             CHGVAR     VAR(&@BMON) VALUE('2888')
             ENDDO
/* TCHK2 S */
             IF         (&COUNT *EQ 9)           DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('CUB')
             CHGVAR     VAR(&@BMON) VALUE('4444')
             ENDDO
             IF         (&COUNT *EQ 10)          DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('HN ')
             CHGVAR     VAR(&@BMON) VALUE('3111')
             ENDDO
             IF         (&COUNT *EQ 11)          DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('HN ')
             CHGVAR     VAR(&@BMON) VALUE('3222')
             ENDDO
             IF         (&COUNT *EQ 12)          DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('SD ')
             CHGVAR     VAR(&@BMON) VALUE('6666')
             ENDDO
             IF         (&COUNT *EQ 13)          DO
             CHGJOB     SWS(XXXXXXX0)
             CHGVAR     VAR(&@KTEI) VALUE('NP ')
             CHGVAR     VAR(&@BMON) VALUE('6666')
             ENDDO
/* TCHK2 E */
/* TCHK1     IF         (&IN01 *EQ '1') GOTO @END */
/* TCHK1     CHGVAR     VAR(&IN99) VALUE('0')     */

/* TCHK1     IF         (&IN05 *EQ '0') GOTO @001 */

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(134) +
                        OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                        AUT(*ALL)

             OVRDBF     FILE(ABBWP21) TOFILE(&FILE1)
             CALL       PGM(ABBR21) PARM(&@KTEI &@BMON &AYM &MYM +
                        &PARM11 &PARM12 &PARM13 &PARM14)

/* TCHK1     IF         (%SWITCH(0XXXXXXX)) DO                         */
/* TCHK1     DLTF       FILE(&FILE1)                                   */
/* TCHK1     CHGVAR     VAR(&IN99) VALUE('1')                          */
/* TCHK1     CHGVAR     VAR(&MSG) VALUE('THERE IS NO PERTINENT DATA.') */
/* TCHK1     GOTO @001                                                 */
/* TCHK1     ENDDO                                                     */

/* TCHK1     OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +  */
/* TCHK1                  132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +   */
/* TCHK1                  OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD) */

/* TCHK1 */  IF         (%SWITCH(1XXXXXXX)) DO
             CALL       PGM(ABBR27) PARM(&@KTEI &@BMON &@KUBN &@TNJU +
                        &MYM &PARM11 &PARM12 &PARM13 &PARM14)
/* TCHK1 */  ENDDO

             DLTF       FILE(&FILE1)

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF2128)

/* TCHK2     IF         (&COUNT *LT 8)           DO */
/* TCHK2 */  IF         (&COUNT *LT 13)          DO
              IF COND(&COUNT *EQ 12) THEN(CHGVAR VAR(&COUNT) VALUE(13))
              IF COND(&COUNT *EQ 11) THEN(CHGVAR VAR(&COUNT) VALUE(12))
              IF COND(&COUNT *EQ 10) THEN(CHGVAR VAR(&COUNT) VALUE(11))
              IF COND(&COUNT *EQ 9) THEN(CHGVAR VAR(&COUNT) VALUE(10))
              IF COND(&COUNT *EQ 8) THEN(CHGVAR VAR(&COUNT) VALUE(9))
              IF COND(&COUNT *EQ 7) THEN(CHGVAR VAR(&COUNT) VALUE(8))
              IF COND(&COUNT *EQ 6) THEN(CHGVAR VAR(&COUNT) VALUE(7))
              IF COND(&COUNT *EQ 5) THEN(CHGVAR VAR(&COUNT) VALUE(6))
              IF COND(&COUNT *EQ 4) THEN(CHGVAR VAR(&COUNT) VALUE(5))
              IF COND(&COUNT *EQ 3) THEN(CHGVAR VAR(&COUNT) VALUE(4))
              IF COND(&COUNT *EQ 2) THEN(CHGVAR VAR(&COUNT) VALUE(3))
              IF COND(&COUNT *EQ 1) THEN(CHGVAR VAR(&COUNT) VALUE(2))
             GOTO @002
             ENDDO

 @END:       CHGJOB     RUNPTY(20)

             ENDPGM
