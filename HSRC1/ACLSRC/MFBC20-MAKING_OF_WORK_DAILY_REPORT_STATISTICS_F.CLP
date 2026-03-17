             PGM
             /** MFBC20 ****************************/
             /* MAKING OF WORK DAILY REPORT STATISTICS FILE  */
             /*      A-IDOTA       1990.03.01      */
             /**************************** MFBC20 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MFBHZ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVDTAARA  DTAARA(MFBDTHZ) RTNVAR(&MFBHZ)
             RTVJOBA    JOB(&WS) USER(&US)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&US &WLIB)
 STP1:
             CALL       PGM(MFBR20) PARM(&US &MFBHZ)
             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
       /*    CALL       PGM(NCHC12)   */
             CHGDTAARA  DTAARA(MFBDTHZ) VALUE(&MFBHZ)
             ENDDO
 END:        ENDPGM
