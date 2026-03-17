/* AB#C0GN ******************************************************************/
/*  CREATE EDI(810) FROM AB#EP70S/71S                                       */
/*  J.WATANABE 2021.06.09                                                   */
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
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

 /* CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AB#C0GN' 'AB#C0GN' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO ENDP)
 /*==============================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(HWFILE1/ABWEP70)
             CLRPFM     FILE(HWFILE1/ABWEP71)

             OVRDBF     FILE(ABWEP70 ) TOFILE(HWFILE1/ABWEP70)
             OVRDBF     FILE(ABWEL71 ) TOFILE(HWFILE1/ABWEL71 )

             CALL       PGM(AB#R0GN) PARM(&RTN)

             IF         COND(&RTN = '*') THEN(DO)
             SNDPGMMSG  MSG('Job was cancelled with no invoice data!')
             GOTO       ENDP
             ENDDO

 @LOOP:
             ALCOBJ     OBJ((HFILE1/AB#EP70 *FILE *EXCLRD)) WAIT(3)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@LOOP))

             CALL       AB#R0GM

             CPYF       FROMFILE(HWFILE1/ABWEP71) +
                          TOFILE(HFILE1/AB#EP71) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             DLCOBJ     OBJ((HFILE1/AB#EP70 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

/* SAVE AB#EP70/71   */
             CALL       PGM(EDSR72)

             CPYF       FROMFILE(HWFILE1/ABWEP70) +
                          TOFILE(HWFILE1/ABWEP70SV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             CPYF       FROMFILE(HWFILE1/ABWEP71) +
                          TOFILE(HWFILE1/ABWEP71SV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             SNDPGMMSG  MSG('Invoice data has been created..')
ENDP:
             CALL CHKC45 ('AB#C0GN' 'AB#C0GN' 'N'  '' '')

             ENDPGM
