          // ***********************************************************
          //  Toyota SCS - Create JSON data for Skid kanban cut from TSCS
          //  LEC            2024.04.15
          // ***********************************************************
          //

       ctl-opt  DftActgrp(*No)    BndDir('YAJL')
                Option(*SrcStmt : *NODEBUGIO)  DecEdit('0.');


       DCL-F AM#PL0C DISK(*EXT) USAGE(*UPDATE) KEYED;
       DCL-F AM#PP400 DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP63 DISK(*EXT) USAGE(*OUTPUT) KEYED;

       /copy yajl/qrpglesrc,yajl_h

       dcl-s  SkEXCD  char(2) dim(2);
       dcl-s  wait          Char(1);
       dcl-s  errMsg        VarChar(500) Inz;
       dcl-s  pathname      VarChar(500) Inz;
       dcl-s  e             int(10);
       dcl-s  pos           int(10);
       dcl-c  alpha         'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       dcl-s  SysDtTm  timestamp(0) inz(*sys) ;
       dcl-s  box#          zoned(4:0);
       dcl-s  qtyc          zoned(5:0);

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       // Get Input Parameters ....
         dcl-pr   Main      extpgm('AM#R411C');
                *N    char(6);
                *N    char(20);
                *N    char(50);
                *N    char(12);
                *N    char(5);
                *N    char(2);
                *N    char(2);
                *N    char(3);
                *N    char(1);
                *N    char(1);
         end-pr ;

         dcl-pi   Main;
               Worker char(6);
               appid  char(20);
               File   char(50);
               Ord#   char(12);
               NAMC   char(5);
               Dock   char(2);
               Palt   char(2);
               Skid   char(3);
               pretty char(1);
               exists char(1);
         end-pi;

          SkEXCD(1) = '  ';
          exists = 'N';

      // if order # was not passed in, end program...
          if ord# = *blanks;
             *InLr = *On;
             Return;
          endif;

      // get file path for saving created json data...
          chain (appid) AM#PP400;
          if NOT %found(AM#PP400);
      //  write entry to error log.......................................
             *InLr = *On;
             Return;
          endif;

      // find the kanban to be cut from the skid manifest...
          SetLL (Ord#:NAMC:Dock:Palt:Skid) AM#PL0C;
          DoW NOT %eof(AM#PL0C);
          ReadE (Ord#:NAMC:Dock:Palt:Skid) AM#PL0C;
          If %eof(AM#PL0C);
             *InLr = *On;
             Return;
          EndIf;
          If R1HNTE = 'OK' AND R1SKJY = ' ' AND  R1SHME = 'CUT';
             exists = 'Y';
             R1SKJY = 'D';
             Update AM#PL0C1;
             Leave;
          EndIf;
          EndDo;

       // Main Process Begins ...

       if pretty = '1';
       yajl_genOpen(*On);
       else;
       yajl_genOpen(*Off);
       endif;

       yajl_beginArray();  // Start the root array

       yajl_beginObj();  // Start the root object

               yajl_addChar('order': %trim(R12RD#));
               yajl_addChar('supplier': %trim(R1SUPP));
               yajl_addChar('plant': %trim(R12AMC));
               yajl_addChar('dock': %trim(R12OCK));

                     yajl_beginArray('exceptions');
                        yajl_beginObj();
                           yajl_addChar('exceptionCode': %trim(SkEXCD(1)));
                           yajl_addChar('comments': '');
                        yajl_endObj();

                     yajl_endArray();  // End exception array

              yajl_beginArray('skids');

                        yajl_beginObj();
                        yajl_addChar('palletization': %trim(R12ALT));
                        yajl_addChar('skidId': %trim(Skid));

                          yajl_beginArray('kanbans');

                                box# = %dec(R12OX#:4:0);
                                qtyc = %dec(R1QPC:5:0);
                                  if R12AMC = '60EXP';
                                     R1MAN# = *blanks;
                                  endif;

                                yajl_beginObj();
                                 yajl_addChar('lineSideAddress':%trim(R1LNAD));
                                 yajl_addChar('partNumber': %trim(R12HN));
                                 yajl_addChar('kanban':%trim(R1KANB));
                                 yajl_addChar('qpc': %trim(%char(qtyc)));
                                 yajl_addChar('boxNumber':%trim(%char(box#)));
                                 yajl_addChar('rfId': '');
                                 yajl_addChar('manifestNumber':%trim(R1MAN#));
                                 yajl_addChar('kanbanCut': 'true');
                                yajl_endObj();   // End kanban object

                          yajl_endArray();  // End kanbans array

                          yajl_beginArray('rfidDetails');
                              yajl_beginObj();
                                 yajl_addChar('rfid': '');
                                 yajl_addChar('type': '');
                              yajl_endObj();  // End rfid object
                          yajl_endArray();  // End rfid array


                        yajl_endObj();  // End skid object
              yajl_endArray();  // End skid array

       yajl_endObj();  // End root object

       yajl_endArray();  // End root array

       //  -----------------------------  end json file build -----------------------

       //  build file name...and write it out to ifs...
       pathname = %trim(T1FILE) + %trim(File);
       yajl_saveBuf(pathname: errMsg );


       // if there were any errors, write information to error log....
       if errMsg <> '';
         Exsr LogError;
         Dsply 'Problem while creating JSON - chk AM#PP63 error log' ' ' Wait;
           // in the future, call pgm to display error log by jedate, jetime, jepgm...
       EndIf;


       *InLr = *On;
       Return;

             //  --------------------------------------------------------------------------
             //  Write to Error Log AM#PP63...
                  BegSr LogError;
                    JEDATE = %dec(%date());
                    JETIME = %dec(%time());
                    JEUSCD = worker;
                    JEPGM  = pgm;
                    JEEMSG = ErrMsg;
                     Write AM#PP631;
                  EndSr;

