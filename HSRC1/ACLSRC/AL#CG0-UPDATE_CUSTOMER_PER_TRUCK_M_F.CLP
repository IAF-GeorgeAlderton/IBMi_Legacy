             PGM
             /** AL#CG0 ************************/
             /* UPDATE CUSTOMER PER TRUCK M/F  */
             /*   KIRI             2016.08.12  */
             /**********************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&AL#WPC0) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AL#WPC0) VALUE('AL#WPC0' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGJOB     OUTQ(&PRTG)

      /* GET REGISTERED DATA */
             DLTF       FILE(&WLIB/&AL#WPC0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPC0) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AL#WPC0) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPC0) TOFILE(&WLIB/&AL#WPC0)
             CALL       PGM(AL#RC0)

             CALL       PGM(AL#RG0)

             ENDPGM
