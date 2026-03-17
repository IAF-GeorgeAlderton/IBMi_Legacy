             PGM
             /** AIACP1 ************************************/
             /* || A-PICS TRANSMISSION ADMISSIBLE PGM || */
             /* || INTRA-PROCESS KANBAN TRANSMISSION ADMISSIBLE PGM */
             /* I-HASADA                      89.07.07     */
             /*                                            */
             /* ADD SBMJOB -> CALL AB#C82                  */
             /* ADD         > CALL GADC13                  */
             /************************************ AIACP1 **/
             DCLF       FILE(AIAPW01)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

             CHKOBJ     OBJ(AIAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP2
 STP1:       CHGVAR     VAR(&IN02) VALUE('1')

 STP2:       SNDRCVF    DEV(&WSID) RCDFMT(AIAPW011)

             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&IN11 *EQ '1') DO
             WRKACTJOB

             CHKOBJ     OBJ(AIAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP3))
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP2

 STP3:       CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('0')
             GOTO       STP2
             ENDDO

             IF         (&IN12 *EQ '1') DO
             DLTDTAARA  DTAARA(AIAACT)
             MONMSG     MSGID(CPF2105)

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('0')
             GOTO       STP2
             ENDDO

             IF         (&IN03 *EQ '1') GOTO STP2
             IF         (&IN05 *EQ '0') GOTO STP2

             CHKOBJ     OBJ(AIAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP4))
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP2

 STP4:       CRTDTAARA  DTAARA(AIAACT) TYPE(*CHAR) LEN(10) +
                          TEXT('APICS.PROC KANBAN TRANSMISSION PGM +
                          ACT CHECK')

             SBMJOB     JOB(APICS) JOBD(QBATCH) JOBQ(QBATCH) +
                          RQSDTA('CALL PGM(AIACJ1)')

             SBMJOB     JOB(KOUTEINAI) JOBD(QBATCH) JOBQ(QBATCH) +
                          RQSDTA('CALL PGM(AIACJ2)')

             CALL       PGM(VJBC20)
        /*   SBMJOB     CMD(CALL PGM(AB#C82)) JOB(AB#C82) */
        /*   CALL       PGM(GADC13)  */

 END:        ENDPGM
