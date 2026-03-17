             PGM
             /** GDGC11 *******************************************/
             /* ORDER FIXED HANDING / DAYLY ORDER FILE ADD&CHANGE */
             /*   G.B.C                                97/02/18   */
             /******************************************* GDGC11 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)

        /*  MSK 2004.11.10 */
             CHKOBJ     OBJ(&WLIB/GDGWP9Z) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)

             CRTPF      FILE(&WLIB/GDGWP9Z) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)
             ENDDO

             OVRDBF     FILE(GDGWP9X) TOFILE(&WLIB/GDGWP9Z)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QGPL/ASJOUTQ) +
                          FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(GDGR11) PARM(&USER)
             DLTOVR     FILE(QPRINT)

             ENDPGM
