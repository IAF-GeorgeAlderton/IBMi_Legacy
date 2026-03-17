             PGM
             /** CHKC31 **************************************/
             /*  CREATE FILE STATUS REPORT (FOR MONTHLY JOB) */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM) */
             /*  J.WATANABE 2016.05.10                       */
             /************************************************/

             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

             DLTF       FILE(HWFILE1/WORK1)
             MONMSG     MSGID(CPF3142)

             DSPFD      FILE(HWFILE1/*ALL) TYPE(*MBR) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(HWFILE1/WORK1)

             CPYF       FROMFILE(HWFILE1/WORK1) +
                          TOFILE(HFILE1/VVVPP31) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

 END:        ENDPGM
