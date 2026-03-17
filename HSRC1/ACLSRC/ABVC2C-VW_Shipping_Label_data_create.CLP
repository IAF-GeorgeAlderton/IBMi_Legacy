             PGM
             /** ABVC2C ***********************************************/
             /*  VW Shipping Label data create   .                    */
             /*                                                       */
             /* TCHK  11/26/13 CREATE                                 */
             /* JW1   2020.1112 ADD SAVE                              */
             /*********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)

             OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CLRPFM     FILE(HWFILE1/ABVWP2E)
             CLRPFM     FILE(HWFILE1/ABVWP2F)

             CALL       PGM(ABVR2C) PARM(&USER)

/*JW1 SAVE ABVWP2E/2F TO ABVWP2ES/2FS **/
             CALL       PGM(EDSR67)

  END:
             ENDPGM
