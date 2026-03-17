 /* COPIED 2025.05.09                                                         */
 /*   *********************************************************************** */
 /*   * PROGRAM  : GENEDI    11/21/2002                                       */
 /*   * AUTHOR   : M. FIORILLO, STERLING COMMERCE                             */
 /*   * PURPOSE  : Automatic periodic EDI processing via FTP with STERLING    */
 /*   *            Information Broker                                         */
 /*   * NOTES    : Any outbound applications added must have CLRPFM on all    */
 /*   *            application files in each application after PRCTRNOUT      */
 /*   *            completes normally       G3X1CUSOBJ/QCLSRC                 */
 /*   *                                               CLROUTB                 */
 /*   *                                                                       */
 /*   *            This program makes explicit references to libraries.       */
 /*   *            When upgrading GENTRAN versions, this program must         */
 /*   *            be updated.                                                */
 /*   *                                                                       */
 /*   *            PRCTRNOUT may need applications added -- search for        */
 /*   *            label OUT:                                                 */
 /*   *                                                                       */
 /*   *            PRCTRNIN  initially process *ALL applications.  if         */
 /*   *            this needs change, search for label IN:                    */
 /*   *                                                                       */
 /*   *            Add inbound processing programs after PRCTRNIN             */
 /*   *            section immediately prior to label ENDPGM:                 */
 /*   *                                                                       */
 /*   *            ADD HONDA                                                  */
 /*   *            ADD AMBRAKE       TCH 1/31/05                              */
 /*   * TCHK1 08/16/06 ADD SPLIT FILE #20,#21                                 */
 /*   * TCHK2 09/07/06 ADD ANDROID 856S                                       */
 /*   * TCHK3 10/22/06 CHG HONDA CONNECTION                                   */
 /*   * TCHK4 11/15/06 CHG FOR VERSION UP                                     */
 /*   * TCHK5 11/20/06 RMV OUTBOUND STATUS 'Q' TO 'H'                         */
 /*   * TCHK6 04/06/09 RMV AMBRAKE PROCESS                                    */
 /*   * TCHK7 10/26/09 ADD ALCOBJ,DLCOBJ FILE(AB#EP73)                        */
 /*   * TCHK8 03/25/11 ADD 856AMB,856FLEX                                     */
 /*   * TCHK9 07/19/12 ADD 856TESLA,810INV2                                   */
 /*   *                RMV 810NUMMI                                           */
 /*   * RMK1  10/15/15 Add 997 for Ford Report                                */
 /*   * RMK1  11/05/15 REMOVE SEPARATE PRCTRNIN FOR DELFOBWN, DELJIT,997      */
 /*   * %0001 11/05/15 ADD TAKING TIME FOR ERROR HANDLING  BY TUCKER        */
 /*   * RMK2  12/28/15 ADD CALL TO AB#CG5.                             7      */
 /*   * RMK3  01/15/15 ADD CALL TO ABFC41.                             7      */
 /*   * RMK3  04/11/15 CLOSE QPRINT IF OPEN.                           7      */
 /*   * %0002 10/26/16 ADD CHECK OBJECT LOCK   T.SAKAKI                     */
 /*   * RMK4  03/16/17 CALL HINOFTP.  PRCTRNIN ZMODV.                         */
 /*   * %0003 06/09/17 ADD AB#CBK AND REMOVE ABFC41   T.SAKAK                 */
 /*   * RMK5  06/16/17 ADD SPLIT FILE 0027 FOR HOLLINGSWORTH                  */
 /*   * JW1   06/21/17 COMENT OUT AB#R0L                                      */
 /*   * RMK6  07/10/17 ADD SPLIT FILE 0028 FOR SUBARU 862.                    */
 /*   * JW2   07/17/17 SPLIT AB#C6J TO AB#C6L(FORD ONLY) AND AB#C6M(NOT FORD) */
 /*   * JW3   07/18/17 ADD CALL EDSR66 TO SAVE FORD 820 WORK FILE             */
 /*   * %0004 07/26/17 REMOVE AB#CG4   T.SAKAKI                               */
 /*   * JW4   08/23/17 COMMENT OUT CALL AB#C6L FOR SWITCHING TO B2B           */
 /*   * RMK7  03/05/18 CLEAR ALL INBOUND APPLICATION FILES INDIVIDUALLY       */
 /*                    INSTEAD OF USING PRCTRNIN TO CLEAR WHICH IS CAUSING    */
 /*                    RECORD LOCKS.                                          */
 /*   * RMK   01/11/19 CHANGE DESADVVW TO DESADVVW07.                         */
 /*   * RMK8  03/28/19 ADD SPLIT FILE 30 FOR 830INBARIE IN PRCTRNIN.          */
 /*   * RMK9  04/11/19 DENSO. PRCTRNIN ZMODD.                                 */
 /*   * RMK9  04/22/19 CALL DENSOSSL.                                         */
 /*   * RMK10 05/15/19 CALL DENSOSSLRE.                                       */
 /*   * RMK11 08/19/20 CALL AC#R30 TO GENEATE FLAT FILE NEEDED FOR SPECIAL    */
 /*   *                PRCTRNOUT TO CREATE INTERCHANGE PER TRANSACTION        */
 /*   * JW5   11/23/20 RELEASE FORD JOB                                       */
 /*   * RMK12 12/08/20 ADD 856OUTSER APP TO PRCTRNOUT.                        */
 /*   * RMK13 03/01/21 ADD 856HITACHI APP TO PRCTRNOUT.                       */
 /*   * RMK14 11/08/21 ADD SEPAATE COMM CALLS TO EACH DIVISION OF DENSO.      */
 /*   * LEC   02/28/22 ADD PROGRAM TO PROCESS TIER1 WEBSITE ORDERS.           */
 /*   * JW6   06/08/22 COMMENT OUT FORD ASN FILE (AB#EP66)                    */
 /*   * RMK15 08/01/22 ADD 856OUTASIN APP.                                    */
 /*   * RMK16 08/08/22 CALL AC#R31 TO GENEATE FLAT FILE NEEDED FOR TMS        */
 /*   *                PRCTRNOUT TO CREATE INTERCHANGE PER TRANSACTION        */
 /*   * RMK17 09/28/22 CALL HONDGXSSSL TO USE OPEN TEXT FOR HONDA.            */
 /*   * RMK18 07/29/24 COPY AB#PP6U.                                          */
 /*   * JW7   07/31/24 ADD SAVR06 (SAVE AB#PP6U TO AB#PP6US)                  */
 /*   * RMK19 09/27/24 ADD 856OUTSERT APPLICATION TO PRCTRNOUT.               */
 /*   * RMK20 01/21/25 ADD DELFORIN APPLICATION TO PRCTRNIN.                  */
 /*   *                ADD SPLIT FILE 33.                                     */
 /*   * JW8   05/09/25 ADD AB#CJ1 (LAST JOB IN GENTRAN)                       */
 /*   *********************************************************************** */

 GENEDI:     PGM

 /* Process ID unique number                                                  */
             DCL        &PRCID    *DEC  (9 0)

 /* Archive member name                                                       */
             DCL        &MBR      *CHAR   10

 /* Process ID unique number AlphaNumeric                                     */
             DCL        &PRCIDA   *CHAR    9

 /* Process ID unique Name consisting of process prefix followed by &PRCIDA   */
             DCL        &PRCNAM   *CHAR   15

 /* Variable used to send process name to program RTVMRTN and receive the   */


 /*  return code for that process from the message center header file       */
             DCL        &NAMRTN   *CHAR   15

 /*  Return code received from the message center header file               */
             DCL        &RTNCD    *CHAR    2

 /*  Highest return code for this cycle                                     */
             DCL        &CURRTN   *CHAR    2

 /*  Job type 0 = BATCH, 1 = INTERACTIVE                                    */
             DCL        &JOBTYPE  *CHAR    1

 /*  Message to send to user (interactive) or printout (batch)              */
             DCL        &MSG      *CHAR   48

 /*  Program-ending status message                                          */
             DCL        &ENDMSG   *CHAR   35

 /*  Job's current library retrieved and stored in &CURLIB                  */
             DCL        &CURLIB   *CHAR   10

 /*  Retrieved library of current INBDTA file                               */
             DCL        &RUNLIB   *CHAR   10

 /*  Flag to signal that error(s) have occurred                             */
             DCL        &ERRFLG   *CHAR    1  VALUE(' ')

 /*  Flag to signal success in allocating objects                           */
             DCL        &ALCFLG   *CHAR    1  VALUE(' ')

 /*  Number of records in 810 header file                                   */
             DCL        &REC810   *DEC (10 0)
             DCL        &REC81N   *DEC (10 0)

 /*  Number of records in 856 header file                                   */
             DCL        &REC856   *DEC (10 0)
             DCL        &REC66    *DEC (10 0)
             DCL        &REC57    *DEC (10 0)
             DCL        &REC59    *DEC (10 0)
             DCL        &REC60    *DEC (10 0)
 /* RMK11 */ DCL        &REC856I  *DEC (10 0)

 /*  Number of records in 997 file                                          */
    /*JW4    DCL        &REC997   *DEC (10 0)   */

 /*  Number of records OF AB#WP1J1                                          */
             DCL        &RECW1J   *DEC (10 0)

 /*  Controls STRCOMSSN Trace parm from data area TRACE                     */
             DCL        &TRACE    *CHAR 04

 /* Split Files 1-5 Current Record Count after EDITOR                    */
             DCL        &RCDSPLT01 *DEC (10 0)
             DCL        &RCDSPLT02 *DEC (10 0)
             DCL        &RCDSPLT03 *DEC (10 0)
             DCL        &RCDSPLT04 *DEC (10 0)
             DCL        &RCDSPLT05 *DEC (10 0)
             DCL        &RCDSPLT06 *DEC (10 0)
             DCL        &RCDSPLT07 *DEC (10 0)
             DCL        &RCDSPLT08 *DEC (10 0)
             DCL        &RCDSPLT09 *DEC (10 0)
             DCL        &RCDSPLT10 *DEC (10 0)
             DCL        &RCDSPLT17 *DEC (10 0)
/* TCHK1 */  DCL        &RCDSPLT20 *DEC (10 0)
/* TCHK1 */  DCL        &RCDSPLT21 *DEC (10 0)
  /* GM */
             DCL        &RCDSPLT14 *DEC (10 0)
             DCL        &RCDSPLT15 *DEC (10 0)
             DCL        &RCDSPLT18 *DEC (10 0)
             DCL        &RCDSPLT19 *DEC (10 0)
  /* HONDA */
             DCL        &RCDSPLT11 *DEC (10 0)
             DCL        &RCDSPLT12 *DEC (10 0)
             DCL        &RCDSPLT13 *DEC (10 0)
             DCL        &RCDSPLT16 *DEC (10 0)
  /* VW */
             DCL        &RCDSPLT22 *DEC (10 0)
             DCL        &RCDSPLT23 *DEC (10 0)
             DCL        &RCDSPLT24 *DEC (10 0)
             DCL        &RCDSPLT25 *DEC (10 0)
  /* HOLLINGSWORTH */
             DCL        &RCDSPLT27 *DEC (10 0)
  /* SUBARU 862  */
             DCL        &RCDSPLT28 *DEC (10 0)
  /* RMK8 TOYOTA BOSHOKU AMERICA 830 */
             DCL        &RCDSPLT30 *DEC (10 0)
  /* RNK20 BOCAR */
             DCL        &RCDSPLT33 *DEC (10 0)
  /* COUNT */
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
  /* %0001 FOR ERROR TIME HADLING */
             DCL        &EDATE     *CHAR    6
             DCL        &ETIME     *CHAR    6
             DCL        &MSG1     *CHAR   30
             DCL        &MSG2     *CHAR   50

 /* Flag indicating whether split files contain records                  */
             DCL        &SPLITS    *CHAR 10

 /*   * * * *  B E G I N   E X E C U T A B L E   C O D E  * * * * *      */

 /* %0001 */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&EDATE)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&ETIME)

 /* Gentran for AS/400 FTP will NOT work on IAF system without performing   */
 /* the following override so that the FTP software will see IBM default    */
 /* messages in English, rather than the customized messages in message     */
 /* files in the system library QSYS2962.                                   */
             OVRMSGF    MSGF(QTCPMSGF) TOMSGF(QTCP/QTCPMSGF)

 /*   Is this job running interactively or in batch?                     */
 /*   Also, save current CURLIB to restore later                         */
             RTVJOBA    TYPE(&JOBTYPE) CURLIB(&CURLIB)

 /*   Change current library to G3X1CUSOBJ                               */
             CHGCURLIB  CURLIB(G3X1CUSOBJ)

 /*   Increase logging level                                             */
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)

 /* If batch job, setup printing                                           */
             CHGJOB     OUTQ(EDIOUTQ)
             IF         COND(&JOBTYPE *EQ '0') THEN(OVRPRTF +
              FILE(QSYSPRT) OUTQ(EDIOUTQ) )

 /* Construct unique process name for PRCTRNOUT                            */
             RTVDTAARA  DTAARA(PRCID) RTNVAR(&PRCID)
             CHGVAR     VAR(&PRCID) VALUE(&PRCID + 1)
             CHGVAR    &PRCIDA VALUE(&PRCID)
             CHGVAR    &PRCNAM VALUE('POUT' *CAT &PRCIDA)
             CHGDTAARA  DTAARA(PRCID) VALUE(&PRCID)       /* update DTAARA */

 /* Process outbound transaction sets                                      */
 OUT:        CHGVAR   VAR(&ALCFLG) VALUE(' ')
 /* COMMON 856 HDR */
             ALCOBJ OBJ((AB#EP60 *FILE *EXCL)) WAIT(1)
             MONMSG   MSGID(CPF0000) EXEC(DO)
             CHGVAR   VAR(&ALCFLG) VALUE('N')
             ENDDO
 /* GM DESADV HDR */
             ALCOBJ  OBJ((AB#EP57 *FILE *EXCL)) WAIT(1)
             MONMSG   MSGID(CPF0000) EXEC(DO)
             CHGVAR   VAR(&ALCFLG) VALUE('N')
             ENDDO
 /* COMMON 810 HDR */
             ALCOBJ  OBJ((AB#EP70 *FILE *EXCL)) WAIT(1)
             MONMSG   MSGID(CPF0000) EXEC(DO)
             CHGVAR   VAR(&ALCFLG) VALUE('N')
             ENDDO
 /* NUMMI 810 HDR TCHK7 */
             ALCOBJ  OBJ((AB#EP73 *FILE *EXCL)) WAIT(1)
             MONMSG   MSGID(CPF0000) EXEC(DO)
             CHGVAR   VAR(&ALCFLG) VALUE('N')
             ENDDO
 /* FORD & ANDROID 856 HDR */
   /**JW6    ALCOBJ  OBJ((AB#EP66 *FILE *EXCL)) WAIT(1)      **/
   /**       MONMSG   MSGID(CPF0000) EXEC(DO)                **/
   /**       CHGVAR   VAR(&ALCFLG) VALUE('N')                **/
   /**       ENDDO                                           **/
 /* HONDA 856 HDR */
             ALCOBJ  OBJ((AB#EP59 *FILE *EXCL)) WAIT(1)
             MONMSG   MSGID(CPF0000) EXEC(DO)
             CHGVAR   VAR(&ALCFLG) VALUE('N')
             ENDDO

             IF      COND(&ALCFLG *EQ 'N') THEN(DO)
             DLCOBJ  OBJ((AB#EP60 *FILE *EXCL))
             DLCOBJ  OBJ((AB#EP57 *FILE *EXCL))
             DLCOBJ  OBJ((AB#EP70 *FILE *EXCL))
             DLCOBJ  OBJ((AB#EP73 *FILE *EXCL))
   /**JW6    DLCOBJ  OBJ((AB#EP66 *FILE *EXCL))              **/
             DLCOBJ  OBJ((AB#EP59 *FILE *EXCL))
             DLCOBJ  OBJ((AC#EP60 *FILE *EXCL))

             DLYJOB  DLY(60)
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             IF         COND(&COUNT *LE 10) THEN(GOTO CMDLBL(OUT))
 @MSG:
             CHGVAR     VAR(&COUNT) VALUE(0)

  /* %0002 CHECK OBJECT LOCK  */
             CALL       PGM(AB#C1J)

  /* %0001 FOR ERROR TIME HANDLING */
             RTVMBRD    FILE(HWFILE1/AB#WP1J1) NBRCURRCD(&RECW1J)
             IF         COND(&RECW1J *GT 0) THEN(DO)
             CHGVAR     VAR(&MSG1) VALUE('GENTRAN IS NOT WORKING ')
             CHGVAR     VAR(&MSG2) VALUE(&MSG1 *BCAT &EDATE *TCAT +
                          '-' *TCAT &ETIME)
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('AS400-SYSTEM@IAFI.COM')) +
                          DSTD(&MSG2) MSG('GENTRAN HAS NOT BEEN +
                          WORKING. PLEASE SEE ATTACHED FILE TO +
                          CHECK WHO IS USING AND REPLY QSYOPR +
                          MESSAGE.') DOCFILE(HWFILE1/AB#WP1J1) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&MSG2)
             ENDDO

             SNDPGMMSG  MSG('AN ERROR IS OCCURING IN GENTRAN PROCESS +
                          BECAUSE SOMEONE IS USING THE FILES +
                          RELATING TO ASN.PLEASE CONTACT IT PERSON. +
                          ENTER "R" TO RETRY PROCESS') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND(&KOTAE *EQ 'R' *OR &KOTAE *EQ 'r') +
                          THEN(GOTO CMDLBL(OUT))
             GOTO       CMDLBL(@MSG)
             ENDDO
/* RMK11 */
             RTVMBRD    FILE(AC#EP60) NBRCURRCD(&REC856I)
             IF         COND(&REC856I *GT 0) THEN(DO)
             CLRPFM AC#EP6F
             CALL       PGM(AC#R30)
             PRCTRNOUT  APPID(856OUTINT) INT(*YES) PRCNAM(&PRCNAM) +
                          PASTHR(*YES)
             CLRPFM AC#EP60
             CLRPFM AC#EP61
             CLRPFM AC#EP62
             ENDDO
/* RMK16 */
             RTVMBRD    FILE(AC#EP70) NBRCURRCD(&REC856I)
             IF         COND(&REC856I *GT 0) THEN(DO)
             CLRPFM AC#EP7F
             CALL       PGM(AC#R31)
             PRCTRNOUT  APPID(856TMSINT) INT(*YES) PRCNAM(&PRCNAM) +
                          PASTHR(*YES)

             CLRPFM AC#EP70
             CLRPFM AC#EP75
             CLRPFM AC#EP76
             ENDDO

             RTVMBRD    FILE(AB#EP60) NBRCURRCD(&REC856)
             RTVMBRD    FILE(AB#EP57) NBRCURRCD(&REC57)
             RTVMBRD    FILE(AB#EP66) NBRCURRCD(&REC66)
             RTVMBRD    FILE(AB#EP70) NBRCURRCD(&REC810)
             RTVMBRD    FILE(AB#EP73) NBRCURRCD(&REC81N)
             RTVMBRD    FILE(AB#EP59) NBRCURRCD(&REC59)
             RTVMBRD    FILE(ABVEP52) NBRCURRCD(&REC60)

             IF         COND(&REC856 *EQ 0 *AND &REC810 *EQ 0 *AND +
                          &REC66 *EQ 0 *AND &REC57 *EQ 0 *AND +
                          &REC81N *EQ 0 *AND &REC59 *EQ 0 *AND +
                          &REC60 *EQ 0) THEN(GOTO CMDLBL(COMSSN))

 /* OUTBOUND PROCESS */
 /* RMK15 ADD 856OUTASIN  */
 /* RMK19 ADD 856OUTSERT  */
             PRCTRNOUT  APPID(856OUT 856DMAX 810INV 810TMMC 856FORD +
                          DESADV 856TMS 856HONDA 856AMB 856FLEX +
                          856ANDROID 810INV2 856TESLA DESADVVW07 +
                          856OUTSER 856HITACHI 856OUTASIN +
                          856OUTSERT) INT(*YES) PRCNAM(&PRCNAM) +
                          BLANKPART(*NO) /* TCHK9 */


             MONMSG     MSGID(CPF0000) EXEC(DO)

 /* If error and if interactive job, display error in popup window         */
 /* TCHK4 */ IF         COND(&JOBTYPE *EQ '1') THEN(DO)
             CALL       QUILNGTX PARM('Error in PRCTRNOUT, +
                        process will continue' x'00000030' +
                        '        ' '                    '   +
                        x'00000000')
 /* TCHK4 */ ENDDO

 /* If error and if batch job, add error message line to printout          */
             IF         COND(&JOBTYPE *EQ '0') THEN(DO)
             CALL       PGM(GENEDIERR) PARM('PRCTRNOUT could not +
                          execute, process will continue' '0')
             CHGVAR     VAR(&ERRFLG) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(COMSSN)
             ENDDO

 /* If PRCTRNOUT ran, retrieve return code from MSGHDR                     */
             CHGVAR     &NAMRTN  VALUE(&PRCNAM)
             CALL       RTVMRTN  PARM(&NAMRTN)
             CHGVAR     VAR(&RTNCD) VALUE(&NAMRTN)
             CHGVAR     VAR(&CURRTN) VALUE(&RTNCD)

             CHGVAR     VAR(&MBR) VALUE('M' *CAT &PRCIDA)
             CALL       CLROUTB PARM(&MBR)

             IF         COND(&RTNCD *NE '00' *AND &JOBTYPE *EQ '0') +
                          THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(&PRCNAM *CAT ' ended with +
                        return code ' *CAT &RTNCD)
             CALL       PGM(GENEDIERR) PARM(&MSG '0')
             CHGVAR     VAR(&ERRFLG) VALUE('Y')
             ENDDO

 COMSSN:
 /* Deallocate application files                                           */
             DLCOBJ OBJ((AB#EP60 *FILE *EXCL))
             DLCOBJ OBJ((AB#EP57 *FILE *EXCL))
             DLCOBJ OBJ((AB#EP70 *FILE *EXCL))
             DLCOBJ OBJ((AB#EP73 *FILE *EXCL))
   /**JW6    DLCOBJ OBJ((AB#EP66 *FILE *EXCL))  **/
             DLCOBJ OBJ((AB#EP59 *FILE *EXCL))
 /* HONDA */
/* TCHK3    CALL ADVANSSL  */
/* TCHK4    CALL HONDASSL */
/* RMK17 */ CALL HONDGXSSSL
/* RMK4  */ CALL HINOFTP

/* RMK14 REMOVE DEMSLSSL AND DENSOSSLRE CALL. REPLACE WITH EACH DIVISION */
/* RMK9   CALL DENSOSSL  */
/* RMK10  CALL DENSOSSLRE */
 /*  COMMENTING OUT ALL OF DENSO EXCEPT FOR 1 UNTIL WE GET FIXED */
 /* JOE AND LARRY */
   CALL DENSODMARR
   CALL DENSODMARS
 /*CALL DENSODMCNR */
   CALL DENSODMCNS
 /*CALL DENSODMMIR */
   CALL DENSODMMIS
 /*CALL DENSODMTNR */
   CALL DENSODMTNS
 /*CALL DENSODNMXR */
   CALL DENSODNMXS
 /*CALL DENSOGNC_R */
   CALL DENSOGNC_S

 /* AMBRAKE */
/* TCHK6  * TCHK4 *  CALL AMBRKSSL */

 /* Construct unique process name for STRCOMSSN                            */
             CHGVAR    &PRCNAM VALUE('COMM' *CAT &PRCIDA)

 /* Process communications for CNFTP                                       */
             RTVDTAARA  DTAARA(TRACE) RTNVAR(&TRACE)

    /*       CHGVAR     VAR(&TRACE) VALUE('YES')   */

             IF         COND(&TRACE *EQ 'YES') THEN(CHGVAR +
                          VAR(&TRACE) VALUE('*YES'))
             IF         COND(&TRACE *NE '*YES') THEN(CHGVAR +
                          VAR(&TRACE) VALUE('*NO'))
             STRCOMSSN  PROFIL(CNFTP) SSN(SR) DELETE(*YES) +
                          TRACE(&TRACE) INT(*YES) PROCNAME(&PRCNAM)
             MONMSG     MSGID(CPF0000) EXEC(DO)

 /* If error and if interactive job, display error in popup window         */
/* TCHK4 */  IF         COND(&JOBTYPE *EQ '1') THEN(DO)
             CALL       QUILNGTX PARM('Error in STRCOMSSN, +
                        process will not continue' x'00000030' +
                        '        ' '                    '   +
                        x'00000000')
/* TCHK4 */  ENDDO

 /* If error and if batch job, add error message line to printout          */
             IF         COND(&JOBTYPE *EQ '0') THEN(DO)
             CALL       PGM(GENEDIERR) PARM('STRCOMSSN could not +
                          execute, process will not continue' '0')
             CHGVAR     VAR(&ERRFLG) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(ENDPGM)
             ENDDO

 /* If STRCOMSSN ran, retrieve return code from MSGHDR                     */
             CHGVAR     &NAMRTN  VALUE(&PRCNAM)
             CALL       RTVMRTN  PARM(&NAMRTN)
             CHGVAR     VAR(&RTNCD) VALUE(&NAMRTN)
             IF         COND(&RTNCD *GT &CURRTN) THEN(CHGVAR +
                          VAR(&CURRTN) VALUE(&RTNCD))
             IF         COND(&RTNCD *NE '00' *AND &JOBTYPE *EQ '0') +
                          THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(&PRCNAM *CAT ' ended with +
                        return code ' *CAT &RTNCD)
             CALL       PGM(GENEDIERR) PARM(&MSG '0')
             CHGVAR     VAR(&ERRFLG) VALUE('Y')
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             IF         COND(&RTNCD *EQ '16') THEN(GOTO +
                          CMDLBL(ENDPGM))

 PRCIN:

 /* Construct unique process name for PRCTRNIN from EDITOR                 */
             CHGVAR    &PRCNAM VALUE('PINE' *CAT &PRCIDA)

 /* Process inbound transaction sets from EDITOR                           */
             PRCTRNIN   COMPRF(CNFTP) APPID(*NONE) INT(*YES) +
                          PRCNAM(&PRCNAM)
             MONMSG     MSGID(CPF0000) EXEC(DO)

 /* If error and if interactive job, display error in popup window         */
/* TCHK4 */  IF         COND(&JOBTYPE *EQ '1') THEN(DO)
             CALL       QUILNGTX PARM('Error in EDITOR, +
                        process will not continue' x'00000030' +
                        '        ' '                    '   +
                        x'00000000')
/* TCHK4 */  ENDDO


 /* If error and if batch job, add error message line to printout          */
             IF         COND(&JOBTYPE *EQ '0') THEN(DO)
             CALL       PGM(GENEDIERR) PARM('EDITOR could not +
                          execute, process will not continue' '0')
             CHGVAR     VAR(&ERRFLG) VALUE('Y')
             ENDDO
             GOTO       CMDLBL(ENDPGM)
             ENDDO

 /* HONDA */
 /*          PRCTRNIN   COMPRF(ZMOD) APPID(*NONE) INT(*YES) */
 /*          MONMSG     MSGID(CPF0000) */
/* RMK17 */  PRCTRNIN   COMPRF(ZMODGXS) APPID(*NONE) INT(*YES)
             MONMSG     MSGID(CPF0000)
 /* AMBRAKE */
             PRCTRNIN   COMPRF(AMBRAKE) APPID(*NONE) INT(*YES)
             MONMSG     MSGID(CPF0000)
 /* RMK4. VASCOR-HINO MOTORS */
             PRCTRNIN   COMPRF(ZMODV) APPID(*NONE) INT(*YES)
             MONMSG     MSGID(CPF0000)
 /* RMK9. DENSO */
 /* RMK14. REMOVE ZMODD.  REPLACE WITH EACH DENSO DIV COMM PROFILE.*/
        /*   PRCTRNIN   COMPRF(ZMODD) APPID(*NONE) INT(*YES) */
             PRCTRNIN   COMPRF(ZMODDMAR) APPID(*NONE) INT(*YES)
             MONMSG     MSGID(CPF0000)
             PRCTRNIN   COMPRF(ZMODDMCN) APPID(*NONE) INT(*YES)
             MONMSG     MSGID(CPF0000)
             PRCTRNIN   COMPRF(ZMODDMMI) APPID(*NONE) INT(*YES)
             MONMSG     MSGID(CPF0000)
             PRCTRNIN   COMPRF(ZMODDMTN) APPID(*NONE) INT(*YES)
             MONMSG     MSGID(CPF0000)
             PRCTRNIN   COMPRF(ZMODDNMX) APPID(*NONE) INT(*YES)
             MONMSG     MSGID(CPF0000)
             PRCTRNIN   COMPRF(ZMODGNC)  APPID(*NONE) INT(*YES)
             MONMSG     MSGID(CPF0000)

 /* If PRCTRNIN ran, retrieve return code from MSGHDR                     */
             CHGVAR     &NAMRTN  VALUE(&PRCNAM)
             CALL       RTVMRTN  PARM(&NAMRTN)
             CHGVAR     VAR(&RTNCD) VALUE(&NAMRTN)
             CHGVAR     VAR(&CURRTN) VALUE(&RTNCD)
             IF         COND(&RTNCD *NE '00' *AND &JOBTYPE *EQ '0') +
                          THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(&PRCNAM *CAT ' ended with +
                        return code ' *CAT &RTNCD)
             CALL       PGM(GENEDIERR) PARM(&MSG '0')
             CHGVAR     VAR(&ERRFLG) VALUE('Y')
             ENDDO

 /* Check for records received and sent to split files                     */
             RTVMBRD    FILE(GT1501) NBRCURRCD(&RCDSPLT01)
             RTVMBRD    FILE(GT1502) NBRCURRCD(&RCDSPLT02)
             RTVMBRD    FILE(GT1503) NBRCURRCD(&RCDSPLT03)
             RTVMBRD    FILE(GT1504) NBRCURRCD(&RCDSPLT04)
             RTVMBRD    FILE(GT1505) NBRCURRCD(&RCDSPLT05)
             RTVMBRD    FILE(GT1506) NBRCURRCD(&RCDSPLT06)
             RTVMBRD    FILE(GT1507) NBRCURRCD(&RCDSPLT07)
             RTVMBRD    FILE(GT1508) NBRCURRCD(&RCDSPLT08)
             RTVMBRD    FILE(GT1509) NBRCURRCD(&RCDSPLT09)
             RTVMBRD    FILE(GT1510) NBRCURRCD(&RCDSPLT10)
             RTVMBRD    FILE(GT1517) NBRCURRCD(&RCDSPLT17)
/* TCHK1 */  RTVMBRD    FILE(GT1520) NBRCURRCD(&RCDSPLT20)
/* TCHK1 */  RTVMBRD    FILE(GT1521) NBRCURRCD(&RCDSPLT21)
  /* GM */
             RTVMBRD    FILE(GT1514) NBRCURRCD(&RCDSPLT14)
             RTVMBRD    FILE(GT1518) NBRCURRCD(&RCDSPLT18)
             RTVMBRD    FILE(GT1519) NBRCURRCD(&RCDSPLT19)
  /* HONDA */
             RTVMBRD    FILE(GT1511) NBRCURRCD(&RCDSPLT11)
             RTVMBRD    FILE(GT1512) NBRCURRCD(&RCDSPLT12)
             RTVMBRD    FILE(GT1513) NBRCURRCD(&RCDSPLT13)
             RTVMBRD    FILE(GT1516) NBRCURRCD(&RCDSPLT16)
  /* VW */
             RTVMBRD    FILE(GT1515) NBRCURRCD(&RCDSPLT15)
             RTVMBRD    FILE(GT1522) NBRCURRCD(&RCDSPLT22)
  /* RK1 */
             RTVMBRD    FILE(GT1523) NBRCURRCD(&RCDSPLT23)
             RTVMBRD    FILE(GT1524) NBRCURRCD(&RCDSPLT24)
             RTVMBRD    FILE(GT1525) NBRCURRCD(&RCDSPLT25)
  /* RK5 */
             RTVMBRD    FILE(GT1527) NBRCURRCD(&RCDSPLT27)
  /* RK6 */
             RTVMBRD    FILE(GT1528) NBRCURRCD(&RCDSPLT28)
  /* RMK8 */
             RTVMBRD    FILE(GT1530) NBRCURRCD(&RCDSPLT30)
  /* BOCAR RMK20 */
             RTVMBRD    FILE(GT1533) NBRCURRCD(&RCDSPLT33)

             CHGVAR     VAR(&SPLITS) VALUE('NO ')
             IF         COND(&RCDSPLT01 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT02 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT03 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT04 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT05 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT06 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT07 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT08 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT09 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT10 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT17 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
/* TCHK1 */  IF         COND(&RCDSPLT20 *GT 0) THEN(CHGVAR +
/* TCHK1 */               VAR(&SPLITS) VALUE('YES'))
/* TCHK1 */  IF         COND(&RCDSPLT21 *GT 0) THEN(CHGVAR +
/* TCHK1 */               VAR(&SPLITS) VALUE('YES'))
 /* GM */
             IF         COND(&RCDSPLT14 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT18 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT19 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
 /* HONDA */
             IF         COND(&RCDSPLT11 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT12 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT13 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT16 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
 /* VW */
             IF         COND(&RCDSPLT15 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT22 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
 /* RK1 */
             IF         COND(&RCDSPLT23 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT24 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
             IF         COND(&RCDSPLT25 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
 /* RK4 */
             IF         COND(&RCDSPLT27 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
 /* RK6 */
             IF         COND(&RCDSPLT28 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))

 /* RMK8 */
             IF         COND(&RCDSPLT30 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))
 /* RMK20 */
             IF         COND(&RCDSPLT33 *GT 0) THEN(CHGVAR +
                          VAR(&SPLITS) VALUE('YES'))

  /* USER PROGRAM -- FORD CUM  */
             CALL       PGM(AB#RFF)
             CALL       PGM(GADC13)

 /* If no data in split files, then bypass PRCTRNIN for applications       */
             IF         COND(&SPLITS *NE 'YES') THEN(GOTO +
                          CMDLBL(NOAPPS))

 /* Construct unique process name for PRCTRNIN for MAPPER                  */
             CHGVAR    &PRCNAM VALUE('PMAP' *CAT &PRCIDA)

 /* Process inbound transaction sets for MAPPER                            */
 IN:         PRCTRNIN   COMPRF(*NONE) APPID(*ALL) INT(*YES) +
                          PRCNAM(&PRCNAM) REPLACE(*NO)
             MONMSG     MSGID(CPF0000) EXEC(DO)

 /* If error and if interactive job, display error in popup window         */
/* TCHK4 */  IF         COND(&JOBTYPE *EQ '1') THEN(DO)
             CALL       QUILNGTX PARM('Error in MAPPER run, +
                        process will not continue' x'00000030' +
                        '        ' '                    '   +
                        x'00000000')
/* TCHK4 */  ENDDO

 /* If error and if batch job, add error message line to printout          */
             IF         COND(&JOBTYPE *EQ '0') THEN(DO)
             CALL       PGM(GENEDIERR) PARM('MAPPER could not +
                          execute, process will not continue' '0')
             ENDDO
             GOTO       CMDLBL(ENDPGM)
             CHGVAR     VAR(&ERRFLG) VALUE('Y')
             ENDDO

 /* If PRCTRNIN ran, retrieve return code from MSGHDR                     */
             CHGVAR     &NAMRTN  VALUE(&PRCNAM)
             CALL       RTVMRTN  PARM(&NAMRTN)
             CHGVAR     VAR(&RTNCD) VALUE(&NAMRTN)
             CHGVAR     VAR(&CURRTN) VALUE(&RTNCD)
             IF         COND(&RTNCD *NE '00' *AND &JOBTYPE *EQ '0') +
                          THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(&PRCNAM *CAT ' ended with +
                        return code ' *CAT &RTNCD)
             CALL       PGM(GENEDIERR) PARM(&MSG '0')
             CHGVAR     VAR(&ERRFLG) VALUE('Y')
             ENDDO

 /* *** ADD INBOUND PROCESSING PROGRAMS AFTER THIS STATEMENT *** */
             CALL       PGM(AB#C0A)     /* ORDER */
             CALL       PGM(AB#C0I)     /* ORDER */
             CALL       PGM(ABACP5)     /* FORECAST */
             CALL       PGM(AB#C0J)     /* MESSAGE TEST */
     /*      CALL       PGM(AB#C0M)        MESSAGE TEXT        */

     /*JW2** CALL       PGM(AB#C6J) ****** REMITTANCE ADVICE     *****/
     /*JW4   CALL       PGM(AB#C6L)        REMITTANCE ADV - FORD     */

     /**JW5**/
             CALL       PGM(AB#C6L1)    /* REMITTANCE ADV - FORD     */

             CALL       PGM(AB#C6M)     /* REMITTANCE ADV - NOT FORD */

     /*JW3 * SAVE FORD820 WORK FILE AB#PP6J/6K/6L TO AB#PP6JS/6KS/6LS*/
             CALL       PGM(EDSR66)

     /*JW1** CALL       PGM(AB#R0L) ****** RECEIVING ADVIC ********  */

/**JW5**/    CALL       PGM(AB#C0L)

             CALL       PGM(AB#R0M)     /* RECEIVING ADVICE */
             CALL       PGM(AB#C0R)     /* GM RECADV        */
             CALL       PGM(AB#C0N)     /* PRICE CATALOG  */
             CALL       PGM(AB#C0O)     /* 864 MESSAGE     */
             CALL       PGM(AB#RFCL)    /* FACIL REQ. ACCUM*/
      /** %0003 **/
      /***   CALL       PGM(ABFC41)        856 FROM FORD ***/

/**JW5 **/   CALL       PGM(ABFC41)

 /**  %0004 ***/
 /**RK1      RTVMBRD    FILE(AB#PP6U) NBRCURRCD(&REC997)           **/
 /**RK1      IF         COND(&REC997 *GT 0) THEN(CALL PGM(AB#CG4)) **/

 /**  %0003 TAKE BACKUP FOR MIGRATION TO B2B **/
             CALL       PGM(AB#CBK)

 /* Construct unique process name for PRCTRNIN for MAPPER to clear APPS    */
             CHGVAR    &PRCNAM VALUE('PCLR' *CAT &PRCIDA)

 /* Process inbound transaction sets for MAPPER to clear APPS              */
 /* This PRCTRNIN is used ONLY to clear all application files              */
 /* RMK7 */
 /*CLR:        PRCTRNIN   COMPRF(*NONE) APPID(*ALL) INT(*YES) +   */
 /*                       PRCNAM(&PRCNAM) REPLACE(*YES)           */
 /* RMK18 COPY AB#PP6U */
             CPYF       FROMFILE(AB#PP6U) TOFILE(HFILE1/AB#PP6USAV) +
                          MBROPT(*ADD) CRTFILE(*YES)

 /* JW7 SAVE AB#PP6U TO AB#PP6US                                  */
             CALL       PGM(HOBJ1/SAVR06)

             CLRPFM  AB#EP10
             CLRPFM  AB#EP20
             CLRPFM  AB#EP40
             CLRPFM  AB#EP41
             CLRPFM  AB#EP45
             CLRPFM  AB#EP50
             CLRPFM  AB#EP51
             CLRPFM  AB#EP80
             CLRPFM  AB#EP81
             CLRPFM  AB#EP82
             CLRPFM  AB#EP90
             CLRPFM  AB#EP91
             CLRPFM  AB#EP92
             CLRPFM  AB#EP93
             CLRPFM  AB#EP95
             CLRPFM  AB#EP96
             CLRPFM  AB#EP97
             CLRPFM  AB#EP98
             CLRPFM  AB#PP6D
             CLRPFM  AB#PP6F
             CLRPFM  AB#PP6G
             CLRPFM  AB#PP6J
             CLRPFM  AB#PP6K
             CLRPFM  AB#PP6L
             CLRPFM  AB#PP6M
             CLRPFM  AB#PP6O
             CLRPFM  AB#PP6U
             CLRPFM  ABAEP10
             CLRPFM  ABAEP11
             CLRPFM  ABAEP15
             CLRPFM  ABAEP16
             CLRPFM  ABAEP20
             CLRPFM  ABAEP30
             CLRPFM  ABAEP35
             CLRPFM  ABVEP20
             CLRPFM  ABVEP21
 /*RMK7 */   CLRPFM  ABVEP22

 /* *** END   OF   INBOUND PROCESSING  *****                     */

 NOAPPS:
         CALL AB#C0C

 /* *** IF TEST, CHANGE OUTQ 'Q' TO 'H'                      *** */
             RTVMBRD    FILE(INBDTA) RTNLIB(&RUNLIB)
/* TCHK5     IF         COND(&RUNLIB *NE 'G3X1DTA') THEN(DO) */
/*           CALL       OUTHOLD  PARM(CNFTP)                 */
/*           CALL       OUTHOLD  PARM(CNFTPTST)              */
/*           ENDDO                                           */

 ENDPGM:
             IF         COND(&ERRFLG *EQ 'Y') THEN( +
             CALL PGM(GENEDIERR) PARM(' ' '1') )

/* TCHK4 */  IF         COND(&CURRTN *NE '00' *AND &JOBTYPE *EQ '1') +
                          THEN(DO)
             CHGVAR     VAR(&ENDMSG) VALUE('Program ended with +
                          return code ' *cat &CURRTN)
             CALL       PGM(QUILNGTX) PARM(&ENDMSG X'00000030' +
                          '        ' '                    ' +
                          X'00000000')
/* TCHK4 */  ENDDO

             CLOF       OPNID(QPRINT)
             MONMSG     MSGID(CPF4520)
/* RMK2      OVRPRTF    FILE(QPRINT) OUTQ(EDIOUTQ)  */
/* RMK2 */   CALL AB#CG5

             IF         COND(&CURLIB *NE 'NONE' *AND &CURLIB *NE +
                          '*NONE') THEN(CHGCURLIB CURLIB(&CURLIB))
             DLTOVR     *ALL

   /* Call Program to Create Tier1 Website Orders....              */
             CALL       PGM(AB#C4T11)

   /* JW8: the Final Program to be processed by Gentran....        */
             CALL       PGM(AB#CJ1  )

             ENDPGM
