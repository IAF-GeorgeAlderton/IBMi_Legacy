             PGM
             /** AB#C2C# **********************************************/
             /*  TEST AB#R2C#                    .                    */
             /***************************** AB#C2C ********************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SRVF)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)

        /*** CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3)) ***/

             CHGVAR     VAR(&WKSID) VALUE('TST')

             CHGVAR     VAR(&SRVF) VALUE(' ')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(AB#WP2L) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2L) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2H) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2H) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2K) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2K) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2M) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2M) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2I) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2I) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2N) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2N) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2P) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2P) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2T) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2T) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2J) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2J) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2JN) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2JN) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2Z) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2Z) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2O) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2O) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2G) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2G) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2E) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2E) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2F) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2F) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2IA) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IA) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2OA) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2OA) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2Y) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2Y) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2ID) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2ID) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP43) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP43) +
                          MBR(&WKSID))

/* TCHK1 */  CHKOBJ     OBJ(AB#WP2IB) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK1 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IB) +
/* TCHK1 */               MBR(&WKSID))
/* TCHK1 */  CHKOBJ     OBJ(AB#WP2IC) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK1 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IC) +
/* TCHK1 */               MBR(&WKSID))

/* TCHK5 */  CHKOBJ     OBJ(AB#WP2IQ) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK5 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IQ) +
/* TCHK5 */               MBR(&WKSID))
/* TCHK5 */  CHKOBJ     OBJ(AB#WP2IR) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK5 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IR) +
/* TCHK5 */               MBR(&WKSID))

/* JW1   */  CHKOBJ     OBJ(AB#WP2IH) OBJTYPE(*FILE) MBR(&WKSID)
/* JW1   */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IH) +
/* JW1   */               MBR(&WKSID))

/* JW2   */  CHKOBJ     OBJ(AB#WP2IE) OBJTYPE(*FILE) MBR(&WKSID)
/* JW2   */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IE) +
/* JW2   */               MBR(&WKSID))

             CHKOBJ     OBJ(AB#WPGF) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WPGF) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WPFF) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WPFF) +
                          MBR(&WKSID))

             CLRPFM     FILE(AB#WP2L)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2H)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2K)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2M)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2I)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2N)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2P)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2T)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2J)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2JN) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2Z)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2O)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2G)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2E)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2F)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2IA) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2OA) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2Y)  MBR(&WKSID)
             CLRPFM     FILE(AB#WP2ID) MBR(&WKSID)
             CLRPFM     FILE(AB#WP43)  MBR(&WKSID)
/* TCHK1 */  CLRPFM     FILE(AB#WP2IB) MBR(&WKSID)
/* TCHK1 */  CLRPFM     FILE(AB#WP2IC) MBR(&WKSID)
/* TCHK5 */  CLRPFM     FILE(AB#WP2IQ) MBR(&WKSID)
/* TCHK5 */  CLRPFM     FILE(AB#WP2IR) MBR(&WKSID)

/* JW1   */  CLRPFM     FILE(AB#WP2IH) MBR(&WKSID)
/* JW2   */  CLRPFM     FILE(AB#WP2IE) MBR(&WKSID)

             CLRPFM     FILE(AB#WPGF)  MBR(&WKSID)
             CLRPFM     FILE(AB#WPFF)  MBR(&WKSID)

             OVRDBF     FILE(AB#WP2L)  TOFILE(AB#WP2L)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2H)  TOFILE(AB#WP2H)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2K)  TOFILE(AB#WP2K)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2M)  TOFILE(AB#WP2M)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2I)  TOFILE(AB#WP2I)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2N)  TOFILE(AB#WP2N)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2P)  TOFILE(AB#WP2P)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2T)  TOFILE(AB#WP2T)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2J)  TOFILE(AB#WP2J)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2JN) TOFILE(AB#WP2JN) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2Z)  TOFILE(AB#WP2Z)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2O)  TOFILE(AB#WP2O)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2G)  TOFILE(AB#WP2G)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2E)  TOFILE(AB#WP2E)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2F)  TOFILE(AB#WP2F)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2IA) TOFILE(AB#WP2IA) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2OA) TOFILE(AB#WP2OA) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2Y)  TOFILE(AB#WP2Y)  MBR(&WKSID)
             OVRDBF     FILE(AB#WP2ID) TOFILE(AB#WP2ID) MBR(&WKSID)
             OVRDBF     FILE(AB#WP43)  TOFILE(AB#WP43)  MBR(&WKSID)
/* TCHK1 */  OVRDBF     FILE(AB#WP2IB) TOFILE(AB#WP2IB) MBR(&WKSID)
/* TCHK1 */  OVRDBF     FILE(AB#WP2IC) TOFILE(AB#WP2IC) MBR(&WKSID)
/* TCHK5 */  OVRDBF     FILE(AB#WP2IQ) TOFILE(AB#WP2IQ) MBR(&WKSID)
/* TCHK5 */  OVRDBF     FILE(AB#WP2IR) TOFILE(AB#WP2IR) MBR(&WKSID)

/* JW1   */  OVRDBF     FILE(AB#WP2IH) TOFILE(AB#WP2IH) MBR(&WKSID)
/* JW2   */  OVRDBF     FILE(AB#WP2IE) TOFILE(AB#WP2IE) MBR(&WKSID)

             CALL       PGM(AB#R2C#) PARM(&USER &SRVF)

             DLTOVR     FILE(*ALL)

/**********************/
    GOTO ENDP
/**********************/




  ENDP:
             ENDPGM
