             PGM
             /** GDIC82 ************************/
             /*  PRINT SCANED DATA FOR DIE     */
             /*  N.HYOTO 2001.03.12            */
             /**********************************/

             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)
             RTVJOBA    DATE(&SDATE)

             OVRPRTF    FILE(QPQUPRFIL) TOFILE(QPQUPRFIL) +
                          PAGESIZE(66 80) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) HOLD(*NO)

             RUNQRY     QRY(HOBJ1/QGDIPP01) RCDSLT(*YES)


 END:        ENDPGM
