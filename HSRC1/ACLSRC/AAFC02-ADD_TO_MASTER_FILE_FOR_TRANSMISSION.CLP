             PGM        PARM(&FILE)
             /** AAFC02 ****************************************/
             /* ADD  TO MASTER FILE FOR TRANSMISSION           */
             /* DAILY HANDLING                                 */
             /*        I-HASADA                89.07.10        */
             /**************************************** AAFC02 **/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(5)

             CPYF       FROMFILE(&FILE) TOFILE(AIANP04) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CLRPFM     FILE(&FILE)

             ENDPGM
