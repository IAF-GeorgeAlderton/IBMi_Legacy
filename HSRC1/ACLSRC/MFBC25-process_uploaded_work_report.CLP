             PGM
             /** MFBC25 ************************/
             /* PROCESS UPLOADED WORK REPORT    */
             /*         TCH 11/21/2004 */
             /************************ MFBC25 **/
             DCLF       FILE(MFBPW25)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)


             CHGVAR     VAR(&IN11) VALUE('1')
             CHKOBJ     OBJ(&WLIB/WREPORT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('1')
             ENDDO

 STP0:
             SNDRCVF    RCDFMT(DSP01)
             IF         (&IN01 *EQ '1') GOTO END

             IF         COND(&IN05 *EQ '1' *AND &IN11 *EQ '1') THEN(DO)
             CLRPFM     FILE(&WLIB/MFBWP01)
             CALL       PGM(MFBR25)
             DLTF       FILE(&WLIB/WREPORT)
             ENDDO

 END:        ENDPGM
