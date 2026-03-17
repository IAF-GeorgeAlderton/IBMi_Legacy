  PGM
/** AM#C20 *************************************************/
/*  SCS MENU                                               */
/*  J.WATANABE 2024.06.12                                  */
/***********************************************************/
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCLF       FILE(AM#PW20)

             RTVJOBA    JOB(&WSID) USER(&USR)
 STRT:
             CHGVAR     VAR(&D@SLCT) VALUE('00')
             SNDRCVF    RCDFMT(DSP01)
  /* END */
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN03 *EQ '1') GOTO END
             IF         (&IN12 *EQ '1') GOTO END

  /* ORDER STATUS INQUIRY       */
             IF         COND(&D@SLCT *EQ 1) THEN(CALL PGM(AM#C2F))

  /* SCS TRANSMISSIONS          */
             IF         COND(&D@SLCT *EQ 2) THEN(CALL PGM(AM#C25S))

  /* TSCS WRAPPER SCAN CONFIRMATION */
             IF         COND(&D@SLCT *EQ 3) THEN(CALL PGM(AM#C25W))

  /* TOYOTA SCS PALLET VERIFICATION */
             IF         COND(&D@SLCT *EQ 4) THEN(CALL PGM(AM#C27 ))

  /* TOYOTA ORDER (WEB VS EDI) CONFIRMATION */
             IF         COND(&D@SLCT *EQ 5) THEN(CALL PGM(AB#CBV ))


             GOTO       STRT
 END:
             ENDPGM
