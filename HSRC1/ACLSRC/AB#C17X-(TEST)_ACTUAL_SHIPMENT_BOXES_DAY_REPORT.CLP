             PGM
             /***AB#C17********************************************/
             /* ACTUAL SHIPMENT                                        -EDP */
             /*         JUN/11/2003  TCH                        */
             /*                                                 */
             /*****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CST) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&DT1) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&DT2) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(AB#WP17) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP17
             OVRDBF     FILE(AB#WP17) TOFILE(QTEMP/AB#WP17)

             CALL       PGM(AB#R17) PARM(&CST &DT1 &DT2 &END)

/***********************/
GOTO @END
/***********************/

             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))
             OVRPRTF    FILE(QPRINT) OUTQ(&PRTG)
             CALL       PGM(AB#R18) PARM(&CST &DT1 &DT2)


  @END:

             ENDPGM
