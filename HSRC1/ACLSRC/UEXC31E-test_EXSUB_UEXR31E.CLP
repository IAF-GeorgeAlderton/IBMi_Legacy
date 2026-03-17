             /** UEXC31E  *********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL   VAR(&TOKU  ) TYPE(*CHAR) LEN(4 )  VALUE('0391')
             DCL   VAR(&NONY  ) TYPE(*CHAR) LEN(4 )  VALUE('0286')
             DCL   VAR(&NKOJ  ) TYPE(*CHAR) LEN(1 )  VALUE('0')
             DCL   VAR(&NUKE  ) TYPE(*CHAR) LEN(4 )  VALUE('00  ')
             DCL   VAR(&SHDT  ) TYPE(*CHAR) LEN(8 )  VALUE('20240606')
             DCL   VAR(&BIN   ) TYPE(*CHAR) LEN(2 )  VALUE('03')
             DCL   VAR(&ODRN  ) TYPE(*CHAR) LEN(10)  VALUE('564235')
             DCL   VAR(&MHIN  ) TYPE(*CHAR) LEN(20)  VALUE('90160TBA A010M1')
             DCL   VAR(&ASN   ) TYPE(*CHAR) LEN(8 )  VALUE('122770  ')
             DCL   VAR(&RTN   ) TYPE(*CHAR) LEN(1 )

             CALL       PGM(UEXR31E) PARM(&TOKU &NONY &NKOJ &NUKE &SHDT &BIN +
                          &ODRN &MHIN &ASN &RTN)

             ENDPGM
