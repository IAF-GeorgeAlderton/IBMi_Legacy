             PGM
             /** ATBC30 **************************************/
             /* INTRAL COMPANY SERVICE SCHEDULE APPOINTED    +
                    BY PART NUMBER INVESTIGATION LIST CREATE */
             /*         A-IDOTA           1993.10.13         */
             /************************************** ATBC30 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS) USER(&US)

             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('ATBWP31' *CAT &WT)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CHGJOB     SWS(00000000)

 /* WORK FILE CREATE ATBWP31 */
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/&FILE1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ATBWP31) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000 1000 3) LVLCHK(*NO) AUT(*ALL)
 /* PICKL OUT  DATA   */
             OVRDBF     FILE(ATBWP31) TOFILE(&FILE1)
             CALL       PGM(ATBR31)

             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             DLTF       FILE(&FILE1)
             GOTO       CMDLBL(END)
             ENDDO
 /* MAKING LIST */
       /*    OVRPRTF    FILE(ATBPR31) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD) */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(66) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) IGCDTA(&PIGCD)
    /*                    OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD) */

             CALL       PGM(ATBR32) PARM(&US)

             DLTF       FILE(&FILE1)
 END:        DLTOVR     FILE(*ALL)

             ENDPGM
