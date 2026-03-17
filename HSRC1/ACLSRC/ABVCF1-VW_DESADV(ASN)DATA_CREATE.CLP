             PGM
             /** ABVCF1 ***************************/
             /*  VW DESADV(ASN)DATA CREATE        */
             /*  KIRI                  2015.06.24 */
             /*************************** ABFC70 **/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)     TYPE(*CHAR) LEN(10) +
                                       VALUE('VWASN2    ')
             DCL        VAR(&REC)      TYPE(*DEC)  LEN(10 0)

        /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&SUB) VALUE('VWASN DATA    ' *CAT &USER)
             CHGVAR     VAR(&FNAME) VALUE('VWASN DATA.CSV')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             /*---------------------------------*/
             /*  VW DESADV(ASN)DATA CREATE      */
             /*---------------------------------*/
             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF2105 CPF3261)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(80) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 2000 5) +
                          LVLCHK(*NO)

             OVRDBF     FILE(VWASN2) TOFILE(HWFILE1/&FILE)
             CALL       PGM(ABVRF1) PARM(&TO1)

             RTVMBRD    FILE(HWFILE1/&FILE) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(END))

             CALL       PGM(APLC30) PARM(&TO1 &SUB 'HWFILE1' +
                          'VWASN2' &FNAME)
END:
             ENDPGM
