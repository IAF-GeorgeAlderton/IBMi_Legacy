             PGM
             /** AB#C6C **********************************************/
             /*  ..ACCOUNTS RECEIVABLE DATA TO PC                    */
             /*        11/08/01                                      */
             /*  JW1   04/23/19 CHG ERROR MSG                        */
             /********************************************************/
             DCL        VAR(&@END) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AB#C6C' 'AB#C6C' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP)
/* =================================================================*/

             CLRPFM AB#WP6C

             CALL       PGM(AB#R6C) PARM(&@END)

             IF         COND(&@END *EQ ' ') THEN(GOTO CMDLBL(@SKIP))

             DLTF       FILE(HWFILE1/AB#WP6CWK)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(HWFILE1/AB#WL6C) +
                          TOFILE(HWFILE1/AB#WP6CWK) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
@SKIP:
       /*JW1*DLTDTAARA  DTAARA(AB#C6C) ****************/
             CALL CHKC45 ('AB#C6C' 'AB#C6C' 'N'  '' '')

@ENDP:       ENDPGM
