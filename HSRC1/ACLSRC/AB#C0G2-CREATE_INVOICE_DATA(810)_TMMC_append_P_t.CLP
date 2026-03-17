             PGM
             /** AB#C7X **********************************************/
             /*  CREATE DAILY EDI INVOICE DATA FOR TOYOTA            */
             /*    H.AMANO       APR/17/02                           */
             /*                                                      */
             /* TCHK1 10/28/11 CHG TEMP-FILE 128 TO 256              */
             /* JW1   2020.12.01 CHG NOT DELETE AB#WP65              */
             /* JW2   2024.05.07 CHG EDSR70                          */
             /********************************************** AB#C7X **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PEND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)


             DLTF       FILE(QTEMP/AB#WP621)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK1 */  CRTPF      FILE(QTEMP/AB#WP621) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)
             CLRPFM     FILE(QTEMP/AB#WP621)

             OVRDBF     FILE(AB#WP621) TOFILE(QTEMP/AB#WP621)
     /*      OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) HOLD(*YES) */

             CALL       PGM(AB#R0H2) PARM(&PNONY &PEND)

             IF         COND(&PEND *EQ '1') THEN(GOTO CMDLBL(END))

             DLTF       FILE(QTEMP/AB#WP65)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK1 */  CRTPF      FILE(QTEMP/AB#WP65) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)
             CLRPFM     FILE(QTEMP/AB#WP65)

             FMTDTA     INFILE((QTEMP/AB#WP621)) +
                          OUTFILE(QTEMP/AB#WP65) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S0G) +
                          OPTION(*NOPRT)

 @LOOP:
             ALCOBJ     OBJ((AB#EP70 *FILE *EXCLRD)) WAIT(3)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@LOOP))

             CALL AB#R0G

        /* JW1 2016.07.29 ADDED: SAVE AB#EP70/71   */
      /**JW2 CALL       PGM(EDSR70)               **/
             CALL       PGM(EDSR70B) PARM('AB#C0G2')

             DLTOVR     FILE(*ALL)

      /*JW1  DLTF       FILE(QTEMP/AB#WP621)    ************/
      /*JW1  MONMSG     MSGID(CPF3261 CPF2105)  ************/
      /*JW1  DLTF       FILE(QTEMP/AB#WP65)     ************/
      /*JW1  MONMSG     MSGID(CPF3261 CPF2105)  ************/
 END:
             DLCOBJ     OBJ((AB#EP70 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

             ENDPGM
