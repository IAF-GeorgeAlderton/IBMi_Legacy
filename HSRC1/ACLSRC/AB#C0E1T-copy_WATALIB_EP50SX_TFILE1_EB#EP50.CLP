             PGM
             /** AB#C0E1 *********************************/
             /*  COPY WATALIB/EP50SX --> TFILE1/AB#EP50  */
             /*  JW      2021.12.03                      */
             /********************************************/

             CPYF       FROMFILE(WATALIB/EP50SX) +
                          TOFILE(TWFILE1/EB#EP50) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             ENDPGM
