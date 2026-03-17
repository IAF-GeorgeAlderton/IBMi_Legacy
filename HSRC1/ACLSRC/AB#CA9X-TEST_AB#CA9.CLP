PGM
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)
/* A38 */
             CALL UTLR63 ('AAHPP01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AAHPP01)
             MONMSG     MSGID(CPF0000)
             ENDDO

ENDPGM
