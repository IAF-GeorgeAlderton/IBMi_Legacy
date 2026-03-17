 PGM
/** AAFC49 ************************************************/
/* CREATE PRODUCTION ORDER BOOK(SIMPLE)                   */
/*                                                        */
/* TCHK1  : 11/10/05 CREATE(copy from AAFC47)             */
/* TCHK2  : 02/23/07 CHG PRINT SPEC(ADD BARCODE)          */
/* TCHK3  : 06/17/10 CHG DEFAULT PRINTER                  */
/* T.SAKAKI 05/28/15 CHG DEFAULT PRINTER    %0001         */
/************************************************ AAFC49 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NO) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

/* TCHK3     CHGVAR     VAR(&PRTG) VALUE('QPRINTC') */
/* TCHK3 */  CHGVAR     VAR(&PRTG) VALUE('QPRINTB')
/* %0001 */  CHGVAR     VAR(&PRTG) VALUE('QPRINT')
             CHGVAR     VAR(&PDEVT) VALUE('*SCS  ')


             CHGJOB     SWS(00000000)

             DLTF       FILE(QTEMP/AAFWP49)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(QTEMP/AAFWP49) RCDLEN(12) +
                          OPTION(*NOLIST) SIZE(5000 2000) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AAFWP49) TOFILE(QTEMP/AAFWP49)

             CALL       PGM(AAFR49)

             IF         (%SWITCH(0XXXXXXX)) DO
                        DLTF       FILE(QTEMP/AAFWP49)
                        GOTO       END
             ENDDO

/* TCHK2     OVRPRTF    FILE(QPRINTS) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) ALIGN(*YES) OUTQ(&PRTG) +
                          FORMTYPE(@972) MAXRCDS(*NOMAX) IGCDTA(&PIGCD) */

             OVRPRTF    FILE(AAFPR50) DEVTYPE(*AFPDS) PAGRTT(*AUTO) +
                          OUTQ(SAKASITA)

             CALL       PGM(AAFR50)

/* TCHK2     DLTOVR     FILE(QPRINTS) */
/* TCHK2 */  DLTOVR     FILE(AAFPR50)

             DLTF       FILE(QTEMP/AAFWP49)

 END:
             ENDPGM
