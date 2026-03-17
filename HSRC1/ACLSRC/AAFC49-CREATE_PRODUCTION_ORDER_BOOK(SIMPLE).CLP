 PGM
/** AAFC49 ************************************************/
/* CREATE PRODUCTION ORDER BOOK(SIMPLE)                   */
/*                                                        */
/* TCHK1  : 11/10/05 CREATE(copy from AAFC47)             */
/* TCHK2  : 02/23/07 CHG PRINT SPEC(ADD BARCODE)          */
/* TCHK3  : 06/17/10 CHG DEFAULT PRINTER                  */
/* T.SAKAKI 05/28/15 CHG DEFAULT PRINTER   %0001          */
/* JW1    : 05/24/19 CHG DEFAULT PRINTER TO LANPRT03      */
/* T.SAKAKI 03/02/23 ADD TEST PRINTER      %0002          */
/************************************************ AAFC49 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)

 /* JW1 */   CHGVAR     VAR(&PRTG) VALUE('LANPRT03')

             IF         COND((&USER *EQ 'TEST') *OR (&USER *EQ +
                          'QPGMR') *OR (&USER *EQ 'I0777')) +
                          THEN(DO) /* %0002 */
             CHGVAR     VAR(&PRTG) VALUE('EPRINT1 ')
             ENDDO


             CHGJOB     SWS(00000000)

             DLTF       FILE(QTEMP/AAFWP49)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(QTEMP/AAFWP49) RCDLEN(13) +
                          OPTION(*NOLIST) SIZE(5000 2000) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AAFWP49) TOFILE(QTEMP/AAFWP49)

             CALL       PGM(AAFR49)

             IF         (%SWITCH(0XXXXXXX)) DO
                        DLTF       FILE(QTEMP/AAFWP49)
                        GOTO       END
             ENDDO

             OVRPRTF    FILE(AAFPR50) DEVTYPE(*SCS) PAGESIZE(66 132) +
                          LPI(6) RPLUNPRT(*YES) ALIGN(*YES) +
                          OUTQ(&PRTG) FORMTYPE(@972) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)

             CALL       PGM(AAFR50)

             DLTOVR     FILE(AAFPR50)

             DLTF       FILE(QTEMP/AAFWP49)

 END:
             ENDPGM
