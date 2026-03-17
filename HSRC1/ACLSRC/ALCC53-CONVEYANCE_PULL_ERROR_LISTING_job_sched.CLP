             PGM        PARM(&SHIFT)
/** ALCC53 ************************************************/
/*  CONVEYANCE PULL 3-POINT SCAN ERROR LOG LIST           */
/*     FROM JOB SCHEDULER                                 */
/* LEC    2018/12/14                                      */
/**********************************************************/

             DCL        VAR(&SHIFT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             DCL        VAR(&FROM)   TYPE(*CHAR) LEN(12)
             DCL        VAR(&TO)   TYPE(*CHAR) LEN(12)
             DCL        VAR(&RFLG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTR)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/*  get date/times based on shift   */
             CALL       PGM(UTLR66) PARM(&SHIFT &FROM &TO &RTN)

/*  set printer to 'E' for email    */
             CHGVAR     VAR(&PRTR) VALUE('E')

             CALL       PGM(ALCC52) PARM(&FROM &TO &RFLG &PRTR)

             DLTOVR     FILE(*ALL)

             ENDPGM
