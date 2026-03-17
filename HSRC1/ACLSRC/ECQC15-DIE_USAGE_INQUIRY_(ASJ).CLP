             PGM
             /** ECQC15 **********************************/
             /* DIE USAGE INQUIRY                  */
             /* PROGRAM ID. : ECQC15. <CLP> */
             /* CREATE DATE. : MAY.06,'02.               */
             /* AUTHOR.         : TCH                    */
             /* JW1  2021.01.06 ADD CLRPFM ECQWP15       */
             /********************************** ECQC15 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1)

/* JW2 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('ECQC15' 'ECQC15' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO ENDP)
/* =================================================================*/

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(&WLIB/ECQWP15 )
             OVRDBF     FILE(ECQWP15 ) TOFILE(&WLIB/ECQWP15 )

             CALL       PGM(ECQR15)

/*JW2 END CHECK ====================================================*/
             CALL CHKC45 ('ECQC15' 'ECQC15' 'N'  '' '')
/* =================================================================*/

ENDP:        ENDPGM
