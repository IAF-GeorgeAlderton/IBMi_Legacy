             PGM
/** GEAC10 *************************************************/
/*  ASJ PT/WASHER FORECAST                                 */
/*                                                         */
/* TCHK  02/25/14 CREATE                                   */
/* JW    02/08/18 ADD IFS TRANSFER                         */
/***********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&YYMM)   TYPE(*CHAR) LEN(06)
             DCL        VAR(&GDGC05) TYPE(*CHAR) LEN(48)
             DCL        VAR(&GYMD)   TYPE(*CHAR) LEN(06)

             RTVJOBA    JOB(&WSID) USER(&USR)

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&YYMM) VALUE(%SST(&ABADS1 1 6))

             RTVDTAARA  DTAARA(GDGC05DT) RTNVAR(&GDGC05)
             CHGVAR     VAR(&GYMD) VALUE(%SST(&GDGC05 1 6))

             CLRPFM     FILE(HWFILE1/GEAWP10)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(HFILE1/GEAPP10)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(GEAR10) PARM(&YYMM &GYMD)

             DLTF       FILE(HWFILE1/GEAWP15)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/GEAWP15) RCDLEN(1100) +
                          TEXT('ASJ PT & WASHER FORECAST') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(GEAWP15) TOFILE(HWFILE1/GEAWP15)

             CALL       PGM(GEAR15) PARM(&YYMM)

    /* JW1 IFS TRANSFER */
             CPYF       FROMFILE(HWFILE/GEAWP15) TOFILE(HWFILE1/FILE1024) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CALL       PGM(APLC94) PARM('1' 'GEAWP15' 'HWFILE1' +
                          'PT FORECAST' 'N' ' ' 'Y')
END:
             DLTOVR     FILE(*ALL)


             ENDPGM
