             PGM        PARM(&INQ &SPLF &JOBNAM &JOBUSR &JOBNBR &SPLNB)
             /** AGGC02 **************************/
             /*  ..自動ＳＮＤＮＥＴＳＰＬＦ..  */
             /*     I-HASADA      2000.12.11     */
             /************************** AGGC02 **/
             DCL        VAR(&INQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPLF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNAM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBUSR) TYPE(*CHAR) LEN(5)
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SPLNBR) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&SPLNB) TYPE(*CHAR) LEN(4)

             CHGVAR     VAR(&SPLNBR)   VALUE(&SPLNB)

             SNDNETSPLF FILE(&SPLF) TOUSRID((&INQ SYSTEM1)) +
                          JOB(&JOBNAM/&JOBUSR/&JOBNBR) +
                          SPLNBR(&SPLNBR) DTAFMT(*ALLDATA)
             MONMSG     MSGID(CPF3344 CPF3342)

             DLTSPLF    FILE(&SPLF) JOB(&JOBNAM/&JOBUSR/&JOBNBR) +
                          SPLNBR(&SPLNBR)
             MONMSG     MSGID(CPF3344 CPF3342)

             ENDPGM
