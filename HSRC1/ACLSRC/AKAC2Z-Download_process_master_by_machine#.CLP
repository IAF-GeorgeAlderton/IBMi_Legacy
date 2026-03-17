 PGM

 /** AKAC2Z ***********************************************/
 /*  DOWNLOAD PROCESS MASTER BY MACHINE#                  */
 /*                                                       */
 /* TCHK1 05/12/08 CREATE                                 */
 /*********************************************************/

             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(AKAWP2Z) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AKAWP2Z) +
                          MBR(&WKSID))

             CLRPFM     FILE(AKAWP2Z) MBR(&WKSID)

             OVRDBF     FILE(AKAWP2Z) TOFILE(AKAWP2Z) MBR(&WKSID)

             CALL       PGM(AKAR2Z)

  END:
             ENDPGM
