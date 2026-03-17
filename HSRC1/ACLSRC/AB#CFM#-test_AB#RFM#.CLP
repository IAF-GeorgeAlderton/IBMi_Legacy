             PGM
             /** AB#CFM#   **************************/
             /*  TEST AB#RFM#                       */
             /***************************************/
             DCL        VAR(&CAR) TYPE(*CHAR) LEN(15) VALUE('X')

             CLRPFM     TFILE1/ABFFP01
             OVRDBF     FILE(AB#WPFI2) TOFILE(TWFILE1/AB#WPFI2)
             OVRDBF     FILE(ABFFP01 ) TOFILE(TFILE1/ABFFP01 )

             CALL       TOBJ1/AB#RFJ (&CAR)

             ENDPGM
