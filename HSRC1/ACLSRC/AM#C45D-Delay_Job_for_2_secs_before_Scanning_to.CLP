/** AMGC45D ***********************************************/
/*   DISPLAY GOOD OR BAD, THEN DELAY JOB FOR 2 SECONDS    */
/*                                                        */
/*   LEC       2019.10.31                                 */
/**********************************************************/
             PGM        PARM(&DAMG)

             DCL        VAR(&DAMG) TYPE(*CHAR) LEN(1)
             DCLF       FILE(AM#PW45N)

             IF         COND(&DAMG *EQ ' ') THEN(SNDRCVF +
                          RCDFMT(DSP03) WAIT(*NO))

             IF         COND(&DAMG *EQ 'Y') THEN(SNDRCVF +
                          RCDFMT(DSP04) WAIT(*NO))

             DLYJOB     DLY(2)

             ENDPGM
