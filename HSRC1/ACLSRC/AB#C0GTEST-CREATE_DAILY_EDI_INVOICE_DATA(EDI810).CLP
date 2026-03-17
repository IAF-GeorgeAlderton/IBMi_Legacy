             PGM
             /** AB#C7X **********************************************/
             /*  CREATE DAILY EDI INVOICE DATA FOR TOYOTA            */
             /*    H.AMANO       APR/17/02                           */
             /*                                                      */
             /*                                                      */
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
/* TCHK1     CRTPF      FILE(QTEMP/AB#WP621) RCDLEN(128) + */
/* TCHK1 */  CRTPF      FILE(QTEMP/AB#WP621) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)
             CLRPFM     FILE(QTEMP/AB#WP621)

             OVRDBF     FILE(AB#WP621) TOFILE(QTEMP/AB#WP621)
     /*      OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) HOLD(*YES) */

             CALL       PGM(TOBJ1/AB#R0HR) PARM(&PNONY &PEND)

             IF         COND(&PEND *EQ '1') THEN(GOTO CMDLBL(END))

             DLTF       FILE(QTEMP/AB#WP65)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK1     CRTPF      FILE(QTEMP/AB#WP65) RCDLEN(128) + */
/* TCHK1 */  CRTPF      FILE(QTEMP/AB#WP65) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)
             CLRPFM     FILE(QTEMP/AB#WP65)

             FMTDTA     INFILE((QTEMP/AB#WP621)) +
                          OUTFILE(QTEMP/AB#WP65) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S0G) +
                          OPTION(*NOPRT)

 @LOOP:
             ALCOBJ     OBJ((TFILE1/AB#EP70 *FILE *EXCLRD)) WAIT(3)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@LOOP))

             CLRPFM     FILE(TFILE1/AB#EP70)
             CLRPFM     FILE(TFILE1/AB#EP71)
             CLRPFM     FILE(TFILE1/AB#EP73)
             CLRPFM     FILE(TFILE1/AB#EP74)

             OVRDBF     FILE(AB#EL70) TOFILE(TFILE1/AB#EL70)
             OVRDBF     FILE(AB#EL71) TOFILE(TFILE1/AB#EL71)
             OVRDBF     FILE(AB#EP71) TOFILE(TFILE1/AB#EP71)
             OVRDBF     FILE(AB#EL73) TOFILE(TFILE1/AB#EL73)
             OVRDBF     FILE(AB#EL74) TOFILE(TFILE1/AB#EL74)
             OVRDBF     FILE(AB#EP74) TOFILE(TFILE1/AB#EP74)

             CALL       PGM(HOBJ1/AB#R0G)

             DLTOVR     FILE(*ALL)

       /*    DLTF       FILE(QTEMP/AB#WP621)      */
       /*    MONMSG     MSGID(CPF3261 CPF2105)    */
       /*    DLTF       FILE(QTEMP/AB#WP65)       */
       /*    MONMSG     MSGID(CPF3261 CPF2105)    */
 END:
             DLCOBJ     OBJ((TFILE1/AB#EP70 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

             ENDPGM
