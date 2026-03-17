             PGM
             /** ABHCS1 ************************************/
             /*                                            */
             /*               CREATE DATE : 2014.07.22     */
             /*               T.SAKASHITA                  */
             /*  JW1  2019.04.10 ADD ABHWPS4 & ABHWPS4W    */
             /*%0001  2021.06.07 ADD INST. KANBAN DATA     */
             /**********************************************/
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             DCL        VAR(&KEN10) TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&FIL10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NAM30) TYPE(*CHAR) LEN(30)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             DCL        VAR(&KBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&YYM)  TYPE(*DEC) LEN(6 0)
             DCL        VAR(&RITU)  TYPE(*DEC) LEN(3 0)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             DLTF       FILE(&WLIB/ABHWPS1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABHWPS1) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/ABHWPS2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABHWPS2) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
 /*JW1 MACHINE CAPACITY LIST */
             CLRPFM     FILE(&WLIB/ABHWPS4)
             CLRPFM     FILE(&WLIB/ABHWPS4W)

             CALL       PGM(ABHRS1) PARM(&KBN &YYM &RITU)
 /* %0001 INST. KANBAN       */
             CALL       PGM(CADRS1) PARM(&KBN &YYM &RITU)

 /* JW1 ADDED *******************************************************/
             CALL       PGM(ABHRS1W)
             RTVMBRD    FILE(&WLIB/ABHWPS4W) NBRCURRCD(&KEN10)
             IF         COND(&KEN10 *NE 0) THEN(DO)
             CHGVAR     VAR(&FIL10) VALUE('ABHWPS4W')
             CHGVAR     VAR(&LIB10) VALUE(&WLIB)
             CHGVAR     VAR(&NAM30) VALUE('MACHINE CAPACITY LIST')
             CALL       PGM(APLC96) PARM('2' &FIL10   &LIB10 +
                          &NAM30 'Y' ' ')
             ENDDO
 /*******************************************************************/

             IF         COND((&WT *NE 'HPI') *AND (&WT *NE 'V#I') +
                        *AND (&WT *NE 'Q1I')) +
                          THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

             RTVMBRD    FILE(&WLIB/ABHWPS1) NBRCURRCD(&KEN10)
             IF         COND(&KEN10 *NE 0) THEN(DO)

             QSYS/CPYFRMIMPF FROMFILE(ABHWPS1) TOFILE(ABHPPS1) +
                          MBROPT(*REPLACE) RPLNULLVAL(*FLDDFT)

             CHGVAR     VAR(&@LIBL) VALUE(&WLIB)
             CHGVAR     VAR(&@FILE) VALUE('ABHWPS1')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/ABHWPS1.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')
             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)

             CHGVAR     VAR(&@LIBL) VALUE(&WLIB)
             CHGVAR     VAR(&@FILE) VALUE('ABHWPS2')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/ABHWPS2.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')
             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)
             ENDDO

@END:
             ENDPGM
