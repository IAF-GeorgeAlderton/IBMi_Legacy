             PGM
             /** AB#CO1 ******************************************/
             /*  SALES ORDER LIST (BIN# >= 9)                    */
             /*  J.WATANABE  2019.03.22                          */
             /****************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&US2 )  TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(&WLIB/AB#WPO1)
             CLRPFM     FILE(&WLIB/AB#WPO2)

/* SET PRINTER */
             CHGVAR     VAR(&US2) VALUE(%SUBSTRING(&USER 1 2))

             IF         COND(&US2 *EQ 'I3') THEN(DO)
             CHGVAR     VAR(&PRTG) VALUE('LANPRT50')
             ENDDO

             IF         COND(&US2 *EQ 'I0') THEN(DO)
             CHGVAR     VAR(&PRTG) VALUE('LANPRT03')
             ENDDO

             IF         COND(&USER *EQ 'I0777') THEN(DO)
             CHGVAR     VAR(&PRTG) VALUE('QDKT    ')
             ENDDO

             OVRDBF     FILE(AB#WPO1) TOFILE(&WLIB/AB#WPO1)
             OVRDBF     FILE(AB#WPO2) TOFILE(&WLIB/AB#WPO2)
             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) OUTQ(&PRTG)

             CALL       PGM(AB#RO1) PARM(&RTN)

             IF         COND(&RTN  *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&FILE1) VALUE('AB#WPO2')
             CHGVAR     VAR(&FNAM ) VALUE('SALES ORDER LIST')
             CALL       PGM(APLC96) PARM('2' &FILE1   &WLIB +
                          &FNAM 'Y' ' ')
             ENDDO
 END:
             ENDPGM
