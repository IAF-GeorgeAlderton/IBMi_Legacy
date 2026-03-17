/* JCMC30 *******************************************************************/
/*  FORD CHANGE ASN (CANCEL)                                                */
/*  J.WATANABE 2022.06.16                                                   */
/****************************************************************************/
            PGM

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ASN )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&NO  )  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

         /****** TEMP *********/
             CALL UTLC99B (' ')
             GOTO ENDP
         /*********************/


/* JW2 CHECK OTHER USER IS USING  ==================================*/
    /*       CALL CHKC45 ('JCMC30' 'JCMC30' 'Y'  'CHK' &RTN1)   */
    /*       IF         COND(&RTN1 *NE ' ') THEN(GOTO ENDP)     */
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             /* PREPARE ASN DATA IN QTEMP */
             DLTF       FILE(QTEMP/EB#EP66)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(EB#EP66) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/EB#EP66)

             DLTF       FILE(QTEMP/EB#EL66)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(EB#EL66) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/EB#EP63)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(EB#EP63) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/EB#EP63)

             DLTF       FILE(QTEMP/EB#EP64)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(EB#EP64) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/EB#EP64)

             DLTF       FILE(QTEMP/EB#EP65)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(EB#EP65) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/EB#EP65)

             /* BEFORE RUN JCMR30, UPDATE J-COM FILE (JCMPP11/12) */
             CALL       PGM(JCMC10) PARM(' ')
             CLRPFM     FILE(*LIBL/JCMWP11)
             CLRPFM     FILE(*LIBL/JCMWP12)

             OVRDBF     FILE(EB#EP66) TOFILE(QTEMP/EB#EP66)
             OVRDBF     FILE(EB#EL66) TOFILE(QTEMP/EB#EL66)
             OVRDBF     FILE(EB#EP63) TOFILE(QTEMP/EB#EP63)
             OVRDBF     FILE(EB#EP64) TOFILE(QTEMP/EB#EP64)
             OVRDBF     FILE(EB#EP65) TOFILE(QTEMP/EB#EP65)

             CALL       PGM(JCMR30) PARM(&RTN)

             IF         COND(&RTN *EQ ' ') THEN(DO)
             DLTOVR     FILE(*ALL)
             CPYF       FROMFILE(QTEMP/EB#EP63) +
                          TOFILE(HFILE1/EB#EP63) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(QTEMP/EB#EP64) TOFILE(HFILE1/EB#EP64) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(QTEMP/EB#EP65) TOFILE(HFILE1/EB#EP65) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(QTEMP/EB#EP66) TOFILE(HFILE1/EB#EP66) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
      /** SUBMIT ASN **/
             CALL       PGM(EJCC01)

             ENDDO
ENDX:
      /***   CALL CHKC45 ('JCMC30' 'JCNC30' 'N'  '' '')  **/

ENDP:
             ENDPGM
