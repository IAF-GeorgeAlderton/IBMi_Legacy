             PGM
             /** VVVCA0 **********************************/
             /* CREATE VVVPPA0/VVVPLB0                   */
             /* JW   2016.04.28 ADD CALL                 */
             /********************************************/

             DSPPGMREF  PGM(HOBJ1/*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/VVVWPA0)

             CPYF       FROMFILE(HWFILE1/VVVWPAG) +
                          TOFILE(HWFILE1/VVVWPA0) MBROPT(*ADD) +
                          FMTOPT(*MAP)

             CLRPFM     FILE(HFILE1/VVVPPA0)
             MONMSG     MSGID(CPF3156) EXEC(GOTO CMDLBL(JOB2))

             CALL       PGM(VVVRA0)
 JOB2:
             CLRPFM     FILE(HFILE1/VVVPPB0)
             MONMSG     MSGID(CPF3156) EXEC(GOTO CMDLBL(JOB3))
             CALL       PGM(VVVRB0)
 JOB3:
             DSPDBR     FILE(HFILE1/*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/VVVWPA1)
             CLRPFM     FILE(HFILE1/VVVPPA1)
             MONMSG     MSGID(CPF3156) EXEC(GOTO CMDLBL(JOB4))
             CALL       PGM(VVVRA1)
 JOB4:
             DSPDBR     FILE(HWFILE1/*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/VVVWPA1)
             CALL       PGM(VVVRA1)

             CALL       PGM(VVVRA2)

             CPYF       FROMFILE(HFILE1/VVVPPA0) +
                          TOFILE(TFILE1/VVVPPA0) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/VVVPPA1) +
                          TOFILE(TFILE1/VVVPPA1) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/VVVPPB0) +
                          TOFILE(TFILE1/VVVPPB0) MBROPT(*REPLACE)

             /* JW ADD SET VVVPP10 */
             CALL       PGM(VVVC10)

             /* JW ADD USRPRF --> VVVPPB0 */
             CALL       PGM(VVVC12)

             ENDPGM
