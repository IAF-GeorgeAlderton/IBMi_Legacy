             PGM        PARM(&FLG &PSIRE)
             /** GDLCE0 *******************************************/
             /*  MATERIAL ORDER DATA CONFIRM PROCESS              */
             /*                                                   */
             /*****************************************************/
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)

             CPYF       FROMFILE(GDLPP01) TOFILE(SAKASITA/GDLPP01) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(BTBPP41) TOFILE(SAKASITA/BTBPP41) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(BTBPP05) TOFILE(SAKASITA/BTBPP05) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             CLRPFM     FILE(GDLWPE0)

          /* GDLPP01 -> GDLWPE0 */
             CALL       PGM(GDLRE0) PARM(&PSIRE &FLG)

          /* BTBPP05 -> GDLWPE0 */
             CALL       PGM(GDLRE2) PARM(&PSIRE &FLG)
          /*BEFORE 1MONTH BTBPP05    */
             CALL       PGM(GDLRF2) PARM(&PSIRE &FLG)

          /* CALC    -> GDLWPE0 */
             CALL       PGM(GDLRE3) PARM(&PSIRE)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          OVRFLW(60) OUTQ(LANPRT03) FORMTYPE(K6H1) +
                          HOLD(*NO) SAVE(*YES)
          /* TEST mode  */
             IF         COND(&FLG *EQ '0') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          OVRFLW(60) OUTQ(SAKASITA) FORMTYPE(K6H1) +
                          HOLD(*YES)
             ENDDO

          /* Print result list */
             CALL       PGM(GDLRE5)

          /* GDLWPE0 -> GDLPP01 */
          /*         -> BTBPP05 */
          /*         -> BTBPP41 */
             IF         COND(&FLG *EQ '1') THEN(DO)
             CALL       PGM(GDLRE8) PARM(&PSIRE &FLG)
             ENDDO

          /* TEST mode  */
             IF         COND(&FLG *EQ '0') THEN(DO)
             DSPSPLF FILE(QPRINT) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3309)
             ENDDO

@END:
ENDPGM
