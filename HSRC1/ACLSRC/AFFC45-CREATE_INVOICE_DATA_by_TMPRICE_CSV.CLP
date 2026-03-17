             PGM        PARM(&RTN)
             /*** AFFC45 ************************************/
             /*   CREATE INVOICE DATA BY TMPRICE.CSV        */
             /*   JW (SRA)    2022.09.06                    */
             /***********************************************/

             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

             RUNQRY     QRY(HOBJ1/AFFWP42 )

             CLRPFM     FILE(HWFILE1/ABWEP70)
             CLRPFM     FILE(HWFILE1/ABWEP71)

             OVRDBF     FILE(AFFWP42) TOFILE(HWFILE1/AFFWP42)
             OVRDBF     FILE(ABWEP70) TOFILE(HWFILE1/ABWEP70)
             OVRDBF     FILE(ABWEP71) TOFILE(HWFILE1/ABWEP71)
             OVRDBF     FILE(ABWEL71) TOFILE(HWFILE1/ABWEL71)

             CALL       PGM(AFFR45) PARM(&RTN)

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
         /** CALL       PGM(EDSR71) **/
/**JW **/    CALL       PGM(EDSR71B) PARM('AFFC45')

/* SAVE ABWEP70/71   */
        /****CALL       PGM(EDSR72)  ***/
/**JW **/    CALL       PGM(EDSR72B) PARM('AFFC45')

             CPYF       FROMFILE(HWFILE1/ABWEP70) +
                          TOFILE(HWFILE1/ABWEP70SV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             CPYF       FROMFILE(HWFILE1/ABWEP71) +
                          TOFILE(HWFILE1/ABWEP71SV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             CPYF       FROMFILE(HWFILE1/AFFWP42) +
                          TOFILE(HWFILE1/AFFWP42S ) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             CLRPFM     FILE(HWFILE1/AFFWP42)

             SNDPGMMSG  MSG('Invoice data has been created..')

 ENDP:
             ENDPGM
