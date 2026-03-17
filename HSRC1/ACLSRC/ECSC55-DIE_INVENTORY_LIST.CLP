             PGM
/** ECSC55 ************************************************/
/* ..DIE INVENTORY LIST                                   */
/*     TCH             02.10.01                           */
/* TCHK1 05/09/2012 CHG DDM DIRECT                        */
/* JW1   08/02/2018 CHG USING PROGRAM MESSAGE             */
/************************************************ ECSC55 **/
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

    /* JW1 NEW CHECK PROGRAM  =======================================*/
             CALL       PGM(CHKC45) PARM('ECSC55' 'ECSC55' 'Y' 'CHK' &RTN)
             IF         COND(&RTN *NE ' ') THEN(GOTO CMDLBL(@END))
    /* ==============================================================*/

             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

    /* JW1   CALL       PGM(ECSR56) PARM(&CHK)                       */
    /*       IF         COND(&CHK *EQ '1') THEN(GOTO CMDLBL(@END))   */

             DLTF       FILE(&WLIB/ECSWP55)
             MONMSG     MSGID(CPF0000)

             CRTPF      FILE(&WLIB/ECSWP55) RCDLEN(90) SIZE(99999 5000)

/* TCHK2     DLTF       FILE(QTEMP/GKGDDM) */
/* TCHK2     MONMSG     MSGID(CPF0000)     */
/* TCHK2     CPYF       FROMFILE(HFILE1/GKGDDM) TOFILE(QTEMP/GKGDDM) +
                          CRTFILE(*YES)    */

/* TCHK1 */  CLRPFM     FILE(&WLIB/ECSWP551)
/* TCHK1 */  OVRDBF     FILE(ECSWP551) TOFILE(&WLIB/ECSWP551)

/* TCHK2     OVRDBF     FILE(GKGDDM) TOFILE(QTEMP/GKGDDM) */
/* TCHK3 */  OVRDBF     FILE(GKGPP50) TOFILE(ASJFILE/GKGPP50)

             CALL       PGM(ECSR55)
             DLTOVR     FILE(*ALL)

             /* JW1 ================================================ */
             CALL       PGM(CHKC45) PARM('ECSC55' 'ECSC55' 'N' '' '')

  @END:
             ENDPGM
