             PGM
             /*** GBFCP6 ************************************/
             /* SALES UNIT PRICE ESTIMATE CONSTITUTION      */
             /* PRIMITIVE COST TOTALIZATION BY ITEM         */
             /*         M-OKUDA         1986.01.14          */
             /***********************************************/
 STEP14:
             CLRPFM     FILE(GBFWP76)
             CALL       PGM(GBFR99)
             OVRPRTF    FILE(GBFPR77) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR77) PARM('3411' '1' '0' '***')
             DLTOVR     FILE(GBFPR77)
 ENDEND:     ENDPGM
