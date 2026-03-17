             /** UEXC01 ***********************************************/
             /*  TEST - EXSUB - UPD/DLT AB#PPA1   DAYS                */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&POPT  ) TYPE(*CHAR) LEN(08)   VALUE('D')
             DCL        VAR(&PANONY) TYPE(*DEC ) LEN(04 0) VALUE(8810)
             DCL        VAR(&PANKOJ) TYPE(*CHAR) LEN(01)   VALUE('0')
             DCL        VAR(&PANUKE) TYPE(*CHAR) LEN(04)   VALUE('00  ')
             DCL        VAR(&PANOHZ) TYPE(*DEC ) LEN(08 0) VALUE(20170803)
             DCL        VAR(&PANOBN) TYPE(*DEC ) LEN(02 0) VALUE(01)
             DCL        VAR(&PAODRN) TYPE(*CHAR) LEN(10)   VALUE('000001')
             DCL        VAR(&PAMHIN) TYPE(*CHAR) LEN(20)   VALUE('90412A0004')
             DCL        VAR(&PAKOME) TYPE(*CHAR) LEN(10)   VALUE('DLT_ID')
             DCL        VAR(&PASRYO) TYPE(*DEC ) LEN(10 0) VALUE(0)
             DCL        VAR(&PASYOS) TYPE(*DEC ) LEN(06 0) VALUE(0)
             DCL        VAR(&PAPGM ) TYPE(*CHAR) LEN(10)   VALUE('DLT_PGM')
             DCL        VAR(&PARESE) TYPE(*CHAR) LEN(04)   VALUE('DLT#')
             DCL        VAR(&PRTN  ) TYPE(*CHAR) LEN(01)

             CALL       PGM(UEXR01) PARM(&POPT &PANONY &PANKOJ +
                          &PANUKE &PANOHZ &PANOBN &PAODRN &PAMHIN +
                          &PAKOME &PASRYO &PASYOS &PAPGM  &PARESE +
                          &PRTN)

 END:        ENDPGM
