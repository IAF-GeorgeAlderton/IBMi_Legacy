             PGM        PARM(&PL# &SERL)
             /** AE#C01 ***********************************************/
             /*  PRINT CONTTAINER/MASTER/MIXED LABELS FOR TBA(3324)   */
             /*  J.WATANABE   2022.03.16                              */
             /*********************************************************/
             DCL        VAR(&PL# )   TYPE(*CHAR) LEN(9)
             DCL        VAR(&SERL)   TYPE(*CHAR) LEN(18)
             DCL        VAR(&WKS3)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WKS3) VALUE(%SUBSTRING(&WSID 1 3))

             CHKOBJ     OBJ(AE#WP01C) OBJTYPE(*FILE) MBR(&WKS3)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AE#WP01C) MBR(&WKS3))

             CHKOBJ     OBJ(AE#WP01M) OBJTYPE(*FILE) MBR(&WKS3)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AE#WP01M) MBR(&WKS3))

             CHKOBJ     OBJ(AE#WP01I) OBJTYPE(*FILE) MBR(&WKS3)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AE#WP01I) MBR(&WKS3))


             CLRPFM     FILE(AE#WP01C) MBR(&WKS3)
             CLRPFM     FILE(AE#WP01M) MBR(&WKS3)
             CLRPFM     FILE(AE#WP01I) MBR(&WKS3)

             OVRDBF     FILE(AE#WP01C) TOFILE(AE#WP01C) MBR(&WKS3)
             OVRDBF     FILE(AE#WP01M) TOFILE(AE#WP01M) MBR(&WKS3)
             OVRDBF     FILE(AE#WP01I) TOFILE(AE#WP01I) MBR(&WKS3)

             CALL       PGM(AE#R01) PARM(&PL# &SERL)

             DLTOVR     FILE(*ALL)

             ENDPGM
