             PGM
             /** AB#C0L1**********************************************/
             /*  TEST SAKAKI                                         */
             /*    T.SAKAKI      2016.10.26                          */
             /********************************************** AB#C0L1**/
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)

             RTVMBRD    FILE(AB#EP80) NBRCURRCD(&CNT)
             IF         (&CNT *GT 0) THEN(DO)
             CPYF       FROMFILE(AB#EP80)  TOFILE(HFILE1/AB#EP80@SA) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)
             ENDDO


             ENDPGM
