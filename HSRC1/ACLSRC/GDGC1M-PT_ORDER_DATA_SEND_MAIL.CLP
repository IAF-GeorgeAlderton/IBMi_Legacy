             PGM
             /*** GDGC1M **********************************/
             /*  PT ORDER DATA SEND MAIL                  */
             /*  Y.MAEDA 2019.09.12                       */
             /*  J.WATA  2021.01.15 ADD MR KATO           */
             /*********************************************/
             DCL        VAR(&POADRS) TYPE(*CHAR) LEN(50)
             CALL       PGM(GDGR1M) PARM(&POADRS)
             CPYTOPCD   FROMFILE(HWFILE1/GDGWP13IAF) TOFLR(PT_ORDER) +
                          TODOC(PT_ORD_S.CSV) REPLACE(*YES)

             SNDDST     TYPE(*DOC) TOINTNET((ATSUO.MAMIYA@IAFI.COM)) +
                          DSTD('DSTS') MSG('SEND PT ORDER +
                          DATA(FASTENERS)') DOC(PT_ORD_S.CSV) +
                          FLR('PT_ORDER')

             SNDDST     TYPE(*DOC) +
                          TOINTNET(('SAKASHITA.TOMOKIYO@AOYAMAGRP.COM'+
                          )) DSTD('DSTS') MSG('SEND PT ORDER +
                          DATA(FASTENERS)') DOC(PT_ORD_S.CSV) +
                          FLR('PT_ORDER')

 /*JW1*/     SNDDST     TYPE(*DOC) +
                          TOINTNET((Takanao.Kato2@iafi.com)) +
                          DSTD('DSTS') MSG('SEND PT ORDER +
                          DATA(FASTENERS)') DOC(PT_ORD_S.CSV) +
                          FLR('PT_ORDER')

             CPYTOPCD   FROMFILE(HWFILE1/GDIWP13IAF) TOFLR(PT_ORDER) +
                          TODOC(PT_ORD_K.CSV) REPLACE(*YES)

             SNDDST     TYPE(*DOC) TOINTNET((ATSUO.MAMIYA@IAFI.COM)) +
                          DSTD('DSTS') MSG('SEND PT ORDER +
                          DATA(DIE)') DOC(PT_ORD_K.CSV) FLR('PT_ORDER')

             SNDDST     TYPE(*DOC) +
                          TOINTNET(('SAKASHITA.TOMOKIYO@AOYAMAGRP.COM'+
                          )) DSTD('DSTS') MSG('SEND PT ORDER +
                          DATA(DIE)') DOC(PT_ORD_K.CSV) FLR('PT_ORDER')

 /*JW1*/     SNDDST     TYPE(*DOC) +
                          TOINTNET((Takanao.Kato2@iafi.com)) +
                          DSTD('DSTS') MSG('SEND PT ORDER +
                          DATA(DIE)') DOC(PT_ORD_K.CSV) FLR('PT_ORDER')

             SNDDST     TYPE(*DOC) TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('DSTS') MSG('SEND PT ORDER +
                          DATA(DIE)') DOC(PT_ORD_K.CSV) +
                          FLR('PT_ORDER') /*JW1*/

             ENDPGM
