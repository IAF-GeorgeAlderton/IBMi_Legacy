 /*   *********************************************************************** */
 /*   * PROGRAM  : SCHEDULE  11/21/2002                                       */
 /*   *********************************************************************** */
 SCHEDULE:    PGM

             CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
                          HOBJ1 HJRN1 HSRC1 G3X6DTA G3X6PGM ) +
                          CURLIB(G3X1CUSOBJ) /* TCHK1 */
 END:
             OVRPRTF    FILE(QPRINT) OUTQ(SAKAKI)
             PRGCHF     DATE(*DAYS) PRGTAP(*NONE) DAYS(7) /* TCHK4 */

             ENDPGM

