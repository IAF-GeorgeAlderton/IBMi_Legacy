             PGM
             /**  AB#C4T11  *********************************/
             /*   RETRIEVE ORDER DATA FROM SQL01            */
             /*   LEC         2021.11.30                    */
             /***********************************************/

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SIRE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WEB) TYPE(*CHAR) LEN(1) VALUE('W')
             DCL        VAR(&USR9)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&P#ERR)  TYPE(*CHAR) LEN(1)

/* =================================================================*/
  /* build work files in QTEMP and set overrides...                 */

             DLTF       FILE(QTEMP/RDBWP20)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/RDBWP21)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(RDBWP20) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CRTDUPOBJ  OBJ(RDBWP21) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(RDBWP20) TOFILE(QTEMP/RDBWP20)
             OVRDBF     FILE(RDBWP21) TOFILE(QTEMP/RDBWP21)

             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

/* =================================================================*/
/*  retrieve order data ready to be uploaded from SQL01...          */
             CALL       RDBR20


/* =================================================================*/
/*  call program to process uploaded data...                        */
             CALL       AB#C4T12

/* =================================================================*/

             RMVLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

             ENDPGM
