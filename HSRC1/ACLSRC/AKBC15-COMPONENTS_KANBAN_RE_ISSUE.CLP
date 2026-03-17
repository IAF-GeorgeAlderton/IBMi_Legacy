             PGM
             /** AKBC14 **********************************/
             /*      COMPONENTS KANBAN RE-ISSUE          */
             /* CREATE DATE. : 2003.04.21                */
             /* AUTHOR.      : TCH                       */
             /* TCHK1 09/15/11 CHG REC LENGTH            */
             /********************************** AKBC14 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)  VALUE(' ')
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)  VALUE(' ')
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
        /* */

 SETP3:      CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

             DLTF       FILE(QTEMP/AKBWP11A)
             MONMSG     MSGID(CPF3261 CPF2105)

/* TCHK1     CRTPF      FILE(QTEMP/AKBWP11A) RCDLEN(100) + */
/* TCHK1 */  CRTPF      FILE(QTEMP/AKBWP11A) RCDLEN(110) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO)


             OVRDBF     FILE(AKBWP11A) TOFILE(QTEMP/AKBWP11A)
             CALL       PGM(AKBR15) PARM(&END)

             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

             CLRPFM AKBWP01
             CPYF       FROMFILE(QTEMP/AKBWP11A) TOFILE(AKBWP01) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)


@END:

             ENDPGM
