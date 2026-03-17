             PGM
/** ECSC55 ************************************************/
/* ..DIE INVENTORY LIST                                   */
/*     TCH             02.10.01                           */
/* TCHK1 05/09/12 CHG DDM DIRECT                          */
/************************************************ ECSC55 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CHK) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             DLTF       FILE(HWFILE1/ECSWP55)
             MONMSG     MSGID(CPF0000)

             CRTPF      FILE(HWFILE1/ECSWP55) RCDLEN(90)


             CLRPFM     FILE(HWFILE1/ECSWP551)
             OVRDBF     FILE(ECSWP551) TOFILE(HWFILE1/ECSWP551)

             OVRDBF     FILE(GKGPP50) TOFILE(ASJFILE/GKGPP50)

             CALL       PGM(ECSR55@)
             DLTOVR     FILE(*ALL)
  @END:

             ENDPGM
