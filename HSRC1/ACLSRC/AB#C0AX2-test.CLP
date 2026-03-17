 PGM
/** AB#C0A ************************************************/

             CPYSPLF    FILE(QPRINT2) TOFILE(HWFILE1/PRT132A) +
                          JOB(352431/EDIUSER/EDIWEEKPRD) SPLNBR(2103)

             OVRDBF     FILE(PRT132) TOFILE(PRT132A)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((kaz.watanabe@iafi.com)) +
                          DSTD('EDI Order quantity difference') +
                          MSG('EDI Order data contains different +
                          quantity or Ship Date from the previous +
                          order. Please check the attached list and +
                          change the order data manually if +
                          needed.') DOCFILE(HWFILE1/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('EDI +
                          Order quantity difference')

ENDP:        ENDPGM
