  PGM
/** AM#C41 *************************************************/
/*  TOYOTA SHIPPING CONFIRMATION MENU                      */
/*                                                         */
/*  J.WATANABE 02/08/2019                                  */
/***********************************************************/
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCLF       FILE(AM#PW41)

             RTVJOBA    JOB(&WSID) USER(&USR)
 STRT:
             CHGVAR     VAR(&XSLCT) VALUE('00')
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG ) VALUE(' ')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(ENDP))

 /* CHECK */
             IF         COND(&XSLCT *EQ 0 ) THEN(DO)
             CHGVAR     VAR(&XMSG ) VALUE('ENTER SELECTION !')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND(&XSLCT *NE 1 ) THEN(DO)
             CHGVAR     VAR(&XMSG ) VALUE('SELECTION IS NOT AVAILABLE !')
             GOTO       CMDLBL(STRT)
             ENDDO

 /* 1. MISSING PACKING DATA            */
             IF         COND(&XSLCT *EQ 1) THEN(CALL PGM(AM#C40))

             GOTO       STRT
 ENDP:
             ENDPGM
