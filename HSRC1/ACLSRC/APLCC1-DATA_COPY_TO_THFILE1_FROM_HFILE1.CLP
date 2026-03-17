             PGM        PARM(&FILE)
             /**** APLCC1 *****************************************/
             /* DATA COPY TO THFILE1 FROM HFILE1                  */
             /* T.SAKASHITA 2020.10.05                            */
             /*****************************************************/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)

             CPYF       FROMFILE(HFILE1/&FILE) TOFILE(TFILE1/&FILE) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
             ENDPGM
