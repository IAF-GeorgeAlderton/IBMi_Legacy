             /** UEXC01 ***********************************************/
             /*  TEST - EXSUB - UPD/DLT AB#PPA1   DAYS                */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&ZAIS) TYPE(*CHAR) LEN(15) +
                          VALUE('AISI1021KD-B   ')
             DCL        VAR(&ZAIK  ) TYPE(*DEC ) LEN(5 2)  VALUE(6.35)
             DCL        VAR(&MSET  ) TYPE(*DEC ) LEN(8 0)  VALUE(971)
             DCL        VAR(&CWGT  ) TYPE(*DEC ) LEN(5 0)  VALUE(1000)
             DCL        VAR(&SCOE  ) TYPE(*DEC ) LEN(3 2)  VALUE(1.1)
             DCL        VAR(&LT    ) TYPE(*DEC ) LEN(3 0)  VALUE(7)
             DCL        VAR(&LOT   ) TYPE(*DEC ) LEN(2 0)  VALUE(1)
             DCL        VAR(&ADJ   ) TYPE(*DEC ) LEN(3 0)  VALUE(0)
             DCL        VAR(&KQTY  ) TYPE(*DEC ) LEN(3 0)  VALUE(0)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1  )  VALUE(' ')

             CALL       PGM(UEXR24) PARM(&ZAIS &ZAIK &MSET &CWGT &SCOE +
                          &LT &LOT &ADJ &KQTY &RTN)

             ENDPGM
