             PGM
             /*** AL#C01E ***********************************/
             /*   CREATE SUPPL ORDER FROM WEB ORDER DATA    */
             /*   LEC         2020.07.09                    */
             /***********************************************/

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SIRE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WEB) TYPE(*CHAR) LEN(1) VALUE('W')
             DCL        VAR(&USR9)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)

/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGVAR     VAR(&USR9) VALUE(&USER)
             CHGVAR     VAR(&USER) VALUE(&USR9 *CAT &WEB)

             OVRPRTF    FILE(QPRINT)  OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT5) OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT6) OUTQ(EPRINT1) HOLD(*YES)

             DLTF       FILE(QTEMP/AB#WP452)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP452) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP201)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP201) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP452) TOFILE(QTEMP/AB#WP452)
             OVRDBF     FILE(AB#WP201) TOFILE(QTEMP/AB#WP201)

/*  create order workfile from supplemental web order data...           */
             CALL       AL#R01E

/*  GENERATE AB#PP10 & AB#PPA1 FOR SUPPLEMENTAL ORDERS                  */
             CALL       PGM(AB#R45) PARM(&USER)

             DLTOVR     FILE(*ALL)
             ENDPGM
