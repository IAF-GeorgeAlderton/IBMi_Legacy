             PGM        PARM(&TO &FIL &LIB &DSC &MSG)
             /** APLC33 ******************************************/
             /*  IAF MAIL SEND                                   */
             /*  J.WATANABE  2018.10.01                          */
             /*  SEND MAIL USING SNDDST                          */
             /****************************************************/
             DCL        VAR(&TO )   TYPE(*CHAR) LEN(30)
             DCL        VAR(&FIL )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DSC )  TYPE(*CHAR) LEN(30)
             DCL        VAR(&MSG)   TYPE(*CHAR) LEN(30)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)

             IF         COND(&TO   *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&FIL  *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&LIB  *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&DSC  *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&MSG  *EQ *BLNAK) THEN(GOTO CMDLBL(@END))

       /* RETRIEVE USER ID */
             RTVJOBA    USER(&US)
             QSYS/ADDDIRE USRID(&US SYSTEM6) USRD(&US) USER(&US) SYSNAME(IAF)
             MONMSG     MSGID(CPF9082)

             SNDDST     TYPE(*FILE) TOINTNET((&TO)) MSG(&MSG) +
                          DOCFILE(&LIB/&FIL) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&DSC)
 @END:
             ENDPGM
