             PGM
             /** ABMCH1 ************************/
             /*  SUPPLIER ORDER WARNING LIST   */
             /*   HOTTA.           2018.11.01  */
             /**********************************/
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WSID ) TYPE(*CHAR) LEN(10)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             OVRPRTF    FILE(ABMPRH2) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) CPI(15) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) FORMTYPE(K6H1) IGCDTA(&PIGCD)

             CALL       PGM(ABMRH2)


 END:        ENDPGM
