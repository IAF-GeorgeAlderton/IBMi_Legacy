             PGM
             /** AJSCC0 **********************************/
             /* INQUIRY OF WORKER CD M/F                 */
             /* C:K.OKACHI                    1997.03.31 */
             /********************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&USW1)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USR)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CLRPFM     FILE(HWFILE1/AJSWPB1)
             /* DATA  PICK OUT   */
             CALL       PGM(AJSRC0)
             /*DELETE WORK FILE */

             CPYF       FROMFILE(HWFILE1/AJSWPB1) +
                          TOFILE(HWFILE1/AJSWPB2) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

             ENDPGM
