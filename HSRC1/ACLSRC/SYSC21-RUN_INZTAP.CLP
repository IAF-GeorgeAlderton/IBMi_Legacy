             PGM
             /** SYSC21 **********************************************/
             /*  INZTAP                                              */
             /*  JW    2017.12.11                                    */
             /********************************************************/
             DCLF       FILE(SYSPW21)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(STP1))

             INZTAP     DEV(TAP01) NEWVOL(IAF) CHECK(*NO) +
                          DENSITY(*ULTRIUM6) ENDOPT(*UNLOAD)

END:         ENDPGM
