             PGM
             /** AB#C2CS1 *********************************************/
             /*  SAVE HFILE1/AB#WP2I  --> HFILE1/AB#WP2ISV            */
             /*  SAVE HWFILE1/AB#WP2O --> HWFILE1/AB#WP2OSV           */
             /*                                                       */
             /*  JW    2024.10.08                                     */
             /***************************** AB#C2C ********************/

             CPYF       FROMFILE(HFILE1/AB#WP2I) +
                          TOFILE(HFILE1/AB#WP2ISV) FROMMBR(VA1) +
                          MBROPT(*ADD)

             CPYF       FROMFILE(HWFILE1/AB#WP2O) +
                          TOFILE(HWFILE1/AB#WP2OSV) FROMMBR(VA1) +
                          MBROPT(*ADD)

             ENDPGM
