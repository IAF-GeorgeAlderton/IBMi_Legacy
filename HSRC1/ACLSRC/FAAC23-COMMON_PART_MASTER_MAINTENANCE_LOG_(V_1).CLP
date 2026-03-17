             PGM
             /** FAAC23 ******************************************/
             /*  COMMON PART MAINTENANCE LOG                     */
             /*  J.WATANABE  2019.03.07                          */
             /****************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&US2 )  TYPE(*CHAR) LEN(2 )
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)

             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(&WLIB/FAAWP04)
             CLRPFM     FILE(&WLIB/FAAWP05)

/* SET PRINTER */
             CHGVAR     VAR(&US2) VALUE(%SUBSTRING(&USER 1 2))

             IF         COND(&US2 *EQ 'I3') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT50)
             ENDDO

             IF         COND(&US2 *EQ 'I0') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)
             ENDDO

             IF         COND(&USER *EQ 'I0777') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(QDKT)
             ENDDO

             CALL       PGM(FAAR23) PARM(&RTN)

             IF         COND(&RTN  *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&FILE1) VALUE('FAAWP05')
             CHGVAR     VAR(&FNAM ) VALUE('COMMON PART MAINTENANCE LOG')
             CALL       PGM(APLC96) PARM('2' &FILE1   &WLIB +
                          &FNAM 'Y' ' ')
             ENDDO

 END:
             ENDPGM
