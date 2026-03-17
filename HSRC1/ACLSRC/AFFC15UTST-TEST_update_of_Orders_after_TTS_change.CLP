             PGM
             DCL        VAR(&EFFDAT) TYPE(*DEC) LEN(8 0) +
                          VALUE(20230601)

/*  update orders received before eff date & ship date after eff date*/
                        CALL       PGM(AFFR15U) PARM(&EFFDAT)

             ENDPGM
