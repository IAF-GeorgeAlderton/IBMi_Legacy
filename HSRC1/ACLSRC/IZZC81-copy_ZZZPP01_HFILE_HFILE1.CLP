             PGM        PARM(&Z1FILE)
             /** IZZC81 *************************/
             /*  ZZZPP01 HFILE ==> HFILE1 CPYF  */
             /*   I-HASADA           97.04.05   */
             /************************* IZZC81 **/
             DCL        VAR(&Z1FILE) TYPE(*CHAR) LEN(10)

             CPYF       FROMFILE(HFILE/&Z1FILE) +
                          TOFILE(HFILE1/&Z1FILE) MBROPT(*REPLACE) +
                          FMTOPT(*DROP *MAP)
             MONMSG     MSGID(CPF2817)

             ENDPGM
