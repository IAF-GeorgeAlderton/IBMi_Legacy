             PGM        PARM(&DCBM &RTN)
             /** ABVCF6 ********************************/
             /*  VW DESADV(ASN)DATA CREATE 2 (CALL FROM ABVCF5) */
             /*  T.SAKAKI                   2015.09.10 */
             /******************************** ABVCF6 **/
             DCL        VAR(&DCBM)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DCBMN)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFILE) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WFILE) VALUE('VWASN')

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&DCBMN) VALUE(&DCBM)

             PRTEDIDTA  COMPRF(CNFTP) OUTTYP(*OUTFILE) +
                          OUTFILE(&WFILE) LIBRARY(&WLIB) INOUT(*O) +
                          STRBAT(&DCBMN) ENDBAT(&DCBMN) INT(*YES)

             CHGVAR     VAR(&RTN) VALUE('3')
END:
             ENDPGM
