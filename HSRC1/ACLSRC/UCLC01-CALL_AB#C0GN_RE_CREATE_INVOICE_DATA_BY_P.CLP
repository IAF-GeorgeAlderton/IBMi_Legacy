             PGM
             /** UCLC01 **********************************************/
             /*  CALL AB#C0GN: CREATE EDI(810) FROM AB#EP70S/71S     */
             /*  USE 6 CHARACTER CL TO REGISTER THE MENU             */
             /*  J.WATANABAE  2021.06.11                             */
             /********************************************************/

             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

 /* CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('INVOICE' 'UCLC01 ' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO ENDP)
 /*==============================================================*/

             CALL       PGM(AB#C0GN)

             CALL CHKC45 ('INVOICE' 'UCLC01 ' 'N'  '' '')
ENDP:
             ENDPGM
