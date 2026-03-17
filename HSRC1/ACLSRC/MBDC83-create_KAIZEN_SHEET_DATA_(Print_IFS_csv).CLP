             PGM        PARM(&GRP &YYMM &RTN)
             /** MBDC83 ****************************/
             /*  CREATE PRINT KAIZEN SHEET DATA    */
             /*  J.WATANABE   2017.11.07           */
             /**************************************/

             DCL        VAR(&GRP)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&YYMM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(*LIBL/MBDWP82)
             CLRPFM     FILE(*LIBL/MBDWP83)

             CALL       PGM(MBDR83) PARM(&GRP &YYMM &RTN)

/* TRANSFER TO CSV */
             CHGVAR     VAR(&FNAM) VALUE('KAIZEN SHEET')
             CALL       PGM(APLC96) PARM('2' 'MBDWP83'  '*LIBL' +
                          &FNAM 'Y' ' ')


             ENDPGM
