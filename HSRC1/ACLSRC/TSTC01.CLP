 PGM
             SNDDST     TYPE(*FILE) TOINTNET((AKIRA.OHSHIMA@iafi.com)) +
                          DSTD('EDI Delivery date error') MSG('EDI +
                          Order data contains past delivery dates. +
                          Please check the attached list and +
                          contact the customer if necessary.') +
                          DOCFILE(HWFILE1/MBDWPT2) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI delivery date error')

             ENDPGM
