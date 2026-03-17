             PGM
             /** ABVC2D ***************************************************/
             /*  CREATE VW SHIPPING LABEL DATA (PACKAGE TYPE)             */
             /*  JW   2020.11.17 ADD PACKAGE TYPE (RETURNABLE/EXPENDABLE) */
             /*************************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)

             OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CLRPFM     FILE(HWFILE1/ABVWP2E)
             CLRPFM     FILE(HWFILE1/ABVWP2F)

        /**  OVRDBF     FILE(AB#PP70) TOFILE(TFILE1/AB#PP70)     **/
        /**  OVRDBF     FILE(AB#NP30) TOFILE(TFILE1/AB#NP30)     **/
        /**  OVRDBF     FILE(ABVWP2E) TOFILE(TWFILE1/ABVWP2E)    **/
        /**  OVRDBF     FILE(ABVWP2F) TOFILE(TWFILE1/ABVWP2F)    **/

             CALL       PGM(ABVR2D) PARM(&USER)

/*JW1 SAVE ABVWP2E/2F TO ABVWP2ES/2FS **/
             CALL       PGM(EDSR67)

  END:
             ENDPGM
