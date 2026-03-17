             PGM        PARM(&PGM &LIBL &FILE &MBR &SRCDATE)
             /** VVVCYA **********************************/
             /* RTVOBJD PGM -> SRCMBR & DATE             */
             /* T.SAKASHITA 2020.12.02                   */
             /*------------------------------------------*/
             /* STRISDB PGM(VVVCYA)                           */
             /* PARM('CAAR50' 'LIBL' 'FILE' 'MBR' 'SRCDATE')  */
             /********************************************/
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)

             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)

             DCL        VAR(&SRCDATE) TYPE(*CHAR) LEN(13)

             CHGVAR     VAR(&FILE) VALUE(' ')
             CHGVAR     VAR(&LIBL) VALUE(' ')
             CHGVAR     VAR(&MBR) VALUE(' ')
             CHGVAR     VAR(&SRCDATE) VALUE(' ')

             RTVOBJD    OBJ(&PGM) OBJTYPE(*PGM) SRCF(&FILE) +
                          SRCFLIB(&LIBL) SRCMBR(&MBR) SRCDATE(&SRCDATE)
             MONMSG     MSGID(CPF9999)

             ENDPGM
