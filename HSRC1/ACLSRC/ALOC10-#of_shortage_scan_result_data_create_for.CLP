/** ALOC10 ************************************************/
/*  #OF SHORTAGE SCAN                                     */
/* TCHK  10/07/14 CREATE                                  */
/*-------------------------------------                   */
/*  JW    2024.03.19 ADD EXCLUSIVE CONTROL PROGRAM        */
/**********************************************************/
 PGM
         DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

 /*JW    OVRPRTF   FILE(QPRINT) OUTQ(LANPRT06)    */
 /*      OVRPRTF   FILE(QPRINT) OUTQ(LANPRT08)    */

/* JW1: CHECK OTHER USER IS USING  ========================================*/
         CALL       PGM(CHKC45) PARM('ALOC10' 'ALOC10' 'Y' 'CHK' &RTN1)
         IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP )
/* ========================================================================*/

         OVRDBF    FILE(ALOWP10) TOFILE(HWFILE1/ALOWP10)
         CLRPFM    HWFILE1/ALOWP10

         CALL      PGM(ALOR10)

 /*JW1*/ CALL      PGM(CHKC45) PARM(('ALOC10') ('ALOC10') ('N') ('') (''))

 @ENDP:
         ENDPGM
