             PGM        PARM(&TO &MSG &LIB &FIL &DSC1 &DSC2)
             /** APLC33 ******************************************/
             /*  IAF MAIL SEND                                   */
             /*  J.WATANABE  2018.10.01                          */
             /*  SEND MAIL USING SNDDST                          */
             /****************************************************/
             DCL        VAR(&TO )   TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&LIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DSC1)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&DSC2)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)

             IF         COND(&TO   *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&MSG  *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&LIB  *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&FIL  *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&DSC1 *EQ *BLNAK) THEN(GOTO CMDLBL(@END))
             IF         COND(&DSC2 *EQ *BLNAK) THEN(GOTO CMDLBL(@END))

       /* RETRIEVE USER ID */
             RTVJOBA    USER(&US)
             QSYS/ADDDIRE USRID(&US SYSTEM6) USRD(&US) USER(&US) SYSNAME(IAF)
             MONMSG     MSGID(CPF9082)

             SNDDST     TYPE(*FILE) TOINTNET((&TO)) DSTD(&DSC1) +
                          MSG(&MSG) DOCFILE(&LIB/&FIL) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&DSC2)
 @END:
             ENDPGM
