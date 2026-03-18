       ctl-opt  DftActgrp(*No)
                Option(*SrcStmt:*NoDebugIO) DecEdit('0.');

         //====================================================================================
         // AM#R4005
         // LEC          2022/08/19
         // This program checks Case# for Parts NOT in SCS COO file, if not there send to SCS
         //====================================================================================

       DCL-F AB#PL66B DISK(*EXT) USAGE(*INPUT) KEYED;

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       dcl-s  Part          Char(20);
       dcl-s  Worker        Char(6);

       dcl-pr   Main      extpgm('AM#R4005');
                *N   Char(8);
       end-pr;

       dcl-pi   Main;
               case Char(8);
       end-pi;

       dcl-pr   AM#R435X  extpgm('AM#R435X');
                *N   Char(6);
                *N   Char(12);
       end-pr;

      // ------------------------------------------------------------------------
      // Main Process

         Worker = '999999';

       // get all records for case number specified...

        SetLL (case) AB#PL66B;
        ReadE (case) AB#PL66B;

        DoW  NOT  %eof(AB#PL66B);

         // if quantity is 0, ignore record...
         If A6SRYO > *zero;

          Part = A6MHN1+A6MHN2+A6MHN3+A6MHN4;

       // call pgm to check part is registered in Country Of Origin in SCS...
          AM#R435X(Worker:Part);
         EndIf;

         ReadE (case) AB#PL66B;

        EndDo;

       *InLr = *On;
       Return;
       //  --------------------------------------------------------------------------
