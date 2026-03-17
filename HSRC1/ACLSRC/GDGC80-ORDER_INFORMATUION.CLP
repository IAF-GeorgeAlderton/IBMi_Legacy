             PGM
             /** GDGC80 ********************************/
             /*  ORDER INFORMATUION                    */
             /*       MSK.KUNIEDA     2000.03.22       */
             /*                                        */
             /* TCHK1 10/08/08 CHG GDGWP80 QTEMP       */
             /******************************** GDGC80 **/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&FIL1)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRENCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSNO)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PENO)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PNO)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PPART)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&TMAIS)  TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&TNOHK)  TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&TMIHK)  TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
       /*              */

             RTVJOBA    JOB(&WS) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&WSID)   VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FIL1)   VALUE(GDGWP80 *CAT &WSID)
        /*               */

STP1:
/* TCHK1     DLTF       FILE(&FIL1)                                 */
/* TCHK1     MONMSG     MSGID(CPF3261 CPF2105)                      */
/* TCHK1     CRTPF      FILE(&WLIB/&FIL1) SRCFILE(HSRC1/ADDSSRC) +  */
/* TCHK1                  SRCMBR(GDGWP80) OPTION(*NOLIST *NOSRC) +  */
/* TCHK1                  SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)  */
/* TCHK1                                                            */
/* TCHK1     OVRDBF     FILE(GDGWP80) TOFILE(&FIL1)                 */
/* TCHK1 */  DLTF       FILE(QTEMP/GDGWP80)
/* TCHK1 */  MONMSG     MSGID(CPF0000)
/* TCHK1 */  CRTDUPOBJ  OBJ(GDGWP80) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
/* TCHK1 */               TOLIB(QTEMP)
/* TCHK1 */  MONMSG     MSGID(CPF0000)
/* TCHK1 */  CLRPFM     FILE(QTEMP/GDGWP80)
/* TCHK1 */  OVRDBF     FILE(GDGWP80) TOFILE(QTEMP/GDGWP80)
             CALL       PGM(GDGR80) PARM(&PRENCD &PSNO &PENO &PNO +
                          &PPART &TMAIS &TNOHK &TMIHK)

             IF         (&PRENCD  *EQ '9')  DO
/* TCHK1     DLTF       FILE(&FIL1) */
/* TCHK1 */  DLTF       FILE(QTEMP/GDGWP80)
             DLTOVR     FILE(*ALL)
             GOTO       END
             ENDDO

/* TCHK1     OVRDBF     FILE(GDGWP80) TOFILE(&FIL1) */
/* TCHK1 */  OVRDBF     FILE(GDGWP80) TOFILE(QTEMP/GDGWP80)
             CALL       PGM(GDGR81) PARM(&PSNO &PENO &PNO &PPART +
                          &PRENCD &TMAIS &TNOHK &TMIHK)

             IF         (&PRENCD  *EQ '1')  GOTO STP1

/* TCHK1     DLTF       FILE(&FIL1) */
/* TCHK1 */  DLTF       FILE(QTEMP/GDGWP80)

             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
