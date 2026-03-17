             PGM
             /** ECQC10 **********************************/
             /* 6  MONTHS DIE USED RESULTS DATA    */
             /* PROGRAM ID. : ECQC10. <CLP> */
             /* CREATE DATE. : MAR.28,'02.               */
             /* AUTHOR.         : TCH                    */
             /********************************** ECQC10 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CLRPFM     FILE(ECQWP10)
             CALL       PGM(ECQR10)

             ENDPGM
