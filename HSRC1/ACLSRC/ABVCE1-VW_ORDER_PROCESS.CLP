             PGM
             /** ABVCE1 ***************************/
             /*  VW ORDER PROCESS                 */
             /*  KIRI                  2015.06.25 */
             /*************************** ABVCE1 **/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             ADDLIBLE   LIB(G3X6PGM) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(G3X6DTA) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             /*---------------------------------*/
             /*  VW ORDER PROCESS               */
             /*---------------------------------*/

             CALL       PGM(ABVRE1)

             RMVLIBLE   LIB(G3X6DTA)
             MONMSG     MSGID(CPF0000)
             RMVLIBLE   LIB(G3X6PGM)
             MONMSG     MSGID(CPF0000)

END:
             ENDPGM
