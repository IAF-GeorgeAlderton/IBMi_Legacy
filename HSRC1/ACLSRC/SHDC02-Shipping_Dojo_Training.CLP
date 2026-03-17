             PGM        PARM(&WPGM &WDSP &WKCD &USER)
             /*** SHDC02 *****************************/
             /*        SHIPPING DOJO                 */
             /* LEC               2016.06.23         */
             /***************************** SHDC01 ***/

             DCL        VAR(&WPGM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WDSP) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

 /* ｹｶ ｴｹﾍﾆﾂｱﾓ ｶｹﾂｵ ｹﾍ ﾍﾆｵｳｹｶｹｵｴ, ﾎｸｵﾄ ﾅﾐｵﾈﾈｹｴｵ ﾎﾅ HOBJ1 (Pﾈﾅｴﾏｳﾎｹﾅﾄ) ｴｹﾍﾆﾂｱﾓ */
             IF         COND(&WDSP > *BLANKS) THEN(OVRDSPF +
                          FILE(&WDSP) TOFILE(HOBJ1/&WDSP))

             CALL       PGM(HOBJ1/&WPGM) PARM(&WKCD &USER)

 /*******************************************************************/

             ENDPGM
