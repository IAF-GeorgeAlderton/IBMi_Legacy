             PGM
             /** AIAC13 ******* ******************************/
             /* M/F TRANSMISSION CHECK                             */
             /*          TCH 01/13/2005                      */
             /************************************************/
             DCL        VAR(&ID)   TYPE(*CHAR) LEN(1)

             CALL       PGM(AIAR13) PARM(&ID)
             IF         COND(&ID *EQ '1') THEN(DO)
             SNDDST     TYPE(*LMSG) TOINTNET((APIC@iafi.com)) +
                          DSTD('M/F transmission') LONGMSG('You +
                          need to transmit M/F on Apics PC for +
                          today. (F7 on Apics PC). (AIAC13)') +
                          DOCD('M/F transmission check') +
                          DOCDATE(*CURRENT) ACTDATE(*CURRENT)
             ENDDO

             ENDPGM
