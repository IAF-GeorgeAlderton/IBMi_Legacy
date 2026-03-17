             PGM
             /******BBACA1**************************************/
             /*        SALES UNIT PRICE M/F MENU */
             /*           PROGRAM ID. : BBACA1                 */
             /*           CREATE DATE. : JAN.19,'91.           */
             /*           AUTHOR.        : K.NAKAMURA          */
             /*****************************************BBACA1***/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(6)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       CHGJOB     SWS(00000000)
             CHGVAR     VAR(&PARM1) VALUE('      ')

             CALL       PGM(BBARA1) PARM(&PARM1)

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

             CALL       PGM(&PARM1)
             GOTO       STP1

 END:        ENDPGM
