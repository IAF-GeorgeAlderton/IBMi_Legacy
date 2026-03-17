             PGM

             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(150)

             DCL        VAR(&LOCATION) TYPE(*CHAR) LEN(4) VALUE('0111')
             DCL        VAR(&PC_SYS) TYPE(*CHAR) LEN(2) VALUE('SJ')

             CHGVAR     VAR(&MSG) VALUE('ABNORMALITY WAS DETECTED BY +
                          THE A-PICS COMMUNICATION. PLEASE CONTACT +
                          THE PERSON IN CHARGE AT ONCE.' *BCAT +
                          &PC_SYS *CAT &LOCATION)

             ENDPGM
