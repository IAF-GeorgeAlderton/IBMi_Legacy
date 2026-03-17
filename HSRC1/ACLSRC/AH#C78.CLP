/* TCHK1 07/15/10 CHG TEMPORARY CHANGE CALENDAR M/F */
/* TCHK2 08/18/14 CHG ABBWP80 --> ABBWP8A           */

             PGM        PARM(&PDAT &CPY &OUTQ)

             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(8)

             DCL        VAR(&FILE01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&PKYM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)

/* TCHK1 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK1 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK1 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6))

/* TCHK2     CHGVAR     VAR(&FILE01)  VALUE('ABBWP80') */
/* TCHK2 */  CHGVAR     VAR(&FILE01)  VALUE('ABBWP8A')

/* UPDATE:K.OKACHI    2002.06.06    %0001 */
             DLTF       FILE(QTEMP/&FILE01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE01) RCDLEN(512) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(OUTPUT1) TOFILE(QTEMP/&FILE01)
/* %0001 */

             CALL       PGM(AH#R78) PARM(&PDAT)
             DLTOVR *ALL
/* UPDATE:K.OKACHI    2002.06.10    %0001 */
             RTVMBRD    FILE(QTEMP/&FILE01) NBRCURRCD(&REC)
             IF (&REC *NE 0) DO
                 FMTDTA     INFILE((QTEMP/&FILE01)) +
                              OUTFILE(QTEMP/&FILE01) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(ABBS80) +
                          OPTION(*NOPRT)
                 CHGVAR     VAR(&FILE02)  VALUE('ABBWP81')
                 DLTF       FILE(QTEMP/&FILE02)
                 MONMSG     MSGID(CPF3261 CPF2105)
                 CRTPF      FILE(QTEMP/&FILE02) RCDLEN(512) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
                 OVRDBF INPUT1 QTEMP/&FILE01
                 OVRDBF OUTPUT1 QTEMP/&FILE02
                 CALL ABBR80
                 DLTOVR *ALL
                 CHGVAR     VAR(&REC)  VALUE(0)
                 RTVMBRD    FILE(QTEMP/&FILE02) NBRCURRCD(&REC)
                 IF (&REC *NE 0) DO
                     FMTDTA     INFILE((QTEMP/&FILE02)) +
                              OUTFILE(QTEMP/&FILE02) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(ABBS81) +
                          OPTION(*NOPRT)
                     OVRDBF INPUT1 QTEMP/&FILE02
                     OVRDBF INPUT2 QTEMP/&FILE01
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&OUTQ) +
                          FORMTYPE(K6H1) COPIES(&CPY)
/* TCHK1             CALL ABBR81 PARM(&PKYM) */
/* TCHK1 */          CALL ABBR81 PARM(&PKYM &PDAT)

                     DLTOVR *ALL
                 ENDDO
             ENDDO
/* %0001 */

             ENDPGM
