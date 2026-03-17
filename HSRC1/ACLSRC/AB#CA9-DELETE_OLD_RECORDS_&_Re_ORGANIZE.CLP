/** AB#CA9 ************************************************/
/*  LABEL DATA CLEAR(WEEKLY FILE RE-CREATE PROCESS)       */
/*        APR/25/02                                       */
/*        ADD JOB TO QGPL/@QSTRUP (AFTER IPL)             */
/*                                                        */
/* JW1    09/26/16 ADD CALL ABAC50                        */
/* JW2    07/05/17 ADD MONMSG FOR 24TH LINE               */
/* JW3    01/08/18 ADD SKIP FOR TEMP IPL                  */
/* JW4    03/07/18 ADD AJAR82                             */
/* JW5  2018.08.06 ADD CHKR19 (GET QUICK IPL FLAG)        */
/* JW6  2019.10.11 ADD CHK UTLC63 TO CHECK DELETED RECORD */
/**********************************************************/
PGM
             DCL        VAR(&RUNS) TYPE(*CHAR) LEN(01)
             DCL        VAR(&FLG ) TYPE(*CHAR) LEN(01)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(01)

/******************************************************************/
/* JW4 SKIP ALL PROCESS FOR QUICK IPL ("QIPL" IN AB#PPCT)         */
             CALL       PGM(CHKR19) PARM(&FLG)
             IF         COND(&FLG = 'Y') THEN(GOTO CMDLBL(END))

/*********************************************************************/
             SNDDST     TYPE(*LMSG) TOINTNET((KAZ.WATANABE@IAFI.COM) +
                          (tanebek@iafi.com)) DSTD('Start Weekly +
                          Process') LONGMSG('Start weekly file +
                          re-format. (AB#CA9).') DOCD('Start weekly +
                          file re-format.') /* TCHK6 */
/*********************************************************************/
/* JW2 */
             MONMSG     MSGID(CPF900C CPA0701)

             ADDLIBLE   LIB(ZMODLIB10) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

/* TCHK2 AH#PP11 DELETE & AH#PP31 ADD */
             CALL       PGM(ATAR91)

/* CHECK SUNDAY & DELETE RECORDS */
       /* JW2   CALL       PGM(AB#RA9) PARM(&RUNS)                    */
       /*       IF         COND(&RUNS *EQ '0') THEN(GOTO CMDLBL(END)) */

/* START REORGANIZATION */
             CALL       PGM(UTLC63A)

/* JW1 UPDATE FORD FC DATA */
             CALL       PGM(HOBJ1/ABAC50)

/* JW2 CLEAR AB#PPCT       */
             CALL       PGM(UTLR56) PARM('Y')

/* JW4 CLEAR PASS-THRU DEVICE FLAG  */
             CALL       PGM(AJAR82) PARM('Y')

/* LEC - CLEAR SHIPPING OVERFLOW AREA */
             CALL       PGM(ALDC9P)

/* JW  - CLEAR PF WEEKLY              */
             CLRPFM     FILE(HFILE1/ABAEP20SV)

/***********************************************************************/
             SNDDST     TYPE(*LMSG) TOINTNET((KAZ.WATANABE@IAFI.COM) +
                          (tanebek@iafi.com)) DSTD('End weekly +
                          Process') LONGMSG('End weekly file +
                          re-format. (AB#CA9).') DOCD('End weekly +
                          file re-format.') /* TCHK6 */
/***********************************************************************/
 END:
             ENDPGM
