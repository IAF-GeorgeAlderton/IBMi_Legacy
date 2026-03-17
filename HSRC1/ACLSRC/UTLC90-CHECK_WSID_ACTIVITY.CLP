             PGM        PARM(&NUM &USR &WSID &RTN)
             /** UTLC90 ******************************************/
             /*  UTILITY - CHECK WSID ACTIVITY                    */
             /*  JW1: J-WATANABE             2018.08.29          */
             /*--------------------------------------------------*/
             /*  CALLING SEQ.                                    */
             /*                    CALL 'UTLC90'                 */
             /*                    PARM           $NUM    6      */
             /*                    PARM           $USR   10      */
             /*                    PARM           $WSID  10      */
             /*                    PARM           $RTN    1      */
             /*   IN  $NUM :  6A JOB NO.   "612358"              */
             /*       $USR : 10A USER ID   "I0777"               */
             /*       $WSID: 10A WSID      "W7WWE1"              */
             /*   OUT $RTN :  1A Y=ACTIVE, N=NOT ACTIVE          */
             /****************************************************/
             DCL        VAR(&NUM  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USR  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&RTN) VALUE('Y')

             OVRPRTF    FILE(QPDSPWSID) OUTQ(QUSRSYS/EPRINT1)
             OVRPRTF    FILE(QPJOBLOG ) OUTQ(QUSRSYS/EPRINT1)

             DSPJOB     JOB(&NUM/&USR/&WSID) OUTPUT(*PRINT) +
                          OPTION(*JOBLOG)
             MONMSG     MSGID(CPF1070 CPF2443) EXEC(DO)
             CHGVAR     VAR(&RTN) VALUE('N')
             ENDDO

             ENDPGM
