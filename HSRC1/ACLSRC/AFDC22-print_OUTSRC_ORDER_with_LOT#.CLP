 PGM
/** AFDC22 ************************************************/
/*  PRINT OUTSRC ORDER WITH LOT#                          */
/*                                                        */
/*  JW    : 2018.08.14                                    */
/**********************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(*LIBL/AFDWP22)

        /*   CALL       PGM(AFDR22) PARM(&SUPP &DATE &ZETI)  */
             CALL       PGM(AFDR23)

 ENDPGM
