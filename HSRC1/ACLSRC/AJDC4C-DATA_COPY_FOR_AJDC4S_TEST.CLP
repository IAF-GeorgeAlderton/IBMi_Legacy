             PGM
             /** AJDC4C **********************************************/
             /* DATA COPY FOR AJDC4S TEST                            */
             /* T.SAKASHITA 2020.10.05                               */
             /********************************************************/

             CALL       PGM(APLCC1) PARM('FCEPP01')
             CALL       PGM(APLCC1) PARM('AAMPP11')

             CALL       PGM(APLCC1) PARM('AJSPP01')

             CALL       PGM(APLCC1) PARM('AAAPP01')
             CALL       PGM(APLCC1) PARM('AAFPP01')
             CALL       PGM(APLCC1) PARM('AAFPP01')
             CALL       PGM(APLCC1) PARM('CADPP01')

             CALL       PGM(APLCC1) PARM('AARPP11')

             CALL       PGM(APLCC1) PARM('MBDPP01')

             ENDPGM
