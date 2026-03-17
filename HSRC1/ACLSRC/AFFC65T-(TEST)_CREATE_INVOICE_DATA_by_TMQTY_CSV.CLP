             PGM        PARM(&RTN)
             /*** AFFC65 ************************************/
             /*   CREATE INVOICE DATA BY TMQTY,CSV          */
             /*   JW (SRA)    2024.03.21                    */
             /***********************************************/

             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

             RUNQRY     QRY(HOBJ1/AFFWP62Q)

             CLRPFM     FILE(TWFILE1/ABWEP70)
             CLRPFM     FILE(TWFILE1/ABWEP71)

             OVRDBF     FILE(AFFWP62) TOFILE(HWFILE1/AFFWP62)
             OVRDBF     FILE(ABWEP70) TOFILE(TWFILE1/ABWEP70)
             OVRDBF     FILE(ABWEP71) TOFILE(TWFILE1/ABWEP71)
             OVRDBF     FILE(ABWEL71) TOFILE(TWFILE1/ABWEL71)

             CALL       PGM(AFFR65) PARM(&RTN)

/*** TEMP ***************************************************/
/***         GOTO ENDP                                     **/
/************************************************************/

             IF         COND(&RTN = '*') THEN(DO)
             SNDPGMMSG  MSG('Job was cancelled with no invoice data!')
             GOTO       ENDP
             ENDDO

 @LOOP:
             ALCOBJ     OBJ((HFILE1/AB#EP70 *FILE *EXCLRD)) WAIT(3)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@LOOP))

/* MOVE ABWEP70 TO AB#EP70 (AVOID DUPLICATE HEADER) */
             CALL       AB#R0GM

/* MOVE ABWEP70 TO AB#EP70 (AVOID DUPLICATE HEADER) */
             CPYF       FROMFILE(HWFILE1/ABWEP71) +
                          TOFILE(HFILE1/AB#EP71) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             DLCOBJ     OBJ((HFILE1/AB#EP70 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

/* SAVE AB#EP70 --> EP70S */
/* SAVE AB#EP71 --> EP71S */
             CALL       PGM(EDSR72)

             CPYF       FROMFILE(HWFILE1/ABWEP70) +
                          TOFILE(HWFILE1/ABWEP70SV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             CPYF       FROMFILE(HWFILE1/ABWEP71) +
                          TOFILE(HWFILE1/ABWEP71SV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             CPYF       FROMFILE(HWFILE1/AFFWP62) +
                          TOFILE(HWFILE1/AFFWP62S ) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             SNDPGMMSG  MSG('Invoice data has been created..')

 ENDP:
             ENDPGM
