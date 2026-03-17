             PGM        PARM(&XDATE)
             /** ABFC80 ****************************************/
             /*  PRINT FORECAST VS SALES (%) REPORT            */
             /*  JW     2018.07.06                             */
             /**************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&XDATE)    TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

         /*  CHGVAR     VAR(&XDATE ) VALUE('201806') */

                 CLRPFM     FILE(*LIBL/ABFWP80)
                 CLRPFM     FILE(*LIBL/ABFWP81)
                 CLRPFM     FILE(*LIBL/ABFWP82)
/* SUMMAIZE  */
                 CALL       PGM(ABFR83) PARM(&XDATE)
/* PRINT     */
                 CALL       PGM(ABFR84) PARM(&XDATE)
/* PRINT     */
                 CALL       PGM(ABFR85) PARM(&XDATE)
END:
             ENDPGM
