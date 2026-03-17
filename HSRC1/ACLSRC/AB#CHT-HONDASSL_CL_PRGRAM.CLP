             PGM
             /** AB#CHT *****************************************/
             /*  HONDA FTP TEST                                 */
             /*   T.SAKAKI         2015.09.16                   */
             /***************************************** AB#CHT **/
             DCL        VAR(&PUSER) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PPASS)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&PPORT) TYPE(*DEC) LEN(7 0)

             ADDLIBLE   LIB(ZMODLIB10) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

/*  HONDA FTP MASTER REFERENCE */
             CALL       PGM(AB#RHA) PARM(&PUSER &PPASS &PPORT)

/*  Sﾔｲﾊﾔ ﾔｹｶ IP ﾐｶﾐﾐｻﾁﾀ. Eﾘｻﾔ ｻｷ ﾀﾁ ｴﾁﾀﾀｶｴﾔｻﾁﾀ.        */
             STRFTPSSN  RMTSYS(HONDA) USERID(&PUSER &PPASS) +
                          PORT(&PPORT) SSL(*YES)

/*  Wｲﾐ ﾔｹｻﾐ ｲ ﾕﾐｶﾊ ｻｵ/ ﾂｲﾐﾐﾗﾁﾊｵ ｶﾊﾊﾁﾊ.                                 */
             MONMSG     MSGID(UZM9304) EXEC(DO)
             SNDMSG     MSG('SUCCESS') TOUSR(V#IS1) MSGTYPE(*INFO)
             ENDFTPSSN
             GOTO       CMDLBL(@END)
             ENDDO

/*  Cｾﾁﾐｶ ﾔｹｶ ﾐｶﾐﾐｻﾁﾀ ﾗｻﾔｹ Aｵﾖｲﾀﾖﾔｻﾐ.                                  */
             SNDMSG     MSG(SUCCESS) TOMSGQ(V#IS1) MSGTYPE(*INFO)
             ENDFTPSSN

 @END:       RMVLIBLE   LIB(ZMODLIB10)
             RETURN

ENDPGM
