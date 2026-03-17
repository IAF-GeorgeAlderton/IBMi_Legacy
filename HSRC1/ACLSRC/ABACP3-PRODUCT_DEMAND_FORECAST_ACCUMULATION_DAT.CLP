             PGM
             /** ABACP3 ******************************************/
             /*PRODUCT DEMAND FORECAST ACCUMULATION DATA CREATE  */
             /*   USER KANBAN M/F CREATE                         */
             /*                                                  */
             /* TCHK1 08/11/06 CHG &SLC(NONY CODE)               */
             /* TCHK2 06/12/09 ADD TEMPORARY CHANGE CALENDAR M/F */
             /******************************** ABACP3 ************/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PYMD)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&END)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&SLC)    TYPE(*CHAR) LEN(04)
             DCL        VAR(&RTN)    TYPE(*CHAR) LEN(1)

 /* CHECK GENTRAN */
             CHKOBJ     OBJ(HFILE1/GENABA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(YTP0))
             CALL       PGM(QUILNGTX) PARM('GENTRAN IS WORKING NOW. +
                          PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +
                          YOU. ' X'00000046' '       ' +
                          '                    ' X'00000000')
             GOTO       SEND

 YTP0:
 /* CHECK PROGRAM *****************************************************/
             CALL       PGM(CHKC45) PARM('ABAACT' 'ABACP3' 'Y' 'CHK' &RTN)
             IF         COND(&RTN *NE ' ') THEN(GOTO CMDLBL(SEND))
 /*********************************************************************/

         /*  CALL       PGM(QUILNGTX) PARM('USER KANBAN M/F UPDATE +  */
         /*               IS ACTIVE. PLEASE TRY LATER. (ABACP3)' +    */
         /*               X'00000046' ' ' ' ' X'00000000')            */
         /*  GOTO       SEND                                          */
         /*                                                           */
         /*  CRTDTAARA  DTAARA(HFILE1/ABAACT) TYPE(*CHAR) LEN(10) +   */
         /*               TEXT('DURING USER PROD DEMAND FORECAST +    */
         /*               DATA UPD HANDLING') AUT(*ALL)               */

 YTP1:
             OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&PYMD)
             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ALBC00) PARM(&USR  &WLIB)

             CALL       PGM(ABAR33) PARM(&END &SLC)
             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(ENDP))

             CALL       PGM(ABACP4) PARM(&SLC)

 ENDP:
             CALL       PGM(CHKC45) PARM('ABAACT' 'ABACP3' 'N' '' '')
         /*  DLTDTAARA  DTAARA(HFILE1/ABAACT)    */
         /*  MONMSG     MSGID(CPF2105)           */

 SEND:       CHGJOB     RUNPTY(20)

             ENDPGM
