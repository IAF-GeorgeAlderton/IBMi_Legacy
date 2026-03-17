             PGM
             /*** GDGC1M **********************************/
             /*  PT ORDER DATA SEND MAIL TEST             */
             /*  Y.MAEDA 2019.09.12                       */
             /*********************************************/
             DCL        VAR(&POADRS) TYPE(*CHAR) LEN(50)
             CALL       PGM(GDGR1M) PARM(&POADRS)
             CPYTOPCD   FROMFILE(HWFILE1/GDGWP13IAF) TOFLR(PT_ORDER) +
                          TODOC(PT_ORD_S.CSV) REPLACE(*YES)





             SNDDST     TYPE(*DOC) +
                          TOINTNET(('T-SAKASHITA@ASJ-FASTENERS.CO.JP'+
                          ) ('STOMOKIYO@HOTMAIL.COM')) DSTD('DSTS') +
                          MSG('SEND PT ORDER DATA(FASTENERS)') +
                          DOC(PT_ORD_S.CSV) FLR('PT_ORDER')












             ENDPGM
