             PGM


             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

 /*  delete SCS results file....                              */
             DLTF       FILE(HWFILE1/SCSRESULTS)
             MONMSG     MSGID(CPF0000)


             RDBIMPORT  STM('select * from +
                          dbo.manifest_label_scan_sync_trigger') +
                          SERVER(IAFSCS) OUTFILE(HWFILE1/SCSRESULTS)

             RUNQRYY    QRYFILE((SCSRESULTS))

             RMVLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

             ENDPGM
