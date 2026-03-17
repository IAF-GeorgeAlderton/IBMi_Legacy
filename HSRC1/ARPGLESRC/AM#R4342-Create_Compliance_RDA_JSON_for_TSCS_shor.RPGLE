          // ***********************************************************
          //  Toyota SCS - Create Compliance RDA JSON Short Reversal
          //  LEC            2022.06.27
          // ***********************************************************
          //

       ctl-opt  DftActgrp(*No)    BndDir('YAJL')
                Option(*SrcStmt : *NODEBUGIO)  DecEdit('0.');


       DCL-F ALBPL30  DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP400 DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F ALDWP29  DISK(*EXT) USAGE(*INPUT) KEYED;

       /copy yajl/qrpglesrc,yajl_h

       dcl-s  wait          Char(1);
       dcl-s  errMsg        VarChar(500) Inz;
       dcl-s  pathname      VarChar(500) Inz;
       dcl-s  e             int(10);
       dcl-s  PickUpDtTm    Char(16);
       dcl-s  STime         Char(6);
       dcl-s  SysDtTm  timestamp(0) inz(*sys) ;
       dcl-s  wkcd        like(ALWKCD);
       dcl-s  ##comment   char(50);
       dcl-s  ##shid      char(10);
       dcl-s  ##newshid   char(10);
       dcl-s  ##reqd      char(8);

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       // Get Input Parameters ....
         dcl-pr   Main      extpgm('AM#R4342');
                *N    char(6) ;
                *N    char(5) ;
                *N    char(20);
                *N    char(1) ;
                *N    char(50);
                *N    char(1) ;
         end-pr ;

         dcl-pi   Main;
               Worker  char(6);
               SuppCd  char(5);
               appid  char(20);
               pretty char(1);
               File   char(50);
               SendFile char(1);
         end-pi;

      // get file path for saving created json data...
          chain (appid) AM#PP400;
          if NOT %found(AM#PP400);
             *InLr = *On;
             Return;
          endif;

      // get worker name for json data...
          wkcd = %dec(worker:6:0);
          chain (wkcd) ALBPL30;
          if NOT %found(ALBPL30);
             ALWKNM = 'IAF TM';
          endif;

       // Main Process Begins ...

       if pretty = '1';
       yajl_genOpen(*On);
       else;
       yajl_genOpen(*Off);
       endif;

       ##comment='Parts shortage fulfillment';


           yajl_beginObj();                                // Start the root object

               yajl_addChar('vendorCode': %trim(SuppCd));
                  yajl_beginArray('detailsList');              // Start the detailsList array

        // process service parts shortage file...


        DoW  NOT  %eof(ALDWP29);

        Read  ALDWP29;

             If  %eof(ALDWP29);
                 Leave;
             EndIf;

             If  W1LINE = *blanks;
                 Iter;
             EndIf;

                  SendFile = 'Y';

                  ##shid=%subst(W1SHID:1:4) + '-' + %subst(W1SHID:5:2) + '-' +
                         %subst(W1SHID:7:2);

                  ##reqd = %char(W1RDA);
                  ##newshid=%subst(##reqd:1:4) +'-'+ %subst(##reqd:5:2) +'-'+
                            %subst(##reqd:7:2);

                     yajl_beginObj();                            // Start the detailsList object
                       yajl_addChar('poNumber': %trim(W1ORD#));
                       yajl_addChar('partNumber': %trim(W1MHN));
                       yajl_addChar('orginalDDD': %trim(##shid));
                       yajl_addChar('requestedDDD': %trim(##newshid));
                       yajl_addNum('qty': %char(W1ODER));
                       yajl_addNum('reasonCode': '6');
                       yajl_addChar('reasonComment': %trim(##comment));
                     yajl_endObj();                              // End the detailsList object


        EndDo;

                  yajl_endArray();                             // End the detailsList array


           yajl_endObj();                                  // End root object

       File = 'RVS_' + %trim(%char(SysDtTm)) + '.json';

       pathname = %trim(T1FILE) + %trim(File);

       If SendFile = 'Y';
          yajl_saveBuf(pathname: errMsg );
       EndIf;


       *InLr = *On;
       Return;
