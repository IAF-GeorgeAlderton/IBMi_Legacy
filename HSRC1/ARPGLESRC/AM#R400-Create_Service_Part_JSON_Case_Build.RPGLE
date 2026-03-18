       ctl-opt  DftActgrp(*No)    BndDir('YAJL')
                Option(*SrcStmt:*NoDebugIO) DecEdit('0.');

         //====================================================================================
         // AM#R400
         // LEC          2021/12/23
         // This program creates Service Parts JSON - Case Build.
         //====================================================================================

       DCL-F AB#PL44C DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AB#PL66B DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP400 DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AB#PL1L  DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP63 DISK(*EXT) USAGE(*OUTPUT) KEYED;

       /copy yajl/qrpglesrc,yajl_h

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       dcl-s  wait          Char(1);
       dcl-s  errMsg        VarChar(500) Inz;
       dcl-s  filename      VarChar(500) Inz;
       dcl-s  e             int(10);
       dcl-s  pos           int(10);
       dcl-s  Part          Char(20);
       dcl-s  suppCode      like(DASUNM);
       dcl-s  #Qty          like(A6SRYO);
       dcl-s  #Line         like(DALINE);
       dcl-s  ordn          Char(10);
       dcl-s  #order        Char(15);
       dcl-s  #nuke         like(A6NUKE);
       dcl-s  ##shdt        Char(8);
       dcl-s  ShipDt        Char(10);
       dcl-s  Worker        Char(6);

       dcl-pr   Main      extpgm('AM#R400');
                *N   Char(20);
                *N   Char(8);
                *N   Char(4);
       end-pr;

       dcl-pi   Main;
               appid Char(20);
               case Char(8);
               nony Char(4);
       end-pi;

       dcl-pr   AM#R435X  extpgm('AM#R435X');
                *N   Char(6);
                *N   Char(12);
       end-pr;

         dcl-s knony zoned(4:0);

     D                 DS
     D #yy                     1      4  0
     D #mm                     5      6  0
     D #dd                     7      8  0
     D #shid                   1      8  0

         Worker = '999999';
         knony = %dec(NONY:4:0);

      // Main Process Begins ...

      // get file path for saving created json data...
          chain (appid) AM#PP400;
          if NOT %found(AM#PP400);
             *InLr = *On;
             Return;
          endif;

       // get IAF supplier code for TMS from EDI file...
       chain (knony) AB#PL44C;
       if %found(AB#PL44C);
          suppCode = DASUNM ;
       endif;

       // create case build json...
       //  this sets json generator to "pretty"....       yajl_genOpen(*On);
       yajl_genOpen(*On);

       yajl_beginArray();  // Start the root array
          yajl_beginObj();
               yajl_addChar('vendorCode': %trim(suppCode));

                     yajl_beginArray('cases');

                        yajl_beginObj();
                        yajl_addChar('caseNumber': case);
                        yajl_addNum('transportationCode': '3');
                        yajl_addChar('directShipFlag': 'N');
                          yajl_beginArray('units');

       // ------------------------------------------------------------------------
       // get all records for case number specified...

        SetLL (case) AB#PL66B;
        ReadE (case) AB#PL66B;

        DoW  NOT  %eof(AB#PL66B);

         // if quantity is 0, ignore record...
         If A6SRYO > *zero;

          Part = A6MHN1+A6MHN2+A6MHN3+A6MHN4;
          ##shdt = %char(A6NYMD);
          ShipDt = %subst(##shdt:1:4) + '-' + %subst(##shdt:5:2) + '-' +
                   %subst(##shdt:7:2);

         // get purchase order line number...
            #order = A6ORDN;
            chain (knony:A6NYMD:#order:A6MHN1:A6MHN2:A6MHN3:A6MHN4) AB#PL44C;
            if %found(AB#PL44C);
               #Line = DALINE;
            else;
               #Line = '00001';
            endif;

         // get ordered part quantity...
            Exsr #GetQty;

            If #qty > *zero;
                 yajl_beginObj();   // Begin unit object
                 yajl_addChar('partNumber': %trim(Part));
                 yajl_addChar('poNumber': %trim(A6ORDN));
                 yajl_addChar('poLineNumber': #Line);
                 yajl_addChar('poLineHomePosition': %trim(A6HPOS));
                 yajl_addNum('partQuantity': %char(#Qty));
                 yajl_addChar('deliveryDueDate': ShipDt);
                 yajl_endObj();  // End unit object

       // call pgm to check part is registered in Country Of Origin in SCS...
                 AM#R435X(Worker:Part);
            EndIf;

         EndIf;

         ReadE (case) AB#PL66B;

        EndDo;

       // ------------------------------------------------------------------------

                          yajl_endArray();  // End units array

                        yajl_addChar('distFD': '9104095');

                        yajl_endObj();  // End case object
                     yajl_endArray();  // End cases array

          yajl_endObj();  // End vendor object

       yajl_endArray();  // End root array

       filename = %trim(T1FILE) + 'Case' + '_' + %trim(case) + '.json';

       yajl_saveBuf(filename: errMsg );


       if errMsg <> '';
         Exsr LogError;
       EndIf;


       *InLr = *On;
       Return;

       //  --------------------------------------------------------------------------
       //  Write to Error Log AM#PP63...
       //  --------------------------------------------------------------------------
                  BegSr LogError;
                    JEDATE = %dec(%date());
                    JETIME = %dec(%time());
                    JEUSCD = user;
                    JEPGM  = pgm;
                    JEEMSG = ErrMsg;
                     Write AM#PP631;
                  EndSr;
       //  --------------------------------------------------------------------------
       //  get the quantity from the order file (ab#pp10)...
       //  --------------------------------------------------------------------------
           BegSr #GetQty;
       // get ordered qty from order file...
           #qty = *zero;
           ordn = A6ORDN;
           #shid = A6NYMD;
           #nuke = A6NUKE;

       //   go to order file to get the total ordered qty for this part# on order...
       SetLL (knony:#yy:#mm:#dd:#nuke:ordn:A6MHN1:A6MHN2:A6MHN3:A6MHN4) AB#PL1L;
       ReadE (knony:#yy:#mm:#dd:#nuke:ordn:A6MHN1:A6MHN2:A6MHN3:A6MHN4) AB#PL1L;
       DoW NOT %eof;
             If BASKJY = *blank;
                #qty = BAODER;
                Leave;
             EndIf;
       ReadE (knony:#yy:#mm:#dd:#nuke:ordn:A6MHN1:A6MHN2:A6MHN3:A6MHN4) AB#PL1L;
       EndDo;

           EndSr;
       //  --------------------------------------------------------------------------
