             /** UEXC01 ***********************************************/
             /*  TEST - EXSUB - UPD/DLT AB#PPA1   DAYS                */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&ZAIS  ) TYPE(*CHAR) LEN(15)   VALUE('AISI1021KD-B')
             DCL        VAR(&ZAIK  ) TYPE(*DEC ) LEN(5 2)  VALUE(5.23)
             DCL        VAR(&KQTY  ) TYPE(*DEC ) LEN(3 0)  VALUE(0)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1  )  VALUE(' ')

             CALL       PGM(UEXR25) PARM(&ZAIS &ZAIK &KQTY &RTN)

             ENDPGM
