             PGM        PARM(&SYS)

             DCL        VAR(&SYS)   TYPE(*CHAR) LEN(3)

             IF         COND(&SYS *EQ 'ATC') THEN(DO)

             RSTOBJ     OBJ(*ALL) SAVLIB(ATCFILE) DEV(*SAVF) +
                          SAVF(ATCFILE/TRNCIFSAVF)

          /* ATCFILE/DA#PPIF(NEW) -> DA#PPAT */
             OVRDBF     FILE(DA#PPIF) TOFILE(ATCFILE/DA#PPIF)
             CALL       PGM(DA#RIF)
          /* ATCFILE/DA#PPIF(UPDATE & DELETE) -> DA#PPAT */
             CALL       PGM(DA#RIG)

             ENDDO

             SNDMSG     MSG('RCV FROM ' *CAT &SYS) TOMSGQ(HPIS1)

             ENDPGM
