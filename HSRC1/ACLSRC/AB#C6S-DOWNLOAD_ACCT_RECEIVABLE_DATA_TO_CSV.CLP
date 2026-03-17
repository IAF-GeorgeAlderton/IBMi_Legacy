             PGM        PARM(&CUST &DATE &TIME)
             /* AB#C6S ********************************************/
             /* DOWNLOAD ACCT RECEIVABLE DATA TO CSV              */
             /* J.W      2021.11.16                               */
             /*****************************************************/
             DCL        VAR(&CUST)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&DATE)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIME)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(HWFILE1/AB#WP6A)

             OVRDBF     FILE(AB#WP6A) TOFILE(*LIBL/AB#WP6A)

             CALL       PGM(AB#R6S) PARM(&CUST &DATE &TIME)

             CHGVAR     VAR(&FNAM) VALUE(&CUST *BCAT 'ACCT RECEIVABLE')
             CALL       PGM(APLC94) PARM('2' 'AB#WP6A' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDPGM
