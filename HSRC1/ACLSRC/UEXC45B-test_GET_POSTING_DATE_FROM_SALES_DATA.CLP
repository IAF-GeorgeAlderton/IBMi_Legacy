             PGM
             /** UEXC45B **********************************************/
             /*  GET POSTING DATE FROM SALES DATA     E               */
             /*-------------------------------------------------------*/

             DCL        VAR(&NONY   ) TYPE(*CHAR) LEN(4)  VALUE('3503')
             DCL        VAR(&NOHZ   ) TYPE(*CHAR) LEN(8)  VALUE('20201026')
             DCL        VAR(&BIN    ) TYPE(*CHAR) LEN(2)  VALUE('04')
             DCL        VAR(&NKOJ   ) TYPE(*CHAR) LEN(1)  VALUE('B')
             DCL        VAR(&NUKE   ) TYPE(*CHAR) LEN(4)  VALUE('5A')
             DCL        VAR(&ODRN   ) TYPE(*CHAR) LEN(10) VALUE('D0303X01')
             DCL        VAR(&POHZ   ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&POTM   ) TYPE(*CHAR) LEN(6)

             CALL       PGM(UEXR45B) PARM(&NONY &NOHZ &BIN &NKOJ +
                          &NUKE &ODRN &POHZ &POTM)

             ENDPGM
