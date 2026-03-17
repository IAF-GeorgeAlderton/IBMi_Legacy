  PGM
/** AB#CTM *************************************************/
/*  TOYOTA MAINTANANCE MENU                                */
/*                                                         */
/* J.WATANABE 08/06/2018                                   */
/* LEC        08/17/2018  CHG TOYOTA TIME MAINT. TO RTE/BIN*/
/************************************** AB#CHN *************/
             DCLF       FILE(AB#PWTM)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)
 STRT:
             CHGVAR     VAR(&#PGM  ) VALUE('AB#CTM')
             CHGVAR     VAR(&D@SLCT) VALUE('00')
             SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(ENDP))

  /* 1.TOYOTA SHIP TO CODE MAINTENANCE                               */
             IF         COND(&D@SLCT *EQ 1) THEN(CALL PGM(FBCR46))

  /* 2.UPLOAD TOYOTA APR                                             */
             IF         COND(&D@SLCT *EQ 2) THEN(CALL PGM(FBCC70))

  /* 3.TOYOTA ROUTE/BIN MAINTENANCE                                  */
             IF         COND(&D@SLCT *EQ 3) THEN(CALL PGM(AB#R8L))

  /* 4.TOYOTA TIME TABLE MAINT - TMMC                                */
             IF         COND(&D@SLCT *EQ 4) THEN(CALL PGM(AB#R4L))

  /* 5.CHECKING TOYOTA EDI DATA                                      */
             IF         COND(&D@SLCT *EQ 5) THEN(CALL PGM(AL#CE0))

  /* 6.CREATE TOYOTA TRUCK SCHEDULE                                  */
             IF         COND(&D@SLCT *EQ 6) THEN(CALL PGM(AL#CG3))

  /* 7.TOYOTA LABEL DATA MAINTENANCE                                 */
             IF         COND(&D@SLCT *EQ 7) THEN(CALL PGM(AB#CA8))

  /* 8.TOYOTA REVISION/COC MAINTENANCE                               */
             IF         COND(&D@SLCT *EQ 8) THEN(CALL PGM(AB#C1G))

  /* 9.TOYOTA NAMC DESTINATION MAINTENANCE                           */
             IF         COND(&D@SLCT *EQ 9) THEN(CALL PGM(AL#R21))

  /*10.UPLOAD WINDOW TIMES FROM LIOS TO TOYOTA TRUCK SCHEDULE        */
             IF         COND(&D@SLCT *EQ 10) THEN(CALL PGM(AFFC15))

  /*11.REVISION/ORIGIN OF COUNTRY                                    */
             IF         COND(&D@SLCT *EQ 11) THEN(CALL PGM(AB#C1G))




  /* 99.TOYOTA MAINTENANCE MENU   */
             IF         COND(&D@SLCT *EQ 99) THEN(CALL PGM(AB#CT1))


             GOTO       STRT
 ENDP:
             ENDPGM
