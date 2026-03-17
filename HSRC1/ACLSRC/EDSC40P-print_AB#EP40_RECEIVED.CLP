             /** EDSC40P************************************/
             /*  PRINT AB#EP40 RECEIVED                    */
             /*  JW    2024.10.23                          */
             /**********************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/** TEMP **/
        /*** CLRPFM     FILE(HFILE1/EDIPP03)                  ****/
        /*** OVRDBF     FILE(AB#EP40) TOFILE(TFILE1/AB#EP40)  ****/

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)

             CALL       PGM(EDSR40P ) PARM((&RTN))

/*** TEMP ****************/
/*** GOTO ENDP        ****/
/*************************/

             IF         (&RTN *NE ' ') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET((*NONE) +
                          (Kaz.Watanabe@iafi.com)) DSTD('** EDI +
                          ORDER RECEIVED **') MSG('** CHECK ! ** +
                          Received EDI ORDER in AB#EP40 +
                          (EDSC40P).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('EDI +
                          ORDER RECEIVED')
             DLTOVR     FILE(PRT132)
             ENDDO

ENDP:        ENDPGM
