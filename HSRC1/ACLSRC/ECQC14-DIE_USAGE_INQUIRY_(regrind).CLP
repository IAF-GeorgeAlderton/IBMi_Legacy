             PGM
             /** ECQC15 **********************************/
             /* DIE USAGE INQUIRY                  */
             /* PROGRAM ID. : ECQC15. <CLP> */
             /* CREATE DATE.  04/01/05                   */
             /* AUTHOR.    TCH  REGRIND   TCH56          */
             /* JW1  2021.01.06 ADD CLRPFM ECQWP15       */
             /* JW2  2024.06.05 ADD EXCLUSIVE CHECK      */
             /********************************** ECQC15 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1)

/* JW2 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('ECQC14' 'ECQC14' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO ENDP)
/* =================================================================*/

             RTVJOBA    USER(&USER)
 /*JW1*/     CALL       PGM(ALBC00) PARM(&USER &WLIB)

 /*JW1*/     CLRPFM     FILE(&WLIB/ECQWP16 )
 /*JW1*/     OVRDBF     FILE(ECQWP16 ) TOFILE(&WLIB/ECQWP16 )

       /**** CALL       PGM(ECQR14) ****/
             CALL       PGM(ECQR14A)

/*JW2 END CHECK ====================================================*/
             CALL CHKC45 ('ECQC14' 'ECQC14' 'N'  '' '')
/* =================================================================*/

ENDP:
             ENDPGM
