             PGM

/* TCHK1     CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
                          HOBJ1 HJRN1 HSRC1 GENSTD G3X1DTA G3X1PGM) +
                          CURLIB(G3X1CUSOBJ) */

/* TCHK2     CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
   TCHK1                  HOBJ1 HJRN1 HSRC1 GENSTD G3X4DTA G3X4PGM) +
                          CURLIB(G3X1CUSOBJ) */

             CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
                          HOBJ1 HJRN1 HSRC1 G3X6DTA G3X6PGM) +
                          CURLIB(G3X1CUSOBJ) /* TCHK3 */

             OVRMSGF    MSGF(QTCPMSGF) TOMSGF(QTCP/QTCPMSGF)

             CHGJOB     OUTQ(EDIOUTQ)
             J M


             ENDPGM
