             PGM

/* TCHK1     CHGLIBL    LIBL(QTEMP QGPL TFILE1 TWFILE1 QPCFSU QMGU +
                          TOBJ1 TJRN1 HSRC1 GENSTD G3X1TST    +
                          G3X1PGM) CURLIB(G3X1CUSOBJ) */
/* TCHK1 */  CHGLIBL    LIBL(QTEMP QGPL TFILE1 TWFILE1 QPCFSU QMGU +
                          TOBJ1 TJRN1 HSRC1 GENSTD G3X4TST    +
                          G3X4PGM) CURLIB(G3X1CUSOBJ)

             OVRMSGF    MSGF(QTCPMSGF) TOMSGF(QTCP/QTCPMSGF)

             CHGJOB     OUTQ(EDIOUTQ)
             J M


             ENDPGM
