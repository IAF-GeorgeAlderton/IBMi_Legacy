PGM
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('T-SAKASHITA@ASJ-FASTENERS.CO.JP'+
                          )) DSTD('ORDER ABOVE SETTING NUMBER') +
                          MSG('WE RECEIVED THE ORDER WHICH HAS +
                          ABOVE SETTING NUMBER. CHECK THE ATTACHED +
                          LIST. (TSKC07)') DOCFILE(HFILE1/GADPP11) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('ORDER +
                          ABOVE SETTING NUMBER')
ENDPGM
