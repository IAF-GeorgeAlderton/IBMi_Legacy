             PGM
             /** CHKC34 **************************************/
             /*  CREATE FILE STATUS REPORT (FOR MONTHLY JOB) */
             /*  J.WATANABE 2016.05.10                       */
             /************************************************/

             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

             DLTF       FILE(HWFILE1/WORK1)
             MONMSG     MSGID(CPF3142)

             DSPFD      FILE(BACKUP/*ALL) TYPE(*MBR) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(HWFILE1/WORK1)

 /* CPOY TO ISF */
             CHGVAR     VAR(&FNAM) VALUE('FILE STATUS (HWFILE1)')
        /*   CALL       PGM(APLC96) PARM('2' 'WORK1' 'HWFILE1' &FNAM 'Y') */

 END:        ENDPGM
