             PGM

            DCLF       FILE(AYBPW01)

            CHGVAR     VAR(&USRID) VALUE(' ')
            CHGVAR     VAR(&D1ERR) VALUE(' ')
            CHGVAR     VAR(&IN99)  VALUE('0')
            CHGVAR     VAR(&IN11)  VALUE('0')

@DSP:
            SNDRCVF    RCDFMT(DSP01)
            CHGVAR     VAR(&D1ERR) VALUE(' ')
            CHGVAR     VAR(&IN99)  VALUE('0')
            CHGVAR     VAR(&IN11)  VALUE('0')

            IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))

            IF         COND(&USRID *EQ '          ') THEN(DO)
            CHGVAR     VAR(&IN99)  VALUE('1')
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&D1ERR) +
                          VALUE(' INPUT USER ID ')
             GOTO       @DSP
             ENDDO

             IF         COND((%SST(&USRID 1 1) *GE '0') *AND +
                          (%SST(&USRID 1 1) *LE '9')) THEN(DO)
             CHGVAR     VAR(&IN99)  VALUE('1')
             CHGVAR     VAR(&IN11)  VALUE('1')
             CHGVAR     VAR(&D1ERR) +
                          VALUE(' INPUT CHARACTER TO THE ONE DIGIT')
             GOTO       @DSP
             ENDDO

             DSPUSRPRF  USRPRF(&USRID) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/USRPRTFP)
             MONMSG     MSGID(CPF2204) EXEC(DO)
             CHGVAR     VAR(&IN99)  VALUE('1')
             CHGVAR     VAR(&IN11)  VALUE('1')
             CHGVAR     VAR(&D1ERR) +
                          VALUE(' UNREGISTERED THIS USER ID ')
             GOTO       @DSP
             ENDDO

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP))




   /* IAF REGISTRATION */
             QSYS/ADDDIRE USRID(&USRID SYSTEM6) USRD('SYSTEM:IAF') +
                          USER(&USRID) SYSNAME(IAF)
             ADDNETJOBE FROMUSRID(&USRID SYSTEM6) ACTION(*SUBMIT) +
                          SBMUSER(QPGMR) MSGQ(QSYS/QSYSOPR) +
                          JOBQ(QGPL/JOBQ5)

   /* AFS REGISTRATION */
             QSYS/ADDDIRE USRID(&USRID SYSTEMA) USRD('SYSTEM:AFS') +
                          SYSNAME(AFS)
             ADDNETJOBE FROMUSRID(&USRID SYSTEMA) ACTION(*SUBMIT) +
                          SBMUSER(QPGMR) MSGQ(QSYS/QSYSOPR) +
                          JOBQ(QGPL/JOBQ5)

   /* AFD REGISTRATION */
             QSYS/ADDDIRE USRID(&USRID SYSTEM3) USRD('SYSTEM:AFD') +
                          SYSNAME(AFD)
             ADDNETJOBE FROMUSRID(&USRID SYSTEM3) ACTION(*SUBMIT) +
                          SBMUSER(QPGMR) MSGQ(QSYS/QSYSOPR) +
                          JOBQ(QGPL/JOBQ5)

   /* ASJ REGISTRATION */
             QSYS/ADDDIRE USRID(&USRID SYSTEM1) +
                          USRD('SYSTEM:AOYAMA') SYSNAME(AOYAMA)
             ADDNETJOBE FROMUSRID(&USRID SYSTEM1) ACTION(*SUBMIT) +
                          SBMUSER(QPGMR) MSGQ(QSYS/QSYSOPR) +
                          JOBQ(QGPL/JOBQ5)

   /* ATC REGISTRATION */
             QSYS/ADDDIRE USRID(&USRID SYSTEM7) USRD('SYSTEM:ATC') +
                          SYSNAME(ATC)
             ADDNETJOBE FROMUSRID(&USRID SYSTEM7) ACTION(*SUBMIT) +
                          SBMUSER(QPGMR) MSGQ(QSYS/QSYSOPR) +
                          JOBQ(QGPL/JOBQ5)

   /* ACZ REGISTRATION */
             QSYS/ADDDIRE USRID(&USRID SYSTEM8) USRD('SYSTEM:ACZ') +
                          SYSNAME(ACZ)
             ADDNETJOBE FROMUSRID(&USRID SYSTEM8) ACTION(*SUBMIT) +
                          SBMUSER(QPGMR) MSGQ(QSYS/QSYSOPR) +
                          JOBQ(QGPL/JOBQ5)

    @END:
             ENDPGM
