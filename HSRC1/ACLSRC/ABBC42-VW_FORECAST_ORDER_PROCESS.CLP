             PGM
             /*** ABBC42 ******************************/
             /* VW FORECAST ORDER PROCESS             */
             /* J.WATANABE  2017.06.16                */
             /*****************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AYM)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WYMD) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PYMD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ERR ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSIGO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BHIZ)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&PYMD)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&SIRE) VALUE('8450')
             CHGVAR     VAR(%SST(&WYMD 3 6)) VALUE(&PYMD)
             CHGVAR     VAR(%SST(&WYMD 1 2)) VALUE('20')
             CHGVAR     VAR(&PSIGO) VALUE('1')
             CHGVAR     VAR(&BHIZ) VALUE(%SST(&ABADS1 1 6))

             CLRPFM     FILE(*LIBL/ABAWP2P)
             CLRPFM     FILE(*LIBL/ABAWP2U)

/* CHECK FORECAST DATA (ABVPP25) */
             CALL       PGM(ABBR42) PARM(&ERR)

             IF         COND(&ERR *EQ 'X') THEN(GOTO CMDLBL(ENDP))

/* CREATE ABAWP2P FROM ABVPP25   */
             CALL       PGM(ABBR43)

/* CREATE ABAWP2U FROM ABVPP2P   */
             CHGVAR     VAR(&AYM) VALUE(%SST(&WYMD 1 6))
             CALL       PGM(ABAR01) PARM(&AYM)
        /*   CALL       PGM(ABBR44) PARM(&SIRE &AYM)    */
             CALL       PGM(ABBR44N) PARM(&SIRE &AYM)

/* UPDATE ABBPP01 FROM ABVPP2U   */
             CALL       PGM(ABBR45) PARM(&PSIGO &AYM &BHIZ)
ENDP:
             ENDPGM
