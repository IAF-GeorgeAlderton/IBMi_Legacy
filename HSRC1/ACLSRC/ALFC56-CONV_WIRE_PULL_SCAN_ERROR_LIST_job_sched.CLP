             PGM        PARM(&SHIFT)
/** ALFC56 ************************************************/
/*  CONVEYANCE WIRE PULL SCAN ERROR LOG LIST              */
/*     FROM JOB SCHEDULER                                 */
/* LEC    2018/12/14                                      */
/*                                                        */
/* TUCKER 2019/12/19  ADD ABBR7P  FOR S_MONITOR           */
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

             CALL       PGM(ALFC55) PARM(&FROM &TO &RFLG &PRTR)

             DLTOVR     FILE(*ALL)

/*  FOR S_MONITOR (KPI)   */
             CRTDTAARA  DTAARA(HOBJ1/ABBR7PACT) TYPE(*CHAR) LEN(14) +
                          TEXT('ABBR7P PROCESSING')
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(HWFILE1/ABBWP7P)

             CALL       PGM(ABBR7P) PARM(&SHIFT)

             DLTDTAARA  DTAARA(HOBJ1/ABBR7PACT)
             MONMSG     MSGID(CPF0000)

             ENDPGM
