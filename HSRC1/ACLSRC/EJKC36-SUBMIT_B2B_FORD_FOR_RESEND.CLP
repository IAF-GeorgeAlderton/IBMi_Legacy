             PGM
             /** EJKC36 *************************************/
             /* SUBMIT B2B_FORD FOR RESEND                  */
             /*    **ORIGINAL IS JK590C FROM ASJ**          */
             /*   T.SAKAKI              2016.12.13          */
             /*  -----------------------------------------  */
             /*  JW1    2017.11.06 CHG JOBQ TO JOBQ7        */
             /************************************ EJKC36 ***/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

     /* SUBMIT JOB */
          /* SBMJOB     CMD(CALL PGM(EJKC40)) JOB(B2B_FORD) +       */
          /*              JOBD(QBATCH) JOBQ(JOBQ6) USER(&USER) +    */
          /*              RTGDTA(*JOBD) INLLIBL(*JOBD)              */

          /* CHG JOBQ TO JOBQ7 (JW1)                                */
             SBMJOB     CMD(CALL PGM(EJKC40)) JOB(B2B_FORD) +
                          JOBD(QBATCH) JOBQ(JOBQ7) USER(&USER) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD)
             ENDPGM
