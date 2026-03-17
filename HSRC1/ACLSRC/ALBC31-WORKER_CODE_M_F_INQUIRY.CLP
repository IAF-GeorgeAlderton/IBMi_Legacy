             PGM
             /** ALBC31 **********************************/
             /* INQUIRY OF WORKER CD M/F                 */
             /* C:K.OKACHI                    1997.06.02 */
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
             /*DELETE WORK FILE */
             DLTF       FILE(HWFILE1/ALBWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ALBWP31) RCDLEN(8) +
                          OPTION(*NOLIST) SIZE(5000) LVLCHK(*NO)
             /* DATA  PICK OUT   */
             CALL       PGM(ALBR31)

             ENDPGM
