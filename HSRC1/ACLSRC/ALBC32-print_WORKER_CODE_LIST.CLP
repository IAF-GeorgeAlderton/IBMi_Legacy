             PGM
             /*** ALBC32 ************************/
             /* LIST OF WORKER CD M/F           */
             /*     CREATE DATE  : 1997/MAR/17. */
             /*     AUTHOR       : S.OHTAKE.    */
             /* (JW1) J.WATANABE 5/10/2016 ADD EMAIL  */
             /************************ ALBC32 ***/

            DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
            DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
            DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RUNQRY     QRY(HOBJ1/MSSWRKCD)

    /* JW1 */
             /* SAVE LOG */
     /**JW   CALL       PGM(UTLR07) PARM('ALBC32 PRINT WORKER CODE')   **/
             CALL       PGM(UTLR07D) PARM('ALBC32' 'ALBC32 PRINT +
                          WORKER CODE')

             /* SEND MAIL */
             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('AS400-SYSTEM@IAFI.COM')) +
                          DSTD('WORKER CODE HAS BEEN PRINTED +
                          (ALBC32)') LONGMSG('WORKER CODE HAS BEEN +
                          PRINTED (QRY:HOBJ1/WRKCD) BY ' *CAT &USER +
                          *TCAT '.') DOCD('WORKER CODE HAS BEEN +
                          PRINTED')

 END:        ENDPGM
