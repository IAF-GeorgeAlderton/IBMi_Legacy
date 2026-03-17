PGM
             /* AB#CC1C *******************************************/
             /* TRANSFER AB#WPC1T TO CSV                          */
             /* JW  2025.4.23                                     */
             /*****************************************************/
             DCL        VAR(&XTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&XFIL ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&XLIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&XFILN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&XCSV ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&XCLM ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&XTYPE) VALUE('2')
             CHGVAR     VAR(&XFIL ) VALUE('AB#WPC1T')
             CHGVAR     VAR(&XLIB ) VALUE('QTEMP ')
             CHGVAR     VAR(&XFILN) VALUE('SHIPPED CONTAINER BY PART#')
             CHGVAR     VAR(&XCSV ) VALUE('C')
             CHGVAR     VAR(&XCLM ) VALUE('N')

             CALL       PGM(APLC94 ) PARM(&XTYPE &XFIL &XLIB &XFILN +
                          &XCSV &XCLM 'Y')

             ENDPGM
