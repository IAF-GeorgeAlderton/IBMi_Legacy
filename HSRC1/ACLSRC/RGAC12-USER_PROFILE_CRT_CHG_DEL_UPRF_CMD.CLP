             PGM        PARM(&MENT &PRF &WORD &SPC1 &SPC2 &MAXM &PRTY +
                          &PGMN &LIBR &PUBL &NAME)
             /* ..USER PROFILE CRT.CHG.DEL.UPRF CMD.. */
             /** RGAC12 **********************************/
             /* I-HASADA                    94.06.08     */
             /********************************** RGAC12 **/
             DCL        VAR(&MENT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WORD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SPC1) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SPC2) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MAXM) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PGMN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PUBL) TYPE(*CHAR) LEN(7)
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(15)

             /*------------------*/
             /* ..0- CANCEL   */
             /*------------------*/
             IF         (&MENT *EQ '0') DO

             CHKOBJ     OBJ(&PRF) OBJTYPE(*USRPRF)
             MONMSG    (CPF9801 CPF3275) *N GOTO END

             DLTUSRPRF  USRPRF(&PRF)

             MONMSG     MSGID(CPF2215) EXEC(DO)
             WRKOBJOWN  USRPRF(&PRF)
             DLTUSRPRF  USRPRF(&PRF)
             ENDDO

             GOTO       END
             ENDDO

             /*----------------------------*/
             /*  ..1- CHANGE .2- ADD| */
             /*----------------------------*/
             IF         (&MENT *NE '0') DO

             CHKOBJ     OBJ(&PRF) OBJTYPE(*USRPRF)
             MONMSG    (CPF9801 CPF3275) *N GOTO STP1

             IF         (&SPC2 *NE '       ') DO

             CHGUSRPRF  USRPRF(&PRF) PASSWORD(&WORD) +
                          INLPGM(&LIBR/&PGMN) TEXT(&NAME) +
                          SPCAUT(&SPC1 &SPC2) MAXSTG(&MAXM) +
                          PTYLMT(&PRTY) GRPPRF(QPGMR)
             GOTO       END
             ENDDO
             ELSE       DO

             CHGUSRPRF  USRPRF(&PRF) PASSWORD(&WORD) +
                          INLPGM(&LIBR/&PGMN) TEXT(&NAME) +
                          SPCAUT(&SPC1) MAXSTG(&MAXM) PTYLMT(&PRTY) +
                          GRPPRF(QPGMR)
             GOTO       END
             ENDDO

 STP1:       IF         (&SPC2 *NE '       ') DO

             CRTUSRPRF  USRPRF(&PRF) PASSWORD(&WORD) +
                          INLPGM(&LIBR/&PGMN) TEXT(&NAME) +
                          SPCAUT(&SPC1 &SPC2) MAXSTG(&MAXM) +
                          PTYLMT(&PRTY) GRPPRF(QPGMR) AUT(&PUBL)
             ENDDO
             ELSE       DO

             CRTUSRPRF  USRPRF(&PRF) PASSWORD(&WORD) +
                          INLPGM(&LIBR/&PGMN) TEXT(&NAME) +
                          SPCAUT(&SPC1) MAXSTG(&MAXM) PTYLMT(&PRTY) +
                          GRPPRF(QPGMR) AUT(&PUBL)
             ENDDO
             ENDDO

 END:        ENDPGM
