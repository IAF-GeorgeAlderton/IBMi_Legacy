             PGM        PARM(&NO)

             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)

             DCL        VAR(&NO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)

             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)

             CHGJOB     LOG(*SAME *SAME *SECLVL)

             RTVNETA    SYSNAME(&PSYS)
             RTVJOBA    TYPE(&TYPE)

          /* DLYJOB     DLY(15) */

             CHGVAR     VAR(&FILE) VALUE('APPWP81' *CAT &NO)

             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#PP01) OPTION(*NOLIST *NOSRC)

             CHGPF      FILE(HWFILE1/&FILE) SIZE(9999999 30000 10)

             OVRDBF     FILE(APPWP81) TOFILE(HWFILE1/&FILE)

             IF         COND(&PSYS *EQ 'AFSDR') THEN(DO)
             OVRDBF     FILE(APPPP81) TOFILE(SAKASITA/APPPP81)
             ENDDO
             CALL       PGM(APPR81) PARM(&NO)

         /*  DLTOVR     FILE(APPWP81) */

             DLYJOB     DLY(1)

             CHGVAR     VAR(&JOBN) VALUE('APPC81' *CAT &NO)

             IF         COND(&TYPE *EQ '0') THEN(DO)
             SBMJOB     CMD(CALL PGM(APPC81) PARM(&NO)) JOB(&JOBN) +
                          LOG(*JOBD *JOBD *SECLVL) LOGOUTPUT(*JOBEND)
             GOTO       CMDLBL(@END)
             ENDDO

             CALL PGM(APPC81) PARM(&NO)
@END:
             ENDPGM
