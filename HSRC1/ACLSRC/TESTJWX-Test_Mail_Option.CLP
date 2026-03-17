             PGM

             DCL        VAR(&TOEMAIL) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SUBJECT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&BODY)    TYPE(*CHAR) LEN(5000)
             DCL        VAR(&LINE1)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LINE2)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LINE3)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LINE4)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LINE5)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LINE6)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LINE7)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LINE8)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LINE9)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&LINEA)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&CRLF)    TYPE(*CHAR) LEN(1) VALUE(X'25')

             CHGVAR     VAR(&TOEMAIL) VALUE('ﾁｱﾔ.ﾑｱﾎｱﾄｱｲｵ@ｹｱｶｹ.ｳﾅﾃ')
             CHGVAR     VAR(&SUBJECT) VALUE('EDI 997 Rｵﾆﾅﾈﾎ - FORD')
             CHGVAR     VAR(&LINE1) VALUE('EDI(997) MESSAGE - FORD' +
                          *TCAT &CRLF)
             CHGVAR     VAR(&LINE2) VALUE('PARTNER EDI TRANS# ASN#  +
                          ACKNOWLEDGE' *TCAT &CRLF)
             CHGVAR     VAR(&LINE3) VALUE('FORD      856  50856  +
                          139395  ACCEPTED' *TCAT &CRLF)
             CHGVAR     VAR(&LINE4) VALUE('FORD      856  50856  +
                          139395  ACCEPTED' *TCAT &CRLF)
             CHGVAR     VAR(&LINE5) VALUE('FORD      856  50856  +
                          139395  ACCEPTED' *TCAT &CRLF)
             CHGVAR     VAR(&LINE6) VALUE('FORD      856  50856  +
                          139395  ACCEPTED' *TCAT &CRLF)
             CHGVAR     VAR(&LINE7) VALUE('------------------' *TCAT +
                          &CRLF)
             CHGVAR     VAR(&LINE8) VALUE('TOTAL 4')
             CHGVAR     VAR(&BODY) VALUE(&LINE1 *BCAT &LINE2 *BCAT +
                          &LINE3 *BCAT &LINE4 *BCAT &LINE5 *BCAT +
                          &LINE6 *BCAT &LINE7 *BCAT &LINE8)


             SNDSMTPEMM RCP((&TOEMAIL *PRI)) SUBJECT(&SUBJECT) +
                          NOTE(&BODY) CONTENT(*PLAIN)

             ENDPGM
