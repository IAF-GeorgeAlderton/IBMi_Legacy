             PGM
             /** APLC40 ******************************************/
             /*ADD DIRE                                          */
             /*                                                  */
             /*  Y.SAMEJIMA.........           2012.09.20        */
             /****************************************************/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&US)

             QSYS/ADDDIRE USRID(&US SYSTEM6) USRD(&US) USER(&US) +
                          SYSNAME(IAF)
             MONMSG     MSGID(CPF0000)

 @END:
             ENDPGM
