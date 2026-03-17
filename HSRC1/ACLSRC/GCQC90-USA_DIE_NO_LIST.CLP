             PGM
             /** GCQC90 *********************/
             /* USA DIE NO LIST           */
             /*                             */
             /* S.YAMAGAMI 1996.01.15 */
             /********************* GCQC90 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYP &PRTG)

             DLTF       FILE(GCQWP90)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCQWP90) RCDLEN(50) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO)
        /* PICK OUT DATA  */
             CALL       PGM(GCQR90)

        /*  PRINTING DATA MAKING */

             DLTF       FILE(GCQWP91)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCQWP91) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO)

             CALL       PGM(GCQR91)

        /* USA DIE NO LIST PUBLICATION */

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          198) LPI(6) CPI(15) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)

             CALL       PGM(GCQR92)

             DLTF       FILE(GCQWP90)
             DLTF       FILE(GCQWP91)
             DLTOVR     FILE(*ALL)

             ENDPGM
