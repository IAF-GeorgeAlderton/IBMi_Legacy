             PGM
             /** CA#C01 ****************************************/
             /*  .INSTRUCTION KANBAN STATUS INQUIRY            */
             /*       T-SAKAKI                2020.08.19       */
             /**************************************** CA#C01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(2)
             RTVJOBA    USER(&USER)

STEP1:
             CALL       PGM(CA#R01) PARM(&USER &CMD)

             IF         COND(&CMD = '01') THEN(GOTO CMDLBL(END))

             IF         COND(&CMD = '07') THEN(DO)
             CALL       PGM(DFAC01)
             CHGVAR     VAR(&CMD) VALUE('  ')
             GOTO       STEP1
             ENDDO
END:
             ENDPGM
