  PGM
/** AB#CT1 *************************************************/
/*  TOYOTA MAINTANANCE MENU                                */
/*                                                         */
/* J.WATANABE 06/20/2019                                   */
/************************************** AB#CHN *************/
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCLF       FILE(AB#PWT1)

             RTVJOBA    JOB(&WSID) USER(&USR)
 STRT:
             CHGVAR     VAR(&D@SLCT) VALUE('00')
             SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(ENDP))

  /* 1.TOYOTA SHIP TO CODE MAINTENANCE  */
             IF         COND(&D@SLCT *EQ 1) THEN(CALL PGM(FBCR46))

             GOTO       STRT
 ENDP:
             ENDPGM
