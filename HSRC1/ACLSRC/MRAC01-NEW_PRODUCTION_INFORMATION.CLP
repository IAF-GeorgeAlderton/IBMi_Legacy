             PGM
             /** MRAC01 **************************************/
             /* NEW PRODUCTION INFORMATION                   */
             /*    TRANCOM ITS.        2012.09.11            */
             /************************************************/
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1SHN1)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&P1SHN2)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&P1SHN3)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1SEKB)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1PRKB)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&MRAWP01)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3)   VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&MRAWP01) VALUE('MRAWP01' *CAT &WS3)
 STP01:
             CALL       PGM(MRAR01) PARM(&P1SHN1 &P1SHN2 &P1SHN3 +
                          &P1SEKB &P1PRKB &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(END))

 STP02:
             DLTF       FILE(HWFILE1/&MRAWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&MRAWP01) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MRAWP01) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRAWP01) TOFILE(HWFILE1/&MRAWP01)
             CALL       PGM(MRAR02) PARM(&P1SHN1 &P1SHN2 &P1SHN3 +
                          &P1SEKB &P1PRKB &PCMD)
         /* PRODUCTION LIST */
             RTVMBRD    FILE(HWFILE1/&MRAWP01) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) ALIGN(*YES) OUTQ(&PRTG) +
                          FORMTYPE(D972) MAXRCDS(*NOMAX) HOLD(*NO) +
                          IGCDTA(&PIGCD)
             OVRDBF     FILE(MRAWP01) TOFILE(HWFILE1/&MRAWP01)
             CALL       PGM(MRAR03)
             ENDDO

             GOTO       CMDLBL(STP01)

 END:
             ENDPGM
