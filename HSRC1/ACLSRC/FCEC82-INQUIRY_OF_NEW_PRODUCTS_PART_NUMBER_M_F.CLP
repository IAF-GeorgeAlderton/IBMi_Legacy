             PGM
             /*** FCEC82 ******************************/
             /* INQUIRY OF NEW PRODUCTS PART NUMBER M/F */
             /* H.ITO               89.11.07          */
             /****************************** FCEC82 ***/
             DCLF       FILE(FCEPW8A)
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSNO) USER(&USER) DATE(&DATE)

             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHGVAR     VAR(&@DATE) VALUE(&DATE)

             CHGJOB     OUTQ(&PRTG) SWS(00000000)
 @001:       SNDRCVF    DEV(&WSNO) RCDFMT(FCEPW8A1)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

  /*        IF           ((&@TYPE *NE '1') *AND (&@TYPE *NE '2') *AND +
                         (&@TYPE *NE '3')) DO     */
            IF           ((&@TYPE *NE '1') *AND (&@TYPE *NE '2')) DO
              CHGVAR     VAR(&IN11) VALUE('1')
              CHGVAR     VAR(&IN99) VALUE('1')
              CHGVAR     VAR(&@MSG) VALUE('INQUIRY TYPE IS NOT RIGHT')
              GOTO @001
            ENDDO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
            IF (&@TYPE *EQ '1') DO
              CALL PGM(FCER82) /* PART NUMBER ORDER */
              CHGVAR VAR(&@TYPE) VALUE(' ')
              GOTO @001
            ENDDO
            IF (&@TYPE *EQ '2') DO
              CALL PGM(FCER83) /* DATE OF START PRODUCTION ORDER */
              CHGVAR VAR(&@TYPE) VALUE(' ')
              GOTO @001
            ENDDO
    /*      IF (&@TYPE *EQ '3') DO               */
    /*        CALL PGM(FCER84)                   */
                               /* CAR DIE ORDER  */
    /*        CHGVAR VAR(&@TYPE) VALUE(' ')      */
    /*        GOTO @001                          */
    /*      ENDDO                                */

            DLTOVR     FILE(*ALL)
 END:       ENDPGM
