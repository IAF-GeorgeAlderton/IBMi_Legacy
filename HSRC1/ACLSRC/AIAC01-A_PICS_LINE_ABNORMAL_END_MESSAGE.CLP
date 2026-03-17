             PGM
             /** AIAC01 **************************************/
             /* || A-PICS LINE ABNORMAL END MESSAGE || */
             /* || INTRA-PROCESS KANBAN LINE ABNORMAL END MESSAGE */
             /* I-HASADA                       95.05.31      */
             /************************************** AIAC01 **/
             SNDPGMMSG  +
                          MSG('A-PICS OR INTRA-PROCESS KANBAN LINE +
                          ABNORMAL END.  INFORM IT TO THE MAN. +
                          < QBATCH PGM-AIACJ1 , QBATCH +
                          PGM-AIACJ2 >') TOMSGQ(QSYSOPR)

             ENDPGM
