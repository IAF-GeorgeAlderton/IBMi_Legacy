             PGM
             /** AB#CF8 **************************************/
             /*  FORD EDI FILE DELETE & REORGANIZE           */
             /*  N-HYOTO  2000.06.21                         */
             /*                                              */
             /*  DELET FILE: ABF1L02(ABF1P01_SV)             */
             /*            : ABF4P01                         */
             /*            : ABF6P01                         */
             /*            : ABFPP10                         */
             /*            : ABFPP20                         */
             /*  --------------------------------------------   */
             /*  JW1  2018.03.05 STOP DELETE FORD TRANSACTIONS  */
             /*  JW2  2018.09.24 ADD UTLR63 TO CHECK DELETE RCD */
             /************************************** AB#CF8 *****/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)
/*JW1*/
             GOTO       CMDLBL(END)

/*--------------------------------------------------------------*/

             CALL       PGM(AB#RFG)

/* FORD 862(RELEASE) DATA */
             CALL UTLR63 ('ABF2P01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABF2P01)
             MONMSG     MSGID(CPF0000)
             ENDDO

/* FORD MANIFEST NUMBER   */
             CALL UTLR63 ('ABF4P01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABF4P01)
             MONMSG     MSGID(CPF0000)
             ENDDO

/* FORD LABEL & ASN DATA  */
             CALL UTLR63 ('ABF6P01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABF6P01)
             MONMSG     MSGID(CPF0000)
             ENDDO

/* FORD 830(FORECAST) DATA */
             CALL UTLR63 ('ABFPP10' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABFPP10)
             MONMSG     MSGID(CPF0000)
             ENDDO

/* FORD 830(FORECAST:NOTE) DATA */
             CALL UTLR63 ('ABFPP20' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABFPP20)
             MONMSG     MSGID(CPF0000)
             ENDDO

 END:
             ENDPGM
