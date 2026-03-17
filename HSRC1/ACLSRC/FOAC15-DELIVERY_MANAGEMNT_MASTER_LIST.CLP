             PGM
             /** FOAC15 ********************************/
             /*   DELIVERY MANAGEMNT MASTER LIST     */
             /*    MSK.......           2006.06.30     */
             /**************************** FOAC15 ******/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS1)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&WS2)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOJO)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PPGMN)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&ATCFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATCSRC)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATCWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE01)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE02)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT)      TYPE(*DEC)  LEN(10 0) VALUE(0)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&WS2) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&WS1) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE01) VALUE('FOAWP15' *CAT &WS2)
             CHGVAR     VAR(&FILE02) VALUE('FOAWP16' *CAT &WS2)

             DLTF       FILE(HWFILE1/&FILE01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE01) RCDLEN(50) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(HWFILE1/&FILE02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE02) RCDLEN(50) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

RETRY:
         /*----------------------------------------------------*/
         /*   DELIVERY MANAGEMANT MASTER LIST DATA           */
         /*----------------------------------------------------*/
             OVRDBF     FILE(FOAWP15) TOFILE(HWFILE1/&FILE01)
             CALL       PGM(FOAR15)
             RTVMBRD    FILE(HWFILE1/&FILE01) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(GOTO CMDLBL(END))

             FMTDTA     INFILE((HWFILE1/&FILE01)) +
                          OUTFILE(HWFILE1/&FILE02) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(FOAS15) +
                          OPTION(*NOPRT)

         /*----------------------------------------------------*/
         /* DELIVERY SLIP LIST                                 */
         /*----------------------------------------------------*/
             OVRDBF     FILE(FOAWP16) TOFILE(HWFILE1/&FILE02)
             OVRPRTF    FILE(FOAPR16) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(FOAR16)

END:
             ENDPGM
