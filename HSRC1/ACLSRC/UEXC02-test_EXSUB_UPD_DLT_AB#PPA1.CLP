             /** UEXC02 ***********************************************/
             /*  TEST - EXSUB - UPD/DLT AB#PPA1   DAYS                */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&POPT  ) TYPE(*CHAR) LEN(08)   VALUE('U')
             DCL        VAR(&PANONY) TYPE(*DEC ) LEN(04 0) VALUE(8810)
             DCL        VAR(&PANKOJ) TYPE(*CHAR) LEN(01)   VALUE('0')
             DCL        VAR(&PANUKE) TYPE(*CHAR) LEN(04)   VALUE('00  ')
             DCL        VAR(&PANOHZ) TYPE(*DEC ) LEN(08 0) VALUE(20170803)
             DCL        VAR(&PANOBN) TYPE(*DEC ) LEN(02 0) VALUE(02)
             DCL        VAR(&PAODRN) TYPE(*CHAR) LEN(10)   VALUE('000001')
             DCL        VAR(&PAMHIN) TYPE(*CHAR) LEN(20)   VALUE('90412A0004')
             DCL        VAR(&PAFROM) TYPE(*CHAR) LEN(10)   VALUE('AB#R1H')
             DCL        VAR(&PAFIL1) TYPE(*CHAR) LEN(10)   VALUE('FIL1')
             DCL        VAR(&PAFIL2) TYPE(*CHAR) LEN(10)   VALUE('FIL2')
             DCL        VAR(&PAFIL3) TYPE(*CHAR) LEN(10)   VALUE('FIL3')
             DCL        VAR(&PRTN  ) TYPE(*CHAR) LEN(01)

             CALL       PGM(UEXR02) PARM(&POPT &PANONY &PANKOJ +
                          &PANUKE &PANOHZ &PANOBN &PAODRN &PAMHIN +
                          &PAFROM &PAFIL1 &PAFIL2 &PAFIL3 &PRTN)

 END:        ENDPGM
