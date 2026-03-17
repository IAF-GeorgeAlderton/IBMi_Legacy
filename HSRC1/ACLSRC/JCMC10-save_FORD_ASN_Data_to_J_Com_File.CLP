/* JCMC10 *******************************************************************/
/*  SAVE FORD ASN DATA TO J-COM FILE                                        */
/*  J.WATANABE 05/06/2016                                                   */
/****************************************************************************/
            PGM         PARM(&UPD)

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UPD)   TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             IF         COND(&UPD = '1') THEN(DO)
       /***  CLRPFM JCMPP11  ***/
       /***  CLRPFM JCMPP12  ***/
             ENDDO

             CALL       PGM(JCMR10)

ENDPGM
