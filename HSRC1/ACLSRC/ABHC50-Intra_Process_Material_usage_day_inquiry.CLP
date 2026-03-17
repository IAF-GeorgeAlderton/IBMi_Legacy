  PGM
/** ABHC50 ************************************************/
/* INTRA PROCESS MATERIAL USAGE/DAY INQUIRY               */
/*                                                        */
/* TCHK1 : 07/28/10 CREATE                                */
/**********************************************************/

             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(ABHWP50) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(ABHWP50) +
                          MBR(&WKSID))

             CLRPFM     FILE(ABHWP50) MBR(&WKSID)

             OVRDBF     FILE(ABHWP50) TOFILE(ABHWP50) MBR(&WKSID)

             CALL       PGM(ABHR50)

  END:
             ENDPGM
