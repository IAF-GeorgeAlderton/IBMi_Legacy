             PGM
             /***IZAC01 ****************************************/
             /* FINISHED MATERIAL KANBAN UPDATE                */
             /*  MSK KUNIEDA                 2000.08.21        */
             /*************************************** IZAC01 ***/
             DCLF       FILE(IZAPW05)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMD1)   TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)   USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

STP01:       SNDRCVF    DEV(&WSID) RCDFMT(IZAPW050)
             CHGVAR     VAR(&@ERR) VALUE('                       +
                                ')
             CHGVAR     VAR(&IN31) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

         /* CMD-1  EXIT */

             IF     (&IN01  *EQ '1')  GOTO END

             IF ((&@NO *NE '1')  *AND (&@NO *NE '2'))   DO
             CHGVAR     VAR(&IN31) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('NO. IS THE FIRST - THE +
                          SECOND')
             GOTO STP01
             ENDDO

             CHGVAR     VAR(&CMD1) VALUE(' ')
             IF     (&@NO  *EQ '1') DO
             CALL       PGM(IZAR05) PARM(&CMD1)
             ENDDO
             IF     (&@NO  *EQ '2') DO
             CALL       PGM(IZBR05) PARM(&CMD1)
             ENDDO

             IF     (&CMD1 *EQ '1') DO
             GOTO END
             ENDDO

             CHGVAR     VAR(&@NO) VALUE(' ')
             GOTO STP01
END:         ENDPGM
