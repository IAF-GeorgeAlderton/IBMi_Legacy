             PGM
/** KSZC01 ************************************************/
/* ..串刺し表リストの作成..                             */
/*                                                        */
/*          C:M.TAKAGI          2003.02.25                */
/* TCHK1 07/07/09 CREATE(CONVERT ASJ SOURCE)              */
/************************************************ KSZC01 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             DLTF       FILE(QTEMP/KSZWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/KSZWP01) RCDLEN(29) +
                          OPTION(*NOLIST) SIZE(3000 1000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(KSZR01)


             CHKOBJ     OBJ(KSZWP02) OBJTYPE(*FILE) MBR(&USER)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(KSZWP02) +
                          MBR(&USER))
             CLRPFM     FILE(KSZWP02) MBR(&USER)
             OVRDBF     FILE(KSZWP02) TOFILE(KSZWP02) +
                          MBR(&USER)

             CALL       PGM(KSZR02)

    @END:

             ENDPGM
