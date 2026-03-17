             PGM        PARM(&MODE &HIN1 &HIN2 &HIN3 &SDAT)
             /***AFAC93 ****************************************/
             /* PURCHASED ORDER ACCUMULATION DATA INQUIRY      */
             /*  ( PRODUCTE)                                   */
             /*  MSK KUNIEDA                 2000.12.12        */
             /* TCHK1 04/24/06 ADD DOWNLOAD FILE(MULTI MENBER) */
             /*************************************** AFAC93 ***/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HIN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDAT) TYPE(*CHAR) LEN(8)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
/* TCHK1 */  DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             RTVJOBA    JOB(&WSID) USER(&USER)
/* TCHK1 */  CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/* TCHK1 */  CHKOBJ     OBJ(AFAWP93) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK1 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AFAWP93) +
                          MBR(&WKSID))
/* TCHK1 */  CLRPFM     FILE(AFAWP93) MBR(&WKSID)
/* TCHK1 */  OVRDBF     FILE(AFAWP93) TOFILE(AFAWP93) MBR(&WKSID)

             CALL       PGM(AFAR93) PARM(&USER +
                                         &MODE +
                                         &HIN1 +
                                         &HIN2 +
                                         &HIN3 +
                                         &SDAT)

             ENDPGM
