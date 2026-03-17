             PGM
             /** CHKCU0 ******************************************************/
             /*  SET WRKACTJOB DATA TO CHKWPU1                               */
             /****************************************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CHKWPU0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPU1) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&CHKWPU0) VALUE('CHKWPU0' *CAT &WT)
             CHGVAR     VAR(&CHKWPU1) VALUE('CHKWPU1' *CAT &WT)

             CHGJOB     OUTQ(QUSRSYS/CMDOUTQ)

             WRKACTJOB  OUTPUT(*PRINT)

  /* %0001 CHECK & DLY WAIT */

             CHKOBJ     OBJ(&CHKWPU0) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(#NXT))

  RCHK:      DLTF       FILE(&CHKWPU0)
             MONMSG     MSGID(CPF3202) EXEC(DO)
             DLYJOB     DLY(10)
             GOTO       RCHK
             ENDDO

  #NXT:      DLTF       FILE(&CHKWPU0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&CHKWPU0) RCDLEN(256) IGCDTA(*YES)
             CPYSPLF    FILE(QPDSPAJB) TOFILE(HWFILE1/&CHKWPU0) +
                          SPLNBR(*LAST)

             DLTF       FILE(HWFILE1/&CHKWPU1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&CHKWPU1) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(CHKWPU1) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(CHKWPU0) TOFILE(HWFILE1/&CHKWPU0)
             OVRDBF     FILE(CHKWPU1) TOFILE(HWFILE1/&CHKWPU1)
             CALL       PGM(CHKRU1)
             DLTOVR     FILE(*ALL)

             ENDPGM
