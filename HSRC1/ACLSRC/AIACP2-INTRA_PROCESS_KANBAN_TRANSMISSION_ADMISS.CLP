             PGM
             /** AIACP2 ************************************/
             /* || INTRA-PROCESS KANBAN TRANSMISSION ADMISSIBLE PGM || */
             /* I-HASADA                      89.07.07     */
             /************************************ AIACP2 **/
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
             IF         (&IN03 *EQ '1') GOTO STP2
             IF         (&IN05 *EQ '0') GOTO STP2

             CRTDTAARA  DTAARA(AIAACT) TYPE(*CHAR) LEN(10) +
                          TEXT('APICS.PROC KANBAN TRANSMISSION PGM +
                          ACT CHECK')

             SBMJOB     JOB(KOUTEINAI) JOBD(QBATCH) JOBQ(QBATCH) +
                          RQSDTA('CALL PGM(AIACJ2)')

 END:        ENDPGM
