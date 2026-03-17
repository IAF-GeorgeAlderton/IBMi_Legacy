             PGM PARM(&PTYPE &PPICK &PSIRE &PNOHZ &PNOBI &PWEIG)
             /** AB#CSK **********************************************/
             /*  SERVICE PARTS PICK UP LIST                          */
             /********************************************** AB#C3P **/
             DCL        VAR(&PPICK) TYPE(*DEC) LEN(2)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNOBI) TYPE(*DEC) LEN(1)
             DCL        VAR(&PWEIG) TYPE(*DEC) LEN(3 2)
             DCL        VAR(&PMANI) TYPE(*CHAR) LEN(18)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&US)


             IF         COND((&PTYPE *EQ '01') *OR +
                             (&PTYPE *EQ '07')) THEN(DO)
             CALL       PGM(AB#RSG) PARM(&PWEIG)
             ENDDO

             IF         COND(&PTYPE *EQ '02') THEN(DO)
             /* GET THE MANIFEST NUMBER */
             CALL       PGM(AB#R95) PARM(&US &PSIRE &PNOHZ &PNOBI &PMANI)
             CALL       PGM(AB#RSB) PARM(&PWEIG &PMANI)
             ENDDO

             IF         COND(&PTYPE *EQ '03') THEN(DO)
             CALL       PGM(AB#RSC) PARM(&PWEIG)
             ENDDO

             IF         COND(&PTYPE *EQ '04') THEN(DO)
             CALL       PGM(AB#RSD) PARM(&PWEIG)
             ENDDO

             IF         COND(&PTYPE *EQ '05') THEN(DO)
             CALL       PGM(AB#RSE) PARM(&PWEIG)
             ENDDO

             IF         COND(&PTYPE *EQ '06') THEN(DO)
             CALL       PGM(AB#RSF) PARM(&PWEIG)
             ENDDO

             IF         COND(&PTYPE *EQ '08') THEN(DO)
             CALL       PGM(AB#RSJ) PARM(&PWEIG)
             ENDDO

             IF         COND(&PTYPE *EQ '09') THEN(DO)
             CALL       PGM(AB#R95) PARM(&US &PSIRE &PNOHZ &PNOBI &PMANI)
             CALL       PGM(AB#RSA) PARM(&PWEIG &PMANI)
             ENDDO

             IF         COND(&PTYPE *EQ '10') THEN(DO)

             CALL       PGM(AB#R95) PARM(&US &PSIRE &PNOHZ &PNOBI &PMANI)

             CALL       PGM(AB#RSK) PARM(&PWEIG &PMANI)
             ENDDO

 END:        ENDPGM
