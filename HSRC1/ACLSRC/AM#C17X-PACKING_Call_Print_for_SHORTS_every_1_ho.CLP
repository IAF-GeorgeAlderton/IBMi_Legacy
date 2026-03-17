             PGM
             /** AM#C17X **************************************/
             /* PACKING - PRINT SHORTS EVERY 1HR              */
             /*   LEC.   2019.08.26  CREATE                   */
             /*   LEC.   2021.05.26  ADD SERVICE PARTS        */
             /*   LEC.   2021.08.05  ADD HONDA                */
             /*************************************************/

             DCL        VAR(&CURTM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CURHR) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&RESHR) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&RESTM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WKHR) TYPE(*CHAR) LEN(2)

/* get current system hour...                                      */
             RTVSYSVAL  SYSVAL(QHOUR) RTNVAR(&WKHR)

             CHGVAR     VAR(&CURHR) VALUE(&WKHR)
             CHGVAR     VAR(&RESHR) VALUE(&CURHR)

/* purge "short" scan WF to the last 14 days...                    */
             CALL       PGM(AM#R17X)
             CALL       PGM(AB#R2DX)
             CALL       PGM(ALDR27X)


 #AGAIN:

/* run program to print short items from scanned workfile.         */
             CALL       PGM(AM#C17P)
             CALL       PGM(AB#C2DP)

/* get next hour to resume job...                                  */
             CHGVAR     VAR(&RESHR) VALUE(&RESHR + 1)

/* if next resume hour is 8, end this job                          */
/*    because new job is scheduled at 8am...                       */
             IF         COND(&RESHR *EQ 8) THEN(DO)
                        GOTO  #END
                        ENDDO

/* midnight is '000000'...                                         */
             IF         COND(&RESHR *GE 24) THEN(DO)
                        CHGVAR     VAR(&RESHR) VALUE(0)
                        ENDDO

             CHGVAR     VAR(&WKHR) VALUE(&RESHR)
             CHGVAR     VAR(&RESTM) VALUE(&WKHR *CAT '0000')

/* delay job until next hour resume time...                        */
             DLYJOB     RSMTIME(&RESTM)
             GOTO #AGAIN

 #END:       ENDPGM
