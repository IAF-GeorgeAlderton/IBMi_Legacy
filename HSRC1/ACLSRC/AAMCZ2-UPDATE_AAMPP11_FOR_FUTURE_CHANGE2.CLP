PGM

             CRTFLR     FLR(TEST)
             MONMSG     MSGID(CPF8A18)

             CPYTOPCD   FROMFILE(AAMWPZ1) TOFLR(TEST) +
                          TODOC(AAMWPZ1.CSV) REPLACE(*YES)

      /*     SNDDST     TYPE(*DOC) +
                          TOINTNET(('SAKASHITA.TOMOKIYO@AOYAMAGRP.COM+
                          ')) DSTD('DSTS') MSG('AAMCZ1 RESULTS') +
                          DOC(AAMWPZ1.CSV) FLR('TEST') */
      /*     MONMSG     MSGID(CPF0000) */
             SNDDST     TYPE(*DOC) +
                          TOINTNET(('SAKAKI.TAKASHI@AOYAMAGRP.COM')) +
                          DSTD('DSTS') MSG('AAMCZ1 RESULTS') +
                          DOC(AAMWPZ1.CSV) FLR('TEST')
             MONMSG     MSGID(CPF0000)

      /*     SNDDST     TYPE(*DOC) +
                          TOINTNET(('ATSUO.MAMIYA@IAFI.COM')) +
                          DSTD('DSTS') MSG('AAMCZ1 RESULTS') +
                          DOC(AAMWPZ1.CSV) FLR('TEST')     */

             SNDDST     TYPE(*DOC) +
                          TOINTNET(('TAKANAO.KATO2@IAFI.COM')) +
                          DSTD('DSTS') MSG('AAMCZ1 RESULTS') +
                          DOC(AAMWPZ1.CSV) FLR('TEST')

ENDPGM
