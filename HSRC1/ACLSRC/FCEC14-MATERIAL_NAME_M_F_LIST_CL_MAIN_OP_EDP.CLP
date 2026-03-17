             PGM
             /** FCEC14 *******************************************/
             /*        MATERIAL NAME M/F LIST CL MAIN OP-EDP */
             /*            M-OKUDA        1981.10.09              */
             /******************************************* FCEC14 **/
             DCLF       FILE(FCEPW14)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&YOSI) VALUE('K6S1')
             CHGVAR     VAR(&BSU)  VALUE(1)
             CHGVAR     VAR(&KUBN) VALUE(0)

 STEP1:      SNDRCVF    DEV(&WSID) RCDFMT(FCEPW141)

             IF         (&IN01 = '1') RETURN

             IF         ((&KUBN *NE 1) *AND (&KUBN *NE 2)) DO
                GOTO       CMDLBL(STEP1)
             ENDDO

             IF         (&YOSI = 'K6S1') GOTO STEP2
             IF         (&YOSI = 'K6S2') GOTO STEP2
             IF         (&YOSI = 'K6S3') GOTO STEP2
             GOTO       STEP1

 STEP2:      IF         (&BSU < 1) GOTO STEP1

             IF         (&KUBN *EQ 1) DO
             OVRPRTF    FILE(QPRINT) TOFILE(*FILE) DEVTYPE(&PDEVT) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(&YOSI) COPIES(&BSU) IGCDTA(&PIGCD)
                CALL       PGM(FCER12) PARM(&USER)
                DLTOVR     FILE(QPRINT)
             ENDDO

             ELSE       DO
                DLTF       FILE(FCEWP13)
                MONMSG     MSGID(CPF3261 CPF2105)

                CRTPF      FILE(HWFILE1/FCEWP13) RCDLEN(20) +
                             OPTION(*NOLIST) SIZE(1000) LVLCHK(*NO)

                CALL       PGM(FCER13)

                DLTF       FILE(FCEWP14)
                MONMSG     MSGID(CPF3261 CPF2105)
                CRTPF      FILE(HWFILE1/FCEWP14) RCDLEN(20) +
                             OPTION(*NOLIST) SIZE(1000) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/FCEWP13)) +
                          OUTFILE(HWFILE1/FCEWP14) SRCFILE(FMTSRC) +
                          SRCMBR(FCES13) OPTION(*NOPRT)
                DLTF       FILE(FCEWP13)

             OVRPRTF    FILE(QPRINT) TOFILE(*FILE) DEVTYPE(&PDEVT) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(&YOSI) COPIES(&BSU) IGCDTA(&PIGCD)
                CALL       PGM(FCER14) PARM(&USER)
                DLTOVR     FILE(QPRINT)
                DLTF       FILE(FCEWP14)
             ENDDO

             ENDPGM
