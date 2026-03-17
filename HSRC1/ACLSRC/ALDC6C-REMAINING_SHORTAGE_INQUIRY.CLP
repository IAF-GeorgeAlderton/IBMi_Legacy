             PGM        PARM(&PDATE)
             /** ALDC6A ************************************/
             /* SHORTAGE SUMMARY DATA INQUIRY              */
             /*  KIRI                           2019.03.07 */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDATE)  TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ALDWP6C) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ALDWL6C) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             DLTF       FILE(QTEMP/ALDWL6C)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(QTEMP/ALDWP6C)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(QTEMP/ALDWP6C) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALDWP6C) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1500 3) LVLCHK(*NO) AUT(*ALL)

             CRTLF      FILE(QTEMP/ALDWL6C) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALDWL6C) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ALDR6C) PARM(&PDATE)


 END:        ENDPGM
