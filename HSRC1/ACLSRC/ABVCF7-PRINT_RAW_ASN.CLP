             PGM
             /** ABVCF7 ****************************************************/
             /*  PRINT RAW ASN                                             */
             /*  JW    2021.07.01                                          */
             /**************************************************************/
             DCL        VAR(&DCBM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)


             CALL       PGM(UTLR39) PARM(&ENV)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             ENDPGM
