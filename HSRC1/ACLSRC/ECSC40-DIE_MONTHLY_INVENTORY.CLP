             PGM
             /** ECSC40 ******************************************/
             /* ..DIE MONTHLY INVENTORY                          */
             /*   TCH    02.09.03                                */
             /*   TCHK1  02/22/06 ADD DOWNLOAD FILE              */
             /****************************************************/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
/* TCHK1 */  DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
/* TCHK1 */  CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGJOB     OUTQ(&PRTG)
/* TCHK1 */
/* TCHK1 */  OVRDBF     FILE(ECSWP40) TOFILE(HWFILE1/ECSWP40)
/* TCHK1 */  CLRPFM     FILE(ECSWP40)
/* TCHK1 */
             CALL       PGM(ECSR40)

             ENDPGM
