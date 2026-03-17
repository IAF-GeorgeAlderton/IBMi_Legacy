          // ***********************************************************
          //  Toyota SCS - Expedite an Entire Route
          //  LEC            2021.04.21
          // ***********************************************************
          //

       ctl-opt  DftActgrp(*No)
                Option(*SrcStmt : *NODEBUGIO)  DecEdit('0.');


       DCL-F AM#PL28 DISK(*EXT) USAGE(*UPDATE) KEYED;

       dcl-s  STime         like(R2SHIT);
       dcl-s  SURT          char(7);

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       // Get Input Parameters ....
         dcl-pr   Main      extpgm('AM#R421X');
                *N    char(5) ;
                *N    char(8) ;
                *N    char(4) ;
                *N    char(9) ;
                *N    char(6) ;
         end-pr ;

         dcl-pi   Main;
               SuppCd char(5);
               SHID char(8);
               SHIT char(4);
               Route char(9);
               Worker char(6);
         end-pi;

          STime = SHIT + '00';

      // verify supplier code/ship date/time/route exists...
          chain (SuppCd:SHID:STime:Route) AM#PL28;
          if NOT %found(AM#PL28);
             *InLr = *On;
             Return;
          endif;

      //****************************************************************************
      // Main Process Begins ...

         SetLL (SuppCd:SHID:STime:Route) AM#PL28;
         DoW NOT %eof(AM#PL28);

           ReadE (SuppCd:SHID:STime:Route) AM#PL28;

           If %eof(AM#PL28);
              Leave;
           EndIf;

           SURT = 'EX-' + %trim(route);
           R2SURT = SURT;
           R2SHID = *blanks;
           R2SHIT = *blanks;
           R2EXCD = '18';
           Update AM#PP211;

         EndDo;


       *InLr = *On;
       Return;

