             /** IAFC10 ********************************/
             /*   BATCH JOB CONTROL                    */
             /*                                        */
             /*   LEC CREATE               2023.06.14  */
             /*   LEC ADD JOB SCHEDULE     2024.01.19  */
             /*                                        */
             /*                                        */
             /*  THIS JOB IS SUBMITTED BY EJKC00       */
             /*                                        */
             /******************************************/

             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&OBJL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SECS) TYPE(*DEC) LEN(3 0) VALUE(60)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)
             CHGJOB     RUNPTY(20)

             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

        /*--------------------------------------------*/
        /*  CHANGE ENVIRONMENT IF TEST USER USES      */
        /*--------------------------------------------*/
             CALL       PGM(ALBC02) PARM(&USER &OBJL)

        /*--------------------------------------------*/
        /*  CLEAR JOB SCHEDULE FILE AND REGENERATE    */
        /*--------------------------------------------*/
             CLRPFM     FILE(RDBPPSC)
             MONMSG     MSGID(CPF0000)

        /*--------------------------------------------*/
        /*  CLEAR LOG FILE                            */
        /*--------------------------------------------*/
             CLRPFM     FILE(RDBPPLG)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(RDBR002)


 @STP1:      DLYJOB     DLY(&SECS)

       /*-------------------------------------------*/
       /* CHECK JOB SCHEDULE AND RUN JOBS WHEN TIME */
       /*-------------------------------------------*/
             CALL       PGM(RDBR001) PARM(&SECS)

             GOTO       CMDLBL(@STP1)
@END:
             ENDPGM
