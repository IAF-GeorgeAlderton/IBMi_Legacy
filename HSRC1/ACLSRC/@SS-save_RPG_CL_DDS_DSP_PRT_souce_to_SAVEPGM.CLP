/* COPY TO SAVEPGM                                                  */

             PGM        PARM(&N &F &L)

             DCL        VAR(&N)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&F)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&L)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRC) TYPE(*CHAR) LEN(3)

             CHGVAR     VAR(&SRC) VALUE(%SST(&F 2 3))

/* RPG */
             IF         COND(&SRC *EQ 'RPG') THEN(DO)
             CPYF       FROMFILE(&L/&F) TOFILE(SAVEPGM/QRPGSRC) +
                          FROMMBR(&N) TOMBR(&N) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             GOTO       CMDLBL(#END)
             ENDDO
/* CLP */
             IF         COND(&SRC *EQ 'CLS') THEN(DO)
             CPYF       FROMFILE(&L/&F) TOFILE(SAVEPGM/QCLSRC) +
                          FROMMBR(&N) TOMBR(&N) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             GOTO       CMDLBL(#END)
             ENDDO
/* PRTF */
             IF         COND(&SRC *EQ 'PRT') THEN(DO)
             CPYF       FROMFILE(&L/&F) TOFILE(SAVEPGM/QPRTSRC) +
                          FROMMBR(&N) TOMBR(&N) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             GOTO       CMDLBL(#END)
             ENDDO
/* DSPF */
             IF         COND(&SRC *EQ 'DSP')  THEN(DO)
             CPYF       FROMFILE(&L/&F) TOFILE(SAVEPGM/QDSPSRC) +
                          FROMMBR(&N) TOMBR(&N) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             GOTO       CMDLBL(#END)
             ENDDO
/* DDS */
             IF         COND((&SRC *EQ 'DDS') *OR (&SRC *EQ 'LF')) +
                          THEN(DO)
             CPYF       FROMFILE(&L/&F) TOFILE(SAVEPGM/QDDSSRC) +
                          FROMMBR(&N) TOMBR(&N) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             GOTO       CMDLBL(#END)
             ENDDO
/* OTHER */
             CPYF       FROMFILE(&L/&F) TOFILE(SAVEPGM/QOTHSRC) +
                          FROMMBR(&N) TOMBR(&N) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)

#END:        ENDPGM
