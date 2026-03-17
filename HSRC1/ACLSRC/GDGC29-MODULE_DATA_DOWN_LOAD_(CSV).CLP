             PGM
             /** GDGC29 ************************************/
             /*  MODULE DATA DOWN LOAD (CSV)               */
             /*    SEEK                     2023.02.21     */
             /**********************************************/
             DCL        &SYS     *CHAR   8 ' '
             DCL        &JOB     *CHAR  10 ' '
             DCL        &USER    *CHAR  10 ' '
             DCL        &PLIB    *CHAR   8 ' '
             DCL        &WLIB    *CHAR   8 ' '
             DCL        &GDGWP29 *CHAR  10 ' '
             DCL        &CSV     *CHAR   1 ' '
             DCL        &PCFIL   *CHAR  30 'CASE# SCAN DATA'
             DCL        &TYPE    *CHAR   2 ' 1'

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&JOB) USER(&USER)

             CALL       ALBC01 (&USER &PLIB &WLIB)

         /*  WORK-FILE    */
             CHGVAR     &GDGWP29 ('GDGWP29' |< %SST(&JOB 1 3))
             DLTF       &WLIB/&GDGWP29
             MONMSG CPF0000
             CRTPF      FILE(&WLIB/&GDGWP29) RCDLEN(256) SIZE(100000 +
                          10000) LVLCHK(*NO) AUT(*ALL)

         /*  EXEC PGM     */
             OVRDBF     GDGWP29 &WLIB/&GDGWP29
             CALL       GDGR29 &CSV
             DLTOVR     *ALL
             IF (&CSV =' ')   (RETURN)

         /*  CALL       APLC98 (&WLIB &GDGWP29 &SYS &PCFIL &TYPE)  */
             CALL       PGM(APLC94) PARM('1' &GDGWP29 &WLIB &PCFIL +
                          'Y' 'Y' 'Y')
             RETURN

             ENDPGM
