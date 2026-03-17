             PGM        PARM(&TGT &PRINT)
             /** ABFC80 ****************************************/
             /*  PRINT FORECAST VS SALES (%) REPORT            */
             /*  JW     2018.07.06                             */
             /**************************************************/

             DCL        VAR(&TGT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRINT) TYPE(*CHAR) LEN(1)

 /* PRINT   */
             RTVJOBA    USER(&USER)
             IF         COND(&USER *NE 'I0777') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03)
             ENDDO

             CLRPFM     FILE(*LIBL/ABFPP80)
             CLRPFM     FILE(*LIBL/ABFWP80)
             CLRPFM     FILE(*LIBL/ABFWP81)
             CLRPFM     FILE(*LIBL/ABFWP82)
/* MANUAL FC */
                        /***CALL       PGM(ABFR92) PARM(&TGT)***/
/* FORD FC   */
                        /***CALL       PGM(ABFR91) PARM(&TGT)***/
/* HONDA FC (ABFPP80) */
                            CALL       PGM(ABFR90) PARM(&TGT)
/* SUMMAIZE  */
                            CALL       PGM(ABFR93) PARM(&TGT)
/* SELECTION */
                            CALL       PGM(ABFR95) PARM(&TGT &PRINT)
END:
             ENDPGM
