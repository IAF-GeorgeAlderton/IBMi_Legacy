             PGM
             /** TRNC50 ************************/
             /* SOURCE LIBRARY TRANCEFER TO IAFAYM */
             /* T.SAKASHITA      2013.03.06    */
             /************************ TRNC01 **/

             DCL        VAR(&SYS)   TYPE(*CHAR) LEN(10)
             RTVNETA    SYSNAME(&SYS)

             IF         COND(&SYS *NE 'IAF') THEN(DO)
             GOTO       CMDLBL(@JUMP)
             ENDDO

             DLTF       FILE(TRNC50SAVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/TRNC50SAVF)

             SAVLIB     LIB(HSRC1) DEV(*SAVF) +
                          SAVF(HFILE1/TRNC50SAVF) SAVACT(*SYSDFN) +
                          DTACPR(*HIGH)

             CHGJOB     OUTQ(QTCPIP)
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(TRNS50)
             STRTCPFTP  RMTSYS('172.16.8.5')
@JUMP:
             ENDPGM
