             /** APLC30 ******************************************/
             /*  SEND TEXT(CSV) DATA BY MAIL                     */
             /*  Y.SAMEJIMA.........           2012.09.20        */
             /* ------------------------------------------------ */
             /*  JW1    2024.04.30 CHG MAIL SERVER ADDRESS       */
             /* ------------------------------------------------ */
             /*  CALLING SEQ.                                    */
             /*                    CALL 'APLC30'                 */
             /*                    PARM           &TO1   50      */
             /*                    PARM           &SUB   30      */
             /*                    PARM           &LIB   10      */
             /*                    PARM           &FILE  10      */
             /*                    PARM           &FNAME 30      */
             /*   IN  &TO1   50A  MAIL TO ADDRESS                */
             /*   "   &SUB   30A  SUBJECT                        */
             /*   "   &LIB   10A  LIBRARY                        */
             /*   "   &FILE  10A  FILE TO BE ATTACHED            */
             /*   "   &FNAME 30A  ATTACHED FILE TITLE            */
             /****************************************************/

             PGM        PARM(&TO1 &SUB &LIB &FILE &FNAME)

             DCL        VAR(&TO1)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)   TYPE(*CHAR) LEN(30)
             DCL        VAR(&LIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAME) TYPE(*CHAR) LEN(30)

             IF         COND(&TO1   *EQ *BLANK) THEN(GOTO CMDLBL(@END))
             IF         COND(&SUB   *EQ *BLANK) THEN(GOTO CMDLBL(@END))
             IF         COND(&LIB   *EQ *BLANK) THEN(GOTO CMDLBL(@END))
             IF         COND(&FILE  *EQ *BLANK) THEN(GOTO CMDLBL(@END))
             IF         COND(&FNAME *EQ *BLANK) THEN(GOTO CMDLBL(@END))

             IF         COND(&TO1   *EQ ' ') THEN(GOTO CMDLBL(@END))
             IF         COND(&SUB   *EQ ' ') THEN(GOTO CMDLBL(@END))
             IF         COND(&LIB   *EQ ' ') THEN(GOTO CMDLBL(@END))
             IF         COND(&FILE  *EQ ' ') THEN(GOTO CMDLBL(@END))
             IF         COND(&FNAME *EQ ' ') THEN(GOTO CMDLBL(@END))

             ADDLIBLE   LIB(MAI)
             MONMSG     MSGID(CPF2103)

   /**JW1    MAI/DBTOMAIL TO(&TO1) SUBJECT(&SUB) FILE(&LIB/&FILE) +    **/
   /**                    ATFILE(&FNAME) FROM('DATA-SEND@IAFI.COM') +  **/
   /**                    SERVER('172.16.4.13')                        **/

 /** JW1 **/ MAI/DBTOMAIL TO(&TO1) SUBJECT(&SUB) FILE(&LIB/&FILE) +
                          ATFILE(&FNAME) FROM('DATA-SEND@IAFI.COM') +
                          SERVER('10.1.1.25')

 @END:
             ENDPGM
