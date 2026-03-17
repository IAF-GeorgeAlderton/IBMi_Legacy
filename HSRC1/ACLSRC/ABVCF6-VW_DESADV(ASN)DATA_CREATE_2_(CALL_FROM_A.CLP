             PGM        PARM(&DCBM &RTN)
             /** ABVCF6 *********************************************/
             /*  VW DESADV(ASN)DATA CREATE 2 (CALL FROM ABVCF5)     */
             /*  T.SAKAKI                   2015.09.10              */
             /*  JW1       2021.07.1 NOT USE &WFILE                 */
             /*******************************************************/
             DCL        VAR(&DCBM)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DCBMN)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB2)    TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID)  USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&DCBMN) VALUE(&DCBM)

             DLTF       FILE(QTEMP/VWASN)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(VWASN) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/VWASN)

             PRTEDIDTA  COMPRF(CNFTP) OUTTYP(*OUTFILE) +
                          OUTFILE(VWASN) LIBRARY(QTEMP) CREATE(*NO) +
                          INOUT(*O) STRBAT(&DCBMN) ENDBAT(&DCBMN) +
                          INT(*YES)

             DSPPFM     FILE(QTEMP/VWASN)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&RTN) VALUE(' ')
END:
             ENDPGM
