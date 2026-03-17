             PGM
             /*** GADC41 ******************************************/
             /*  UPDATE OF EXTENTED BIN MASTER (FOR SHIPMENT M/F) */
             /*                                                   */
             /*   KIRI              2017.07.11                    */
             /*****************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)     TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     OUTQ(&PRTG)

             OVRDBF     FILE(GADPP11) TOFILE(YAJIMA/GADPP11)
             OVRDBF     FILE(GADPL11) TOFILE(YAJIMA/GADPL11)
             OVRDBF     FILE(GADPP41) TOFILE(YAJIMA/GADPP41)
             OVRDBF     FILE(GADPL41) TOFILE(YAJIMA/GADPL41)
             OVRDBF     FILE(BTMPL20) TOFILE(HFILE1/BTMPL20)
             OVRDBF     FILE(GAHPL30) TOFILE(HFILE1/GAHPL30)
             OVRDBF     FILE(GAHPL35) TOFILE(HFILE1/GAHPL35)
             OVRDBF     FILE(GAHPL37) TOFILE(HFILE1/GAHPL37)

             CALL       GADR41

             DLTOVR     FILE(*ALL)

 END:
             ENDPGM
