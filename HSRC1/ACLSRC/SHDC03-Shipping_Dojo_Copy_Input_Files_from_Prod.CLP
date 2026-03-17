             PGM
             /*** SHDC03 *****************************/
             /*        SHIPPING DOJO - COPY FILES    */
             /* LEC               2016.08.29         */
             /***************************** SHDC03 ***/

             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10) VALUE('HFILE1')
             DCL        VAR(&TLIB) TYPE(*CHAR) LEN(10) VALUE('TFILE1')
             DCL        VAR(&PWLIB) TYPE(*CHAR) LEN(10) VALUE('HWFILE1')
             DCL        VAR(&TWLIB) TYPE(*CHAR) LEN(10) VALUE('TWFILE1')

 /*                                                                           */
 /* ｳﾅﾆﾓ ｹﾄﾆﾏﾎ ｶｹﾂｵﾍ ｶﾈﾅﾃ Pﾈﾅｴ ﾎﾅ Tｵﾍﾎ ﾍﾅ ﾎｸｵﾈｵ ｹﾍ ｳﾏﾈﾈｵﾄﾎ ｹﾄｶﾅﾈﾃｱﾎｹﾅﾄ.       */
 /*                                                                           */
             CPYF       FROMFILE(&PLIB/FCEPP01) +
                          TOFILE(&TLIB/FCEPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/GADPP11) +
                          TOFILE(&TLIB/GADPP11) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/AGDPP11) +
                          TOFILE(&TLIB/AGDPP11) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/ALDPP96) +
                          TOFILE(&TLIB/ALDPP96) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/AB#PP70) +
                          TOFILE(&TLIB/AB#PP70) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/AFAPP80) +
                          TOFILE(&TLIB/AFAPP80) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/AAMPP11) +
                          TOFILE(&TLIB/AAMPP11) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/AB#PP10) +
                          TOFILE(&TLIB/AB#PP10) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/FCEPP60) +
                          TOFILE(&TLIB/FCEPP60) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/ALDPP45) +
                          TOFILE(&TLIB/ALDPP45) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/ALDPP97) +
                          TOFILE(&TLIB/ALDPP97) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/ALDPP98) +
                          TOFILE(&TLIB/ALDPP98) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/GADPP11) +
                          TOFILE(&TLIB/GADPP11) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/AAPPP01) +
                          TOFILE(&TLIB/AAPPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/AM#PP31) +
                          TOFILE(&TLIB/AM#PP31) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/GDGPP25) +
                          TOFILE(&TLIB/GDGPP25) MBROPT(*REPLACE)

  /*  ｹｶ ﾏﾍｵﾈﾍ ｱﾈｵ ｷﾅｹﾄｷ ﾎﾅ ｸｱﾐｵ ﾎｸｵｹﾈ ﾅﾑﾄ ﾑﾅﾈﾁｵﾈ ｳﾅｴｵﾍ ｲｵｶﾅﾈｵ ﾎﾈｱｹﾄｹﾄｷ, ﾎｸｵﾄ */
  /*     ｳﾅﾆﾓ ﾎｸｹﾍ ｶｹﾂｵ ﾅﾐｵﾈ ﾎﾅﾅ.                                             */

  /*  ｹｶ ﾏﾍｵﾈﾍ ｱﾈｵ ﾄﾅﾎ ｷﾅｹﾄｷ ﾎﾅ ｸｱﾐｵ ﾎｸｵｹﾈ ﾅﾑﾄ ﾑﾅﾈﾁｵﾈ ｳﾅｴｵ ｱﾄｴ ﾑｹﾂﾂ ｲｵ ﾏﾍｹﾄｷ  */
  /*     ﾎｵﾃﾆ ﾑﾅﾈﾁｵﾈ ｳﾅｴｵﾍ ﾂｹﾁｵ, 000005, 000006, 000007....                   */
  /*     ﾎｸｵﾄ ｴﾅﾄ'ﾎ ｳﾅﾆﾓ ﾑﾅﾈﾁｵﾈ ｳﾅｴｵ ﾃｱﾍﾎｵﾈ ｶｹﾂｵ.                             */
             CPYF       FROMFILE(&PLIB/ALBPP30) +
                          TOFILE(&TLIB/ALBPP30) MBROPT(*REPLACE)

  /*                                                                          */

             CPYF       FROMFILE(&PLIB/AB#PPDC) +
                          TOFILE(&TLIB/AB#PPDC) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/ALRPP05) +
                          TOFILE(&TLIB/ALRPP05) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PWLIB/IICSD) +
                          TOFILE(&TWLIB/IICSD) MBROPT(*REPLACE)

 /*                                                                           */
 /*                                                                           */
 /* ｳﾅﾆﾓ ﾏﾆｴｱﾎｵ ｶｹﾂｵﾍ ｶﾈﾅﾃ Pﾈﾅｴ ﾎﾅ Tｵﾍﾎ ﾍﾅ ﾎｸｵﾈｵ ｹﾍ ｳﾏﾈﾈｵﾄﾎ ｹﾄｶﾅﾈﾃｱﾎｹﾅﾄ.      */
 /*                                                                           */
             CPYF       FROMFILE(&PLIB/AB#PP65) +
                          TOFILE(&TLIB/AB#PP65) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/AB#NP30) +
                          TOFILE(&TLIB/AB#NP30) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/NZUPP01) +
                          TOFILE(&TLIB/NZUPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/NZUPP10) +
                          TOFILE(&TLIB/NZUPP10) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/GTAPP10) +
                          TOFILE(&TLIB/GTAPP10) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PLIB/ALDPP65) +
                          TOFILE(&TLIB/ALDPP65) MBROPT(*REPLACE)

             CPYF       FROMFILE(&PWLIB/AU#NP11) +
                          TOFILE(&TWLIB/AU#NP11) MBROPT(*REPLACE)


 /*                                                                           */
 /* ｳﾅﾆﾓ ﾏﾆｴｱﾎｵ ｶｹﾂｵﾍ ｶﾈﾅﾃ Tｵﾍﾎ ﾎﾅ Sｱﾐｵ ﾍﾅ ﾎｸｵﾈｵ ｹﾍ ｱ ﾈｵﾍｵﾎ ﾆﾅｹﾄﾎ.            */
 /*                                                                           */
             CPYF       FROMFILE(&TLIB/AB#PP65) +
                          TOFILE(&TLIB/SV_AB#PP65) MBROPT(*REPLACE)

             CPYF       FROMFILE(&TLIB/AB#NP30) +
                          TOFILE(&TLIB/SV_AB#NP30) MBROPT(*REPLACE)

             CPYF       FROMFILE(&TLIB/NZUPP01) +
                          TOFILE(&TLIB/SV_NZUPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(&TLIB/NZUPP10) +
                          TOFILE(&TLIB/SV_NZUPP10) MBROPT(*REPLACE)

             CPYF       FROMFILE(&TLIB/GTAPP10) +
                          TOFILE(&TLIB/SV_GTAPP10) MBROPT(*REPLACE)

             CPYF       FROMFILE(&TLIB/ALDPP65) +
                          TOFILE(&TLIB/SV_ALDPP65) MBROPT(*REPLACE)

             CPYF       FROMFILE(&TWLIB/AU#NP11) +
                          TOFILE(&TWLIB/SV_AU#NP11) MBROPT(*REPLACE)


 /*                                                                           */
 /* ｳﾂｵｱﾈ ﾅﾏﾎﾆﾏﾎ ｶｹﾂｵﾍ ｶﾈﾅﾃ ﾆﾈｵﾐｹﾅﾏﾍ ﾎｵﾍﾎｹﾄｷ.                                 */
 /*                                                                           */
             CLRPFM     FILE(&TLIB/ALDPP20)

             CLRPFM     FILE(&TLIB/ALDPP30)

             CLRPFM     FILE(&TLIB/ALDPP50)

             CLRPFM     FILE(&TLIB/GDGPP05)

             CLRPFM     FILE(&TLIB/KU#PP11)

             CLRPFM     FILE(&TLIB/ALDPP79)

             CLRPFM     FILE(&TLIB/ALDPP25)


 /*******************************************************************/

             ENDPGM
