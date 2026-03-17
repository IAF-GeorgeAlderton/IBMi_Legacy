             PGM        PARM(&UPD)
             /** MBDC77 **********************/
             /*  TEST CL                     */
             /********************************/

             DCL        VAR(&UPD) TYPE(*CHAR) LEN(1)

             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(6) CPI(15) +
                          OVRFLW(60) OUTQ(WATAOUTQ) FORMTYPE(K6H1)

             CALL       PGM(MBDR77) PARM(&UPD)

             ENDPGM
