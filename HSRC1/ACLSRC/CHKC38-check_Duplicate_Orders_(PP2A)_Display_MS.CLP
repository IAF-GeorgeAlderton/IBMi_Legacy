             PGM
             /** CHKC38 **********************************************/
             /*  CHECK DUPLICATE ORDERS (PP2A)                       */
             /*  J.WATANABE 3/6/2018                                 */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(50)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* CHECK DUPLICATE ORDERS (AB#PP2A) */

             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR38) PARM('N' &RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             SNDPGMMSG  MSG('PP2A Contains Duplicate Order !') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ)
             CHGVAR     VAR(&MSG) VALUE('** PP2A contains Duplicate +
                          Order!!!')
             CALL PGM(QUILNGTX) PARM(&MSG X'00000046' ' ' ' ' X'00000000')
             GOTO       CMDLBL(ENDP)
             ENDDO

             CHGVAR     VAR(&MSG) VALUE('** PP2A does not contain +
                          Duplicate ORDER ...**')
             CALL PGM(QUILNGTX) PARM(&MSG X'00000046' ' ' ' ' X'00000000')
ENDP:
             DLTOVR     FILE(QPRINT)
             ENDPGM
