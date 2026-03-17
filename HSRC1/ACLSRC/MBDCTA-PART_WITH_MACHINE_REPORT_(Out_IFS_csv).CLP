         PGM
         /** MBDCTA *****************************************/
         /*  PART WITH MACHINE REPORT                       */
         /*  J.WATANABE    2021.05.17                       */
         /***************************************************/
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(HWFILE1/MBDWPTA)
             CLRPFM     FILE(HWFILE1/MBDWPTB)

             CALL       PGM(MBDRTA)

             CALL       PGM(MBDRTB)

 /* OUTPUT MBDWPTB */
             RTVMBRD    FILE(HWFILE1/MBDWPTB) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CALL       PGM(APLC94) PARM('2' 'MBDWPTB   ' 'HWFILE1' +
                          'PART WITH MACHINE REPORT' 'Y' ' ' 'Y')
             GOTO ENDP
             ENDDO

 ENDP:       ENDPGM
