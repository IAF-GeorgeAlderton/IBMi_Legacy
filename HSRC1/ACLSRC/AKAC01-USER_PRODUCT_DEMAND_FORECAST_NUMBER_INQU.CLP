             PGM
             /** AKAC01 ******************************/
             /*   USER PRODUCT DEMAND FORECAST NUMBER INQUIRY   */
             /*        I-HASADA 87.03.13             */
             /****************************** AKAC01 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AKAR01)

             ENDPGM
