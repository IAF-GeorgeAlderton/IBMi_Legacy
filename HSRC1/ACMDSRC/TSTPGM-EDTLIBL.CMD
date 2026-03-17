 /*                                                                  */
 /*      �������������                                */
 /*                                                                  */
             CMD        PROMPT('�������������')
             PARM       KWD(PGM) TYPE(PGM) MIN(1) PROMPT('    +
                          呼��������')
             PARM       KWD(CRTPGM) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('    +
                          ����������� ')
             PARM       KWD(TLIB) TYPE(*CHAR) LEN(10) DFT(QTEMP) +
                          PROMPT('     TSTPGMSRC�������')
             PARM       KWD(TPGM) TYPE(*NAME) LEN(7) DFT(S_PGM) +
                          SPCVAL((S_PGM)) MIN(0) PROMPT('    +
                          ���������')
 PGM:        QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*CHAR) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('    ������')
