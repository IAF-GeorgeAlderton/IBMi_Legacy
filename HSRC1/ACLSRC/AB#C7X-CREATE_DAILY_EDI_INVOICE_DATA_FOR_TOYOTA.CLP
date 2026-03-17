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
             CRTPF      FILE(QTEMP/AB#WP621) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)
             CLRPFM     FILE(QTEMP/AB#WP621)

             OVRDBF     FILE(AB#WP621) TOFILE(QTEMP/AB#WP621)
             OVRPRTF    FILE(QPRINT) OUTQ(QPRINTB)

             CALL       PGM(AB#R7X) PARM(&PNONY &PEND)

             IF         COND(&PEND *EQ '1') THEN(GOTO CMDLBL(END))

             DLTF       FILE(QTEMP/AB#WP65)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP65) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)
             CLRPFM     FILE(QTEMP/AB#WP65)

             FMTDTA     INFILE((QTEMP/AB#WP621)) +
                          OUTFILE(QTEMP/AB#WP65) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S65) +
                          OPTION(*NOPRT)

             /*-------------*/
             /*  ..TMMK...  */
             /*-------------*/

             IF         COND(&PNONY *EQ '3347' *OR &PNONY *EQ +
                          '3348') THEN(DO)

             CLRPFM     FILE(EDI810TK)
             OVRDBF     FILE(AB#WP65) TOFILE(QTEMP/AB#WP65)

             CALL       PGM(AB#R74)

             ENDDO

             /*-------------*/
             /*  ..TMMWV..  */
             /*-------------*/

             IF         COND(&PNONY *EQ '3931' *OR &PNONY *EQ +
                          '3932') THEN(DO)

             CLRPFM     FILE(EDI810TW)
             OVRDBF     FILE(AB#WP65) TOFILE(QTEMP/AB#WP65)

             CALL       PGM(AB#R76)

             ENDDO

             /*------------*/
             /*  ..TMMI..  */
             /*------------*/
             IF         COND(&PNONY *EQ '3804' *OR &PNONY *EQ +
                          '3805') THEN(DO)

             CLRPFM     FILE(EDI810TI)
             OVRDBF     FILE(AB#WP65) TOFILE(QTEMP/AB#WP65)

             CALL       PGM(AB#R77)

             ENDDO

             /*------------*/
             /*  ..TMMC..  */
             /*------------*/
             IF         COND(&PNONY *EQ '3503' *OR &PNONY *EQ +
                          '3504') THEN(DO)

             CLRPFM     FILE(EDI810TC)
             OVRDBF     FILE(AB#WP47) TOFILE(QTEMP/AB#WP65)

             CALL       PGM(AB#R47)

             ENDDO

             /*------------*/
             /*  ..NUMMI.  */
             /*------------*/
             IF         COND(&PNONY *EQ '0541' *OR &PNONY *EQ +
                          '0542') THEN(DO)

             CLRPFM     FILE(EDI810TN)
             OVRDBF     FILE(AB#WP47) TOFILE(QTEMP/AB#WP65)

             CALL       PGM(AB#R4E)

             ENDDO

             /*------------*/
             /*  ..TOYOTETSU  */
             /*------------*/
             IF         COND(&PNONY *EQ '3556' *OR &PNONY *EQ +
                          '3550') THEN(DO)

             CLRPFM     FILE(EDI810TY)
             OVRDBF     FILE(AB#WP47) TOFILE(QTEMP/AB#WP65)

             CALL       PGM(AB#R7L) PARM(&PNONY)

             ENDDO
             /*------------*/
             /*  ..TOYOTA ALABAMA */
             /*------------*/
             IF         COND(&PNONY *EQ '3765') THEN(DO)

             CLRPFM     FILE(EDI810TA)
             OVRDBF     FILE(AB#WP47) TOFILE(QTEMP/AB#WP65)

             CALL       PGM(AB#R7M)

             ENDDO

             DLTOVR     FILE(*ALL)

             DLTF       FILE(QTEMP/AB#WP621)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(QTEMP/AB#WP65)
             MONMSG     MSGID(CPF3261 CPF2105)

 END:        ENDPGM
