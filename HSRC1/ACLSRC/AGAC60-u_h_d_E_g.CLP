             PGM
             /** AGAC61 ************************************/
             /* 平準化運行経路一括更新　                 */
             /*        M S K                 93.07.16      */
             /**********************************************/
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&CAN) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSNO) USER(&USER)

      /*     CALL       KZZR00 PARM(&WSNO &PRT &TYPE &PRTG)      */
             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             /*-----------------------------------------------------*/
 STEP01:     CHGJOB     OUTQ(&PRTG)

             DLTF       FILE(AGAWP60)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AGAWP60) RCDLEN(68) +
                          OPTION(*NOLIST) LVLCHK(*NO)

             CALL       PGM(AGAR60) PARM(&USER &CAN)
             IF  (&CAN  = '9')  DO
                 GOTO CANSEL
             ENDDO

             DLTF       FILE(AGAWL60)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AGAWL60) RCDLEN(068) +
                          OPTION(*NOLIST) LVLCHK(*NO)

             FMTDTA     INFILE((&WLIB/AGAWP60)) +
                          OUTFILE(&WLIB/AGAWL60) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AGAS60) +
                          OPTION(*NOPRT)
             MONMSG     MSGID(FMT9001) EXEC(GOTO CMDLBL(ERR01))
             GOTO       NOERR

 ERR01:      SNDPGMMSG  MSG('-n fﾞ bﾆﾞﾑc ﾆｬcﾒｭc ﾆuﾆj')
             GOTO END

             /*------------------------------------------*/

 NOERR:      OVRPRTF    FILE(AGAPR61) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(62) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(AGAR61) PARM(&USER)
 CANSEL:     CHGJOB     OUTQ(&PRT)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
