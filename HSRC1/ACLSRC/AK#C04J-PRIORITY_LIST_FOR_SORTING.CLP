             PGM
             /*** AK#C02 ***********************************/
             /*   SORTING PRIORITY LIST                    */
             /*   COPY FROM AK#C01  2018.02.16             */
             /**********************************************/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&AK#WP04) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AK#WP05) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUTQ)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AK#WP04) VALUE('AK#WP04' *CAT &WS3)
             CHGVAR     VAR(&AK#WP05) VALUE('AK#WP05' *CAT &WS3)

             CLRPFM     FILE(HWFILE1/&AK#WP05)

             OVRDBF     FILE(AK#WP04) TOFILE(HWFILE1/&AK#WP04)
             OVRDBF     FILE(AK#WP05) TOFILE(HWFILE1/&AK#WP05)
             CALL       PGM(AK#R05)
 /* STEP4: PRINT OUT    */
             OVRPRTF    FILE(AK#PR06) PAGESIZE(*N 198) LPI(6) +
                          CPI(15) OVRFLW(64) RPLUNPRT(*YES) +
                          OUTQ(WATAOUTQ) FORMTYPE(K6H1) HOLD(*NO)
             OVRDBF     FILE(AK#WP05) TOFILE(HWFILE1/&AK#WP05)
             CALL       PGM(AK#R06)

 END:
             ENDPGM
