             PGM
             /** UTLC71B ******************************************/
             /*  COPY LATEST SPOOL TO TXT132                      */
             /*  JOE W  : 2023.10.24                              */
             /*****************************************************/
             DCL        VAR(&JOB  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR  ) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)
/* DELAY */
             DLYJOB     DLY(4)

/* WRKSPLF */
             WRKSPLF    SELECT(&USR *ALL *STD PRTEDIDTA) OUTPUT(*PRINT)

             DLTF       FILE(QTEMP/TXT132 )
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(TXT132 ) FROMLIB(HFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/TXT132)

             CPYSPLF    FILE(QPRTSPLF) TOFILE(QTEMP/TXT132) +
                          JOB(&NBR/&USR/&JOB) SPLNBR(*LAST)
             MONMSG     MSGID(CPA0701 CPF3303)

ENDP:        ENDPGM
