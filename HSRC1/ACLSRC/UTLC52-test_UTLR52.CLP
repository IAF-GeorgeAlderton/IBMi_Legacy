             PGM        PARM(&NONY)
             /** UTLC52  ***************************************/
             /**************************************************/

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PTYP  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCPY  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CTYP  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CCPY  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CNAM  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LTYP  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LCPY  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MCPY  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUPP  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BMAX  ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TRAN  ) TYPE(*CHAR) LEN(30)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR52) PARM((&NONY) (&PTYP) (&PCPY) +
                          (&CTYP) (&CCPY) (&CNAM) (&LTYP) (&LCPY) +
                          (&MCPY) (&SUPP) (&BMAX) (&TRAN) (&RTN))

             ENDPGM
