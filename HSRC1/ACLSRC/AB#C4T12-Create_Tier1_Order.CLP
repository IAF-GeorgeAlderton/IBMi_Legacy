             PGM
             /**  AB#C4T12  *********************************/
             /*   CREATE TIER1 ORDERS                       */
             /*   LEC         2021.11.30                    */
             /*   ----------------------------------------    */
             /*   JW1   2025.03.26 ADD SAVR03 (SAVE AB#WP452) */
             /*   JW1   2025.04.10 ADD AB#R12W                */
             /*************************************************/

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SIRE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WEB) TYPE(*CHAR) LEN(1) VALUE('W')
             DCL        VAR(&USR9)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&P#ERR)  TYPE(*CHAR) LEN(1)

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

/*  Validate order data and update with IAF information...              */
             CALL       PGM(AB#R4T11)

/*  create order workfile and log errors...                             */
             CALL       PGM(AB#R4T12) PARM(&P#ERR)

/*  if errors were logged, email error info to user...                  */
             IF         COND(&P#ERR *EQ 'Y') THEN(DO)
                        CALL PGM(AB#C4T13)
                        ENDDO

/*  generate AB#PP10 & AB#PPA1 for tier1 orders...                      */
             CALL       PGM(AB#R45) PARM(&USER)

/*  update Orders and OrderStatus tables on SQL01...                    */
             CALL       PGM(RDBR21)

/*  jw1 - Save AB#WP452 TO AB#WP45S                                     */
             CALL       PGM(SAVR03)

/*  jw1 - Create Universal EDI Order data                               */
             CALL       PGM(AB#R12W)

             DLTOVR     FILE(*ALL)
             ENDPGM
