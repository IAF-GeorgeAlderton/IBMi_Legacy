             PGM
             /** A$AAA  **********************************************/
             /*  TEST CLP FOR VS CODE                                */
             /*  J.WATANABE 2025.07.03                               */
             /*  ｲｳｴｵｶｷｸ ｹｻｼｽｾｿﾀ ﾁﾂﾄﾊﾐﾔﾕ ﾖﾗﾘﾙﾚ                       */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((PﾊﾁｵﾕｴﾔｻﾁﾀCﾁﾀﾔﾊﾁｾ@ｻｲｷｻ.ｴﾁｿ) +
                          (JONATHON.JULSON@IAFI.COM)) DSTD('SEND +
                          ASN ASAP') MSG('PRODUCTION CONTROL, +
                          PLEASE SEND ASN AS SOON AS POSSIBLE. +
                          (CHKC51A).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) +
                          DOCD('MISSING ASN')
             DLTOVR     FILE(PRT132)

             ENDPGM
