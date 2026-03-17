             PGM
             /** FAAC24 ******************************************/
             /*  COMMON PART MAINTENANCE LOG                     */
             /*  J.WATANABE  2019.03.07                          */
             /****************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&US2 )  TYPE(*CHAR) LEN(2 )
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)

             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

    /******  CLRPFM     FILE(&WLIB/FAAWP04)  ******/
             DLTF       FILE(QTEMP/FAAWP04)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(FAAWP04) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/FAAWP04)
             OVRDBF     FILE(FAAWP04) TOFILE(QTEMP/FAAWP04)

    /******  CLRPFM     FILE(&WLIB/FAAWP05)  ******/
             DLTF       FILE(QTEMP/FAAWP05)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(FAAWP05) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/FAAWP05)
             OVRDBF     FILE(FAAWP05) TOFILE(QTEMP/FAAWP05)

/* SET PRINTER */
             CHGVAR     VAR(&US2) VALUE(%SUBSTRING(&USER 1 2))
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)

             IF         COND(&US2 *EQ 'I3') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT50)
             ENDDO

             IF         COND(&USER *EQ 'I0777') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(QDKT)
             ENDDO

             CALL       PGM(FAAR24) PARM(&RTN)

             IF         COND(&RTN  *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&FILE1) VALUE('FAAWP05')
             CHGVAR     VAR(&FNAM ) VALUE('COMMON PART MAINTENANCE LOG')
             CALL       PGM(APLC96) PARM('2' &FILE1  'QTEMP' &FNAM 'Y' ' ')
             ENDDO

 END:
             ENDPGM
