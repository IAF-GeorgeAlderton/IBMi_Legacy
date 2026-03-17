             PGM
             /*** AABC02 *****************************/
             /*        testtest /F LIST            */
             /* t.sakaki            2018.02.13       */
             /***************************** AABC02 ***/
             DCL        VAR(&PSPOL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PER) TYPE(*CHAR) LEN(2)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(SAKAKI) +
                          FORMTYPE(K6H1) EXPDATE(*DAYS) DAYS(7) +
                          IGCDTA(*NO)

             CALL       PGM(AABR02)

             CALL       PGM(AJFCH5) PARM('QPRINT     ' '  ')

             DLTOVR     FILE(QPRINT)
             ENDPGM
