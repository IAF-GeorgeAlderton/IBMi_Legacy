             PGM
             /** GCQC49 **********************************/
             /*      DIE  KANBAN LIST                    */
             /* CREATE DATE. : 98.09.30                  */
             /* AUTHOR.      : MSK.KUNIEDA               */
             /* AUTHOR.      : TCH 05/05/17 LPP 63->64   */
             /*                                          */
             /* TCHK1 12/05/06 REMAKE                    */
             /********************************** GCQC49 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)  VALUE(' ')
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)  VALUE(' ')
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10) VALUE(' ')

             DCLF       FILE(GCQPW49)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 SETP1:
             SNDRCVF    DEV(&WSID) RCDFMT(GCQPW491)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&@MSG) +
                          VALUE('                            ')

             IF (&IN01 *EQ '1')  GOTO END

 SETP2:
             IF (&IN05   *EQ '1')  GOTO SETP3

             GOTO SETP1

 SETP3:
             /* DATA OUTPUT                                */

             CLRPFM     FILE(HWFILE1/GCQWP49)

             OVRDBF     FILE(GCQWP49) TOFILE(HWFILE1/GCQWP49)

             CALL       PGM(GCQR49) PARM(&USER)

             IF         COND(%SWITCH(00XXXXXX)) THEN(GOTO CMDLBL(END))

             CLRPFM     FILE(HWFILE1/GCQWP50)

             FMTDTA     INFILE((HWFILE1/GCQWP49)) +
                          OUTFILE(HWFILE1/GCQWP50) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS49) +
                          OPTION(*NOPRT)

 END:
             DLTOVR     FILE(*ALL)

             ENDPGM
