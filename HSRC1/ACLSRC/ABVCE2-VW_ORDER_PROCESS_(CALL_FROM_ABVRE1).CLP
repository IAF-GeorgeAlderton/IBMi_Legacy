             PGM        PARM(&DCBM &RTN)
             /** ABVCE2 ********************************/
             /*  VW ORDER PROCESS (CALL FROM ABVRE1)   */
             /*  KIRI                       2015.06.25 */
             /******************************** ABVCE2 **/
             DCL        VAR(&DCBM)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&DCBMN)    TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB2) TYPE(*CHAR) LEN(8) +
                          VALUE('TFILE1  ')
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WFILE) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&WFILE) VALUE('VWDELJI' *CAT &WT)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&DCBMN) VALUE(&DCBM)


             PRTEDIDTA  COMPRF(CNFTP) OUTTYP(*OUTFILE) +
                          OUTFILE(&WFILE) LIBRARY(&WLIB) +
                          STRBAT(&DCBMN) ENDBAT(&DCBMN) INT(*YES)
             /*---------------------------------*/
             /*  VW ORDER PROCESS               */
             /*---------------------------------*/

             OVRDBF     FILE(VWDELJIT) TOFILE(&WLIB/&WFILE)
             OVRDBF     FILE(ABVEP20) TOFILE(&WLIB2/ABVEP20)
             CALL       PGM(ABVRE2) PARM(&RTN)


END:
             ENDPGM
