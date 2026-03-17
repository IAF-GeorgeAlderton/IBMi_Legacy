     /** FIXDTA ******************************************************/
     /*  FIX FILE DATA                                               */
     /*  IAF IT   2024.08.16                                         */
     /****************************************************************/
             CMD        PROMPT('FIX FILE DATA')
             PARM       KWD(FILE) TYPE(FILE_L) MIN(1) PROMPT('FILE')
 FILE_L:     QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('LIBRARY')

             PARM       KWD(MBR) TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST)) PROMPT('MEMBER')

             PARM       KWD(SEQ) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*SEQ) VALUES(*SEQ *KEY) PROMPT('SORT +
                          SEQ: *SEQ or *KEY')

             PARM       KWD(OPT1) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(1) VALUES(1 2) PROMPT('VIEW RECORD +
                          1:SINGLE, 2:MULTI')

             PARM       KWD(OPT2) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(3) VALUES(1 2 3 4) PROMPT('VIEW +
                          1:CHAR,2:HEX,3:FLD,4:COL')

             PARM       KWD(IGCCHK) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(1) VALUES(1 2) PROMPT('CHECK SHIFT +
                          1:YES, 2:NO')

             PARM       KWD(FOLD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(1) VALUES(1 2) PROMPT('PRINT WRAP  +
                          1:YES, 2:NO')
