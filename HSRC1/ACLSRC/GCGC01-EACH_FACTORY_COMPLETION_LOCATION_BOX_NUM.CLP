             PGM
             /** GCGC01 ************************************/
             /* EACH FACTORY COMPLETION LOCATION BOX NUMBER INDICATION */
             /*                     LABEL PUBLICATION      */
             /*        A-IDOTA           1992.03.02        */
             /**************************************GCGC01**/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SNY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WS)
             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('GCGWP01' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('GCGWP02' *CAT &WT)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
 STP1:       MONMSG     MSGID(CPF9999)
             CHGJOB     OUTQ(&PRT)

 /* WORK-FILE.1 MAKING */
             OVRDBF     FILE(GCGWP01) TOFILE(&FILE1)
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) TEXT('W/F +
                          FOR EACH FACTORY SHIP BOX NBR INDICATION +
                          LABEL') OPTION(*NOSRC *NOLIST) SIZE(2000 +
                          1000 3) LVLCHK(*NO) AUT(*ALL)

 /* DATA  PULL OUT .. */
             CALL       PGM(GCGR01) PARM(&SNY)
             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             DLTF       FILE(&FILE1)
             GOTO       CMDLBL(END)
             ENDDO

 /* EXCLUSIVE PART NUMBER M/F MAKING */
             IF         COND(&SNY = 'Y') THEN(DO)
             CLRPFM     FILE(GCENP30)
             CALL       PGM(GCER33)
          /* CALL PGM(GCER34) */
             ENDDO

 /* WORK-FILE.2 MAKING */
             OVRDBF     FILE(GCGWP02) TOFILE(&FILE2)
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(GCGWP02) +
                          TEXT('W/F FOR EACH FACTORY SHIP BOX NBR +
                          INDICATION LABEL') OPTION(*NOLIST *NOSRC) +
                          SIZE(2000 1000 3) LVLCHK(*NO) AUT(*ALL)

 /*CONTENTS FOR LABEL MAKING */
             CALL       PGM(GCGR02)
             IF         COND(%SWITCH(X0XXXXXX)) THEN(DO)
             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE2)
             GOTO       CMDLBL(END)
             ENDDO

 /* LABEL PUBLICATION */
             OVRPRTF    FILE(GCGPR01) DEVTYPE(*AFPDS) LPI(6) +
                          FOLD(*YES) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(D997) /* LOCATION PER DAY +
                          SHIPMENT LABEL */
             MONMSG     MSGID(CPF5004)
             CALL       PGM(GCGR03)

             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
