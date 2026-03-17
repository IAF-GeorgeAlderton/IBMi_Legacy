             PGM
             /** AJSCA0 **********************************/
             /* PLATING READMISSION INVESTIGATION LIST(BY PART NO ) */
             /* C:N.HAYAKAWA                  1994.03.06 */
             /********************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&USW1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&USR)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(APLR00) PARM(&USR &USRN)
             CHGJOB     RUNPTY(40)
             /* DELETE AND MAKING  WORK FILE */
             DLTF       FILE(HWFILE1/AJSWPA0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWPA0) RCDLEN(70) SIZE(2000 +
                          500)
             DLTF       FILE(HWFILE1/AJSWPA1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWPA1) RCDLEN(70) SIZE(2000 +
                          500)
             /* DATA  PICK OUT   */
             CALL       PGM(AJSRA0) PARM(&USW1)
             IF         (&USW1 *EQ '*') GOTO END
             /* DATA SORT */
             FMTDTA     INFILE((HWFILE1/AJSWPA0)) +
                          OUTFILE(HWFILE1/AJSWPA1) SRCFILE(FMTSRC) +
                          SRCMBR(AJSSA0) OPTION(*NOPRT)
             /*PRINT DATA */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(AJSRA1) PARM(&USRN)
             DLTOVR     FILE(QPRINT)
             /*DELETE WORK FILE */
   END:   /* DLTF FILE(HWFILE1/AJSWPA0) */
          /* DLTF FILE(HWFILE1/AJSWPA1) */

             ENDPGM
