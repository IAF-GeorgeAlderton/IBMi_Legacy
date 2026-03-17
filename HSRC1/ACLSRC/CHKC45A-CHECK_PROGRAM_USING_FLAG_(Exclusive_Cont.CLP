             PGM        PARM(&KEY &PGM &ACT &CHK &RTN)
             /** CHKC45 ******************************************************/
             /*  CHECK PROGRAM USING FLAG ((EXCLUSION CONTROL)               */
             /*  J.WATANABE 2018.08.02                                       */
             /*  PARAMETRES                                                  */
             /*   IN  $KEY  : 10A KEY WORD FOR LOCK                          */
             /*   "   $PGM  : 10A CALLING PROGRAM NAME                       */
             /*                   (MULTIPLE PROGRAMS CAN SHARE SAME KEY WORD)*/
             /*   "   $ACT  :  1A Y=LOCK, N=UNLOCK                           */
             /*   "   $CHK  :  3A "CHK"=CHECK JOB ACTIVE OR NOT              */
             /*                   ("CHK" IF ACTIVE-JOB DOES NOT EXIST,)      */
             /*                   (      THEN RELEASE LOCK            )      */
             /*   OUT $RTN  :  1A BLANK=NO  ERROR, *=ERROR                   */
             /* --------------------------------------------------           */
             /*   JW1       2022.11.11 ADD STAMP PROGRAM (UTLR07D)           */
             /****************************************************************/

             DCL        VAR(&KEY) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CHK) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TXT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(30)

             CALL       PGM(CHKR45) PARM(&KEY &PGM &ACT &CHK &RTN)

 /** STAMP JW1 **/
             IF COND(&ACT = 'Y') THEN(CHGVAR VAR(&TXT) VALUE('LOCK  '))
             IF COND(&ACT = 'N') THEN(CHGVAR VAR(&TXT) VALUE('UNLOCK'))

             CHGVAR     VAR(&MSG) VALUE(&TXT *BCAT &PGM)

             CALL       PGM(UTLR07D) PARM(&KEY &MSG)

             ENDPGM
