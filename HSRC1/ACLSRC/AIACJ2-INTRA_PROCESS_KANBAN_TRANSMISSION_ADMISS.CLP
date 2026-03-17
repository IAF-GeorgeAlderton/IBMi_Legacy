             PGM
             /** AIACJ2 ************************************/
             /* || INTRA-PROCESS KANBAN TRANSMISSION ADMISSIBLE PGM || */
             /* IT IS JOBQ                               */
             /* I-HASADA                      89.07.07     */
             /************************************ AIACJ2 **/
             DCL        VAR(&FILENM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CHGJOB     RUNPTY(20)

             CHGDTAARA  DTAARA(HFILE1/AIACJOB) VALUE(&JOB)
             CHGDTAARA  DTAARA(HFILE1/AIACUSER) VALUE(&USER)
             CHGDTAARA  DTAARA(HFILE1/AIACNBR) VALUE(&NBR)

             CHGDTAARA  DTAARA(*LDA (1 11)) VALUE('00000  0000')
             CHGDTAARA  DTAARA(*LDA (14 16)) VALUE('0000000000000000')
             CHGDTAARA  DTAARA(*LDA (43 2)) VALUE('00')

 STP1:       CALL       PGM(AIAR21)
             MONMSG     MSGID(RPG9001) EXEC(GOTO CMDLBL(STP1))

             /*------------------------------*/
             /* OVRDBF APPOINTED*/
             /*------------------------------*/
             CHGVAR     VAR(&FILENM) VALUE(%SST(*LDA 31 10))
             OVRDBF     FILE(INPUT) TOFILE(&FILENM)
             CALL       PGM(AIAR22)
             MONMSG     MSGID(RPG9001) EXEC(GOTO CMDLBL(STP1))
             GOTO       STP1

             ENDPGM
