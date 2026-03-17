             /** RDBC001  ******************************/
             /*   BATCH JOB CONTROL                    */
             /*                                        */
             /*   LEC CREATE               2024.01.19  */
             /*                                        */
             /*                                        */
             /******************************************/

             PGM        PARM(&JOBNAM &PGMNAM &JOBQ)

             DCL        VAR(&JOBNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGMNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBQ)   TYPE(*CHAR) LEN(10)

             CHGJOB     RUNPTY(20)

        /*--------------------------------------------*/
        /*  CHECK THAT PROGRAM OBJECT EXISTS          */
        /*--------------------------------------------*/
             CHKOBJ     OBJ(&PGMNAM) OBJTYPE(*PGM)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(##END))

        /*--------------------------------------------*/
        /*  CHECK THAT JOBQ EXISTS                    */
        /*--------------------------------------------*/
             CHKOBJ     OBJ(&JOBQ) OBJTYPE(*JOBQ)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(##END))

        /*--------------------------------------------*/
        /*  SUBMIT JOB FOR IAF JOB SCHEDULER          */
        /*--------------------------------------------*/

             SBMJOB     CMD(CALL PGM(&PGMNAM)) JOB(&JOBNAM) JOBQ(&JOBQ)


 ##END:      ENDPGM
