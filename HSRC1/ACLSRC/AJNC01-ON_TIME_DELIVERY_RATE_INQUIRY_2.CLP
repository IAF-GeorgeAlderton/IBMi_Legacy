             PGM        PARM(&PCR1 &PCR2 &PDATA &PFILT &PHH01 &PHH02 +
                          &PHH03 &PHH04 &PHH05 &PHH06)
             /** AJNC01 **********************************************/
             /* ON-TIME DELIVERY RATE INQUIRY                        */
             /*納期遵守率の見える化                                */
             /*    SAKAKI.          2019.10.02                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCR1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCR2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDATA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFILT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PHH01) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PHH02) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PHH03) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PHH04) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PHH05) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PHH06) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AJNWP00) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AJNWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AJNWP03) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PTBOX) TYPE(*DEC) LEN(10 2)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AJNWP00) VALUE('AJNWP00' *CAT &WS3)
             CHGVAR     VAR(&AJNWP01) VALUE('AJNWP01' *CAT &WS3)
             CHGVAR     VAR(&AJNWP03) VALUE('AJNWP03' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CLRPFM     FILE(&AJNWP00)
 STP10:
             OVRDBF     FILE(AJNWP01) TOFILE(&WLIB/&AJNWP01)
             OVRDBF     FILE(AJNWP03) TOFILE(&WLIB/&AJNWP03)
             CALL       PGM(AJNR01) PARM(&PCR1 &PCR2 &PDATA &PFILT +
                          &PHH01 &PHH02 &PHH03 &PHH04 &PHH05 &PHH06)

 #END:       ENDPGM
