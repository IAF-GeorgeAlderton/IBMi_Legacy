             PGM
             /** ABDC04 ***********************************/
             /*AUTOMATIC HANDLING INCREASE AND DECREASE MEASURE MENU */
             /* A-PICS1                                 */
             /* KOHHY.                   90.11.30         */
             /*********************************** ABDC04 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&HIZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&KBN) TYPE(*CHAR) LEN(1) VALUE(' ')
             RTVDTAARA  DTAARA(ABDDS1) RTNVAR(&HIZ)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ABDR04) PARM(&USER &HIZ &KBN)

             ENDPGM
