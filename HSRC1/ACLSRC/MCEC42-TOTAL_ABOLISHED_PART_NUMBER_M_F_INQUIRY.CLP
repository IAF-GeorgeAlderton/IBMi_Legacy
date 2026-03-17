             PGM
             /*** MCEC42 *************************************/
             /*TOTAL ABOLISHED PART NUMBER M/F INQUIRY */
             /*         H.ITO           90.02.14             */
             /************************************* MCEC42 ***/
             DCLF       FILE(MCEPW42)
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSNO) USER(&USER) DATE(&DATE)
             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)
             CALL       AGAR01 PARM(&WSNO &PDEVT &PIGCD)
             CHGVAR     VAR(&@DATE) VALUE(&DATE)

             CHGJOB     OUTQ(&PRTG) SWS(00000000)
 @001:       SNDRCVF    DEV(&WSNO) RCDFMT(MCEPW421)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

            IF         COND((&@TYPE *NE '1') *AND (&@TYPE *NE '2')) +
                          THEN(DO)
              CHGVAR     VAR(&IN11) VALUE('1')
              CHGVAR     VAR(&IN99) VALUE('1')
              CHGVAR     VAR(&@MSG) VALUE('INQUIRY TYPE ISN')
              GOTO @001
            ENDDO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
            IF (&@TYPE *EQ '1') DO
              CALL PGM(MCER43) /* PART NUMBER ORDER */
              CHGVAR VAR(&@TYPE) VALUE(' ')
              GOTO @001
            ENDDO
            IF (&@TYPE *EQ '2') DO
              CALL PGM(MCER44) /* CHANGE DATE ORDER */
              CHGVAR VAR(&@TYPE) VALUE(' ')
              GOTO @001
            ENDDO

            DLTOVR     FILE(*ALL)
 END:       ENDPGM
