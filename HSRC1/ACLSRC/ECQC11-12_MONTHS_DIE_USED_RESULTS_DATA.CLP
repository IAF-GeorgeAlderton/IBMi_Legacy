             PGM
             /** ECQC11 **********************************/
             /* 12 MONTHS DIE USED RESULTS DATA          */
             /* PROGRAM ID. : ECQC11. <CLP>              */
             /* CREATE DATE.: JUL.20,'07.                */
             /* AUTHOR.     : TCH                        */
             /********************************** ECQC11 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CLRPFM     FILE(ECQWP11)
             CALL       PGM(ECQR11)

             ENDPGM
