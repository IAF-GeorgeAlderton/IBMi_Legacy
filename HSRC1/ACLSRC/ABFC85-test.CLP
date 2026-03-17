             PGM        PARM(&XDATE)
             /** ABFC80 ****************************************/
             /*  PRINT FORECAST VS SALES (%) REPORT            */
             /*  JW     2018.07.06                             */
             /**************************************************/
             DCL        VAR(&XDATE)    TYPE(*CHAR) LEN(8)

             CLRPFM     FILE(*LIBL/ABFWP82)
             CALL       PGM(ABFR85) PARM(&XDATE)
END:
             ENDPGM
