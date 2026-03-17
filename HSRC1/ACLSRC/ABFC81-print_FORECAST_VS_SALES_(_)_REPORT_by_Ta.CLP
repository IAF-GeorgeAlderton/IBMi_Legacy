             PGM        PARM(&TGT &PRINT)
             /** ABFC81 ****************************************/
             /*  PRINT FORECAST VS SALES (%) REPORT            */
             /*  JW     2018.07.06                             */
             /**************************************************/
             DCL        VAR(&TGT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
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
                 CALL       PGM(ABFR82) PARM(&TGT  )

/* FORD FC   */
                 CALL       PGM(ABFR81) PARM(&TGT  )

/* HONDA FC  */
                 CALL       PGM(ABFR80) PARM(&TGT  )

/* SUMMAIZE  */
                 CALL       PGM(ABFR83) PARM(&TGT  )

/* PRINT ==WEEK== */
           /*    CALL       PGM(ABFR84) PARM(&TGT &PRINT)   */

/* PRINT ==DAY== */
                 CALL       PGM(ABFR85) PARM(&TGT &PRINT)

             ENDPGM
