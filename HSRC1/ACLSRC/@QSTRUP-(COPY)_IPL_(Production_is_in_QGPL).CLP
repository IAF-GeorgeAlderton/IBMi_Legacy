/********************************************************************/
/*                                                                  */
/* 5770SS1 V7R1M0 100423     RTVCLSRC Output     13.03.27 05:48:15  */
/*                                                                  */
/* Program name . . . . . . . . . . . . . . :   QSTRUP            PN*/
/* Library name . . . . . . . . . . . . . . :   QSYS              PL*/
/* Original source file . . . . . . . . . . :   S000076444        SN*/
/* Library name . . . . . . . . . . . . . . :   $BLDSS1           SL*/
/* Original source member . . . . . . . . . :   S000076444        SM*/
/* Source file change                                               */
/*   date/time  . . . . . . . . . . . . . . :   09.10.05 00:20:13 SC*/
/* Patch option . . . . . . . . . . . . . . :   *NOPATCH          PO*/
/* User profile . . . . . . . . . . . . . . :   *USER             UP*/
/* Text . . . :                                                   TX*/
/* Owner  . . . . . . . . . . . . . . . . . :   QSYS              OW*/
/* User mod flag  . . . . . . . . . . . . . :   *NO               UM*/
/* Retrieve included source . . . . . . . . :   *NO               RI*/
/*                                                                ED*/
/********************************************************************/
/* Modified                                                         */
/*   JW  2018.01.05 add AJAC02 (Weekly Job)                         */
/*   JW2 2023.06.14 add QBIAF AS A SUBSYSTEM                        */
/********************************************************************/
     PGM
     DCL VAR(&STRWTRS) TYPE(*CHAR) LEN(1)
     DCL VAR(&CTLSBSD) TYPE(*CHAR) LEN(20)
     DCL VAR(&CPYR) TYPE(*CHAR) LEN(90) VALUE('5770-SS1 (C) COPYRIGHT-
 IBM CORP 1980, 2009. LICENSED MATERIAL - PROGRAM PROPERTY OF IBM')
     QSYS/STRSBS SBSD(QSERVER)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QUSRWRK)
     MONMSG MSGID(CPF0000)
     QSYS/RLSJOBQ JOBQ(QGPL/QS36MRT)
     MONMSG MSGID(CPF0000)
     QSYS/RLSJOBQ JOBQ(QGPL/QS36EVOKE)
     MONMSG MSGID(CPF0000)
     QSYS/STRCLNUP
     MONMSG MSGID(CPF0000 CPF1E37 CPF1E1C)
     QSYS/RTVSYSVAL SYSVAL(QCTLSBSD) RTNVAR(&CTLSBSD)
     IF COND((&CTLSBSD *NE 'QCTL      QSYS      ') *AND (&CTLSBSD *NE-
 'QCTL      QGPL      ')) THEN(GOTO CMDLBL(DONE))
     QSYS/STRSBS SBSD(QINTER)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QPASS)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QSNADS)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(APICSCTL)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH1)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH2)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH3)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH4)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH5)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH6)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QBATCH7)
     MONMSG MSGID(CPF0000)
     QSYS/STRSBS SBSD(QCMN)
     MONMSG MSGID(CPF0000)
/*JW2*/
     QSYS/STRSBS SBSD(QBIAF)
     MONMSG MSGID(CPF0000)

 /* HULFT */
             QSYS/STRSBS SBSD(HULFT/HULFT)
             MONMSG     MSGID(CPF0000)

 /* RDB CONNECT */
             QSYS/STRSBS SBSD(RDB50/RDBSBS)
             MONMSG     MSGID(CPF0000)

DONE:
     QSYS/STRSBS SBSD(QSPL)
     MONMSG MSGID(CPF0000)
     QSYS/RTVSYSVAL SYSVAL(QSTRPRTWTR) RTNVAR(&STRWTRS)
     IF COND(&STRWTRS = '0') THEN(GOTO CMDLBL(NOWTRS))
     CALL PGM(QSYS/QWCSWTRS)
     MONMSG MSGID(CPF0000)

NOWTRS:

 /*(JW1) Run Weekly Job */
     CALL PGM(AJAC02)
     MONMSG MSGID(CPF0000)

 /* CLROUTQ                           */
 /*  CLROUTQ    OUTQ(QUSRSYS/CMDOUTQ) */
 /*  MONMSG     MSGID(CPF0000)        */

 /* CLRLIB                            */
 /*  CLRLIB     LIB(WEEKDLT)          */
 /*  MONMSG     MSGID(CPF0000)        */

 /* SBMJOB ENDJOB */
     CALL PGM(ENDCP2)
     MONMSG MSGID(CPF0000)

 /* DAILY OPERATION */
     CALL PGM(AJAC01)
     MONMSG MSGID(CPF0000)

 /* PRINTER POWER SUPPLY ENDWTR */
     CALL PGM(RGAC01)
     MONMSG MSGID(CPF0000)

 /* PRINTER POWER SUPPLY STRPRTWTR */
     CALL PGM(RGAC02)
     MONMSG MSGID(CPF0000)

 /* LABEL DATA CLEAR & RE-ORGANIZE FILES RGZPFM */
     CALL PGM(AB#CA9)
     MONMSG MSGID(CPF0000)

 /* SBMJOB  APICSCTL AP0111 KT0111 */
     CALL PGM(AIACP6)
     MONMSG MSGID(CPF0000)

 /* SBMJOB  MEKI_M  MEKI_R */
     CALL PGM(AJVCP2)
     MONMSG MSGID(CPF0000)

 /* SBMJOB EDI_R EDI_S */
     CALL PGM(JYUCP2)
     MONMSG MSGID(CPF0000)

 /* SBMJOB CHKJOB */
     CALL PGM(CHKCP2)
     MONMSG MSGID(CPF0000)

 /* START NET CLIENT SERVER CRTDIR QNTC */
     CALL PGM(CRDC01)
     MONMSG MSGID(CPF0000)

 /* SBMJOB HULFT */
     CLRLIB     LIB(HULTEMP)
     SBMJOB     CMD(CALL PGM(HULFT/HULSNDD)) JOB(HULSNDD) +
                  JOBQ(HULFT/HULJOBQ)
     SBMJOB     CMD(CALL PGM(HULFT/HULRCVD)) JOB(HULRCVD) +
                  JOBQ(HULFT/HULJOBQ)
     SBMJOB     CMD(CALL PGM(HULFT/HULOBSD)) JOB(HULOBSD) +
                  JOBQ(HULFT/HULJOBQ)
 /* RGZPFM LOGS FOR HULFT */
     RGZPFM     FILE(HULFT/EXECLOGR)
     MONMSG     MSGID(CPF0000)
     RGZPFM     FILE(HULFT/SNDLOG)
     MONMSG     MSGID(CPF0000)
     RGZPFM     FILE(HULFT/RCVLOG)
     MONMSG     MSGID(CPF0000)

 /* SBMJOB  B2B_R & B2B_S & B2B_E */
     CALL PGM(EJKC00)
     MONMSG MSGID(CPF0000)

 /* SBMJOB  S_MONITOR  */
     CALL PGM(ABTC09)
     MONMSG MSGID(CPF0000)

     STRTCPSVR  SERVER(*SSHD)
     MONMSG MSGID(CPF0000)

 /**** END *******/
     RETURN
     CHGVAR VAR(&CPYR) VALUE(&CPYR)
     ENDPGM
