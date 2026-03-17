 /** AB#C1L ****************************************************/
 /*  (HONDA) GENERATE CONSOLIDATED PACKING LIST                */
 /*                                                            */
 /* J.W.  2017.01.31                                           */
 /*                                                            */
 /**************************************************************/
             PGM
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AC#R01)

             ENDPGM
