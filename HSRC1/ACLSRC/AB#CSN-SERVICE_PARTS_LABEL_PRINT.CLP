             PGM
             /** AB#C2C ***********************************************/
             /*  ..PRINT AGAI LABEL              .                    */
             /*                                                       */
             /*     TCH 2001.01.01                                    */
             /*     TCH 2001.01.22 ADD TMMK                           */
             /*     TCH 2001.02.20 ADD SERVICE PART                   */
             /*     TCH 2001.03.13 ADD ARVIN SANGO                    */
             /*     TCH 2001.03.20 ADD GENERAL FASTNERS,HOLLINGSWORTH */
             /*                                                       */
             /*   TCHK1 2008.01.31 ADD TTC ORDER#='J?????' PROCESS    */
             /*                                   'X?????'            */
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
/* TCHK1 */  DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))
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

/* TCHK1 */  CHKOBJ     OBJ(AB#WP2IQ) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK1 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IQ) +
/* TCHK1 */               MBR(&WKSID))
/* TCHK1 */  CHKOBJ     OBJ(AB#WP2IR) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK1 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IR) +
/* TCHK1 */               MBR(&WKSID))

             CLRPFM     FILE(AB#WP2L) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2H) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2K) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2M) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2I) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2N) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2P) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2T) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2O) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2G) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2E) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2F) MBR(&WKSID)
/* TCHK1 */  CLRPFM     FILE(AB#WP2IQ) MBR(&WKSID)
/* TCHK1 */  CLRPFM     FILE(AB#WP2IR) MBR(&WKSID)

             OVRDBF     FILE(AB#WP2L) TOFILE(AB#WP2L) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2H) TOFILE(AB#WP2H) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2K) TOFILE(AB#WP2K) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2M) TOFILE(AB#WP2M) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2I) TOFILE(AB#WP2I) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2N) TOFILE(AB#WP2N) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2P) TOFILE(AB#WP2P) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2T) TOFILE(AB#WP2T) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2O) TOFILE(AB#WP2O) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2G) TOFILE(AB#WP2G) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2E) TOFILE(AB#WP2E) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2F) TOFILE(AB#WP2F) MBR(&WKSID)
/* TCHK1 */  OVRDBF     FILE(AB#WP2IQ) TOFILE(AB#WP2IQ) MBR(&WKSID)
/* TCHK1 */  OVRDBF     FILE(AB#WP2IR) TOFILE(AB#WP2IR) MBR(&WKSID)

             CALL       PGM(AB#RSN) PARM(&USER &SRVF)

      /*     IF         (&SRVF *EQ '1') DO     */
      /*                DLTF AB#WP2Q           */
      /*     RUNQRY     QRY(QSERVPART)         */
      /*     ENDDO                             */

/* TCHK1 START */
/* TTC(ELK GROVE) */
             IF         (&SRVF *EQ 'T') DO

             RTVMBRD    FILE(AB#WP2I) MBR(&WKSID) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)

             CALL       PGM(AB#R2C5)

             ENDDO

             ENDDO
/* TCHK1 END */
  END:
             ENDPGM
