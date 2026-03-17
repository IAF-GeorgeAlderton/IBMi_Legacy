             PGM
             /** AJ#C742 *********************************/
             /* PRIORITY LIST (NEW) DOWNLOAD TO CSV     */
             /* JW     2023.02.21 CREATE                 */
             /********************************************/
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&CSV )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ADDR)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)    TYPE(*DEC) LEN(10 0) VALUE(0)

             RTVMBRD    FILE(QTEMP/AH#WP74C) NBRCURRCD(&REC)

             IF         COND(&REC *NE 0) THEN(DO)
             CHGVAR     VAR(&TYPE) VALUE('2')
             CHGVAR     VAR(&FILE) VALUE('AH#WP74C')
             CHGVAR     VAR(&LIBL) VALUE('QTEMP')
             CHGVAR     VAR(&FNAM) VALUE('YELLOW FLAG DATA V.1')
             CHGVAR     VAR(&CSV ) VALUE('Y')
             CHGVAR     VAR(&ADDR) VALUE('N')
             CHGVAR     VAR(&MSG ) VALUE('N')

             CALL       PGM(APLC97) PARM(&TYPE &FILE &LIBL &FNAM +
                          &CSV &ADDR &MSG)

     /**     CPYF       FROMFILE(QTEMP/AH#WP74C) +                   **/
     /**                  TOFILE(QTEMP/AH#WP74D) MBROPT(*REPLACE) +  **/
     /**                  FMTOPT(*NOCHK)                             **/

     /** COPY AH#WP74C TO AH#WP74D **/
             CALL       PGM(AJ#R743)

             CHGVAR     VAR(&FILE) VALUE('AH#WP74D')
             CHGVAR     VAR(&FNAM) VALUE('YELLOW FLAG DATA V.2')

             CALL       PGM(APLC97) PARM(&TYPE &FILE &LIBL &FNAM +
                          &CSV &ADDR &MSG)

     /*****  CLRPFM     FILE(QTEMP/AH#WP74C)  ****/

             ENDDO

             ENDPGM
