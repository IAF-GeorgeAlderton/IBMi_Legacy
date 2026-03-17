             PGM
/** GEAC16 *************************************************/
/*  ASJ PT/WASHER FORECAST                                 */
/*                                                         */
/* TCHK  02/25/14 CREATE                                   */
/* JW    02/08/18 ADD IFS TRANSFER                         */
/***********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&YYMM)   TYPE(*CHAR) LEN(06)
             DCL        VAR(&GDGC05) TYPE(*CHAR) LEN(48)
             DCL        VAR(&GYMD)   TYPE(*CHAR) LEN(06)

             RTVJOBA    JOB(&WSID) USER(&USER)
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&YYMM) VALUE(%SST(&ABADS1 1 6))

             RTVDTAARA  DTAARA(GDGC05DT) RTNVAR(&GDGC05)
             CHGVAR     VAR(&GYMD) VALUE(%SST(&GDGC05 1 6))

             CLRPFM     FILE(&PLIB/GEAPP16)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(GEAR16) PARM(&YYMM &GYMD)

             DLTF       FILE(&WLIB/GEAWP16)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(&WLIB/GEAWP16) RCDLEN(1100) +
                          TEXT('ASJ PT & WASHER FORECAST') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(GEAWP16) TOFILE(&WLIB/GEAWP16)

             CALL       PGM(GEAR17) PARM(&YYMM)

    /* JW1 IFS TRANSFER */
             CPYF       FROMFILE(&WLIB/GEAWP16) TOFILE(&WLIB/FILE1024) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             CALL       PGM(APLC94) PARM('1' 'GEAWP16' &WLIB +
                          'PT FORECAST' 'N' ' ' 'Y')
END:
             DLTOVR     FILE(*ALL)


             ENDPGM
