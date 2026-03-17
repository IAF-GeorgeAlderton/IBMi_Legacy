             PGM        PARM(&DATE)
/** AB#C1K ************************************************/
/*  PRINT HONDA SPLIT REPORT                              */
/*  J.WATANABE   2016.11.09                               */
/**********************************************************/

             DCL        VAR(&DATE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             OVRPRTF    FILE(QPRINT) TOFILE(*LIBL/QPRINT) +
                          PAGESIZE(78 132) LPI(8) CPI(10)
             CALL       PGM(AB#R1K) PARM(&DATE &RTN)

 END:        ENDPGM
