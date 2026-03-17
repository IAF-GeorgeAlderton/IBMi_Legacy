             PGM
             /*** MCDC90 ******************************************/
             /* MATERIAL RESULT MONTHLY REPORT   SALES OP-EDP */
             /*            TCH            2003.06.10              */
             /*                                                   */
             /*****************************************************/
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&END)   TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CLRPFM     MCDWP98
             CLRPFM     MCDWP99

             CALL       PGM(MCDR90) PARM(&END)
             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

             STRPCO
             MONMSG     MSGID(IWS0000)
             STRPCCMD   PCCMD('C:¥PROGRA‾1¥MICROS‾1¥OFFICE¥EXCEL.EXE +
                          S:¥LIST¥MCDWP98.XLS')

 @END:       ENDPGM
