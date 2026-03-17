             PGM
             /** AL#CG7 ************************/
             /*  INQ TRUCK SCHDULE PLAN        */
             /*  JW                            */
             /**********************************/
             DCL        VAR(&SDAT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&EDAT) TYPE(*DEC) LEN(8 0)

             CHGVAR     VAR(&SDAT) VALUE(20210801)
             CHGVAR     VAR(&EDAT) VALUE(20210831)

             OVRDBF     FILE(AL#WPG5) TOFILE(HWFILE1/AL#WPG5XYZ)

             CALL       PGM(AL#RG7) PARM(&SDAT &EDAT)

             ENDPGM
