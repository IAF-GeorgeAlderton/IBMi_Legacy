             PGM        PARM(&PER &PMBR &PSRC &PLIB &PTYPE)
             /** AJBC71 ****************************************/
             /*  ..AS/400 IAF ATC<-->AOYAMA SOURCE TRANSFER..  */
             /*  ..SRCMBR.SRCFILE.LIBRARY                      */
             /*    I-HASADA                      2001.04.20    */
             /*    T-SAKAKI    ADD PTYPE         2018.01.18    */
             /**************************************** AJBC71 **/
             DCL        VAR(&PER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(1)

             IF         COND(&PTYPE *EQ 'A') THEN(DO)
             ALCOBJ     OBJ((&PLIB/&PSRC *FILE *SHRUPD &PMBR))
             MONMSG     MSGID(CPF0948 CPF1085) EXEC(DO)
             CHGVAR     VAR(&PER) VALUE('*')
             ENDDO
             ENDDO

             IF         COND(&PTYPE *EQ 'D') THEN(DO)
             DLCOBJ     OBJ((&PLIB/&PSRC *FILE *SHRUPD &PMBR))
             MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
