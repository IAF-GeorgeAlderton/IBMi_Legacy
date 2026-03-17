             PGM        PARM(&ADDR &MSG &RE)
             /*= SNDC01 ====================================================*/
             /*  SIMPLE SNDDST                                              */
             /*  J.WATANABE     2018.08.23                                  */
             /*  --------------                                             */
             /*  &TYPE(1A) = 1, ONE FIELD / RECORD (TXT DATA WITH COMMA)    */
             /*=============================================================*/
             DCL        VAR(&ADDR) TYPE(*CHAR) LEN(30)
             DCL        VAR(&MSG ) TYPE(*CHAR) LEN(30)
             DCL        VAR(&RE  ) TYPE(*CHAR) LEN(20)

             SNDDST     TYPE(*LMSG) TOINTNET((&ADDR)) DSTD('DSTD') +
                          LONGMSG(&MSG) DOCD(&RE)

             MONMSG     MSGID(CPF0000)

             ENDPGM
