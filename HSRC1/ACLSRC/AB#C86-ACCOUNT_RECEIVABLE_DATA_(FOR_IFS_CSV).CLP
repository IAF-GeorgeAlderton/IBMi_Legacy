             PGM        PARM(&NONY &NKOJ &STAT &FROM &TO)
             /** AB#C86 *************************************/
             /*  ACCOUNT RECEIVABLE DATA (FOR IFS.CSV)      */
             /*  J.WATANABE   2018.10.02                    */
             /*  J.WATANABE   2026.02.26 ADD AB#WP8E        */
             /****************************** AB#C85 *********/
             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&STAT)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&FROM)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO  )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             CHGVAR     VAR(&WLIB) VALUE('HWFILE1 ')

             CLRPFM     FILE(&WLIB/AB#WP8C)
 /*JW*/      CLRPFM     FILE(&WLIB/AB#WP8E)
             CALL       PGM(AB#R8C) PARM(&NONY &NKOJ &STAT &FROM &TO)

 /* TRANSFER WF TO ISF.CSV */
             CALL       PGM(APLC94) PARM('2' 'AB#WP8E' &WLIB 'ACCT +
                          RECEIVABLE DATA' 'Y' ' ' 'Y')

             ENDPGM
