             PGM        PARM(&SUPP)
             /** EDSC90 ************************************/
             /** SAVE GDL SOURCE DATA TO GDLSRC            */
             /** JW       2021.05.19                       */
             /**********************************************/
             DCL        VAR(&SUPP)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&INPUT)  TYPE(*CHAR) LEN(8)

             IF COND(&SUPP *EQ '8990') THEN(CHGVAR VAR(&INPUT) VALUE('ASJ   '))
             IF COND(&SUPP *EQ '4511') THEN(CHGVAR VAR(&INPUT) VALUE('OANDK '))
             IF COND(&SUPP *EQ '4530') THEN(CHGVAR VAR(&INPUT) VALUE('NSCI  '))
             IF COND(&SUPP *EQ '4540') THEN(CHGVAR VAR(&INPUT) VALUE('CHARTER'))
             IF COND(&SUPP *EQ '4550') THEN(CHGVAR VAR(&INPUT) VALUE('POSCO '))
             IF COND(&SUPP *EQ '4560') THEN(CHGVAR VAR(&INPUT) VALUE('TSUSHO'))
             IF COND(&SUPP *EQ '4560') THEN(CHGVAR VAR(&INPUT) VALUE('TSUSHO'))

             OVRDBF     FILE(INPUT) TOFILE(HWFILE1/&INPUT)

             CALL       EDSR90 PARM(&SUPP)


 @EXIT:      ENDPGM
