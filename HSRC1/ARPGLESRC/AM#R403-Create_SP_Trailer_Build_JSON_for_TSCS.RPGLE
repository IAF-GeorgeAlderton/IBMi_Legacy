          // ***********************************************************
          //  Toyota SCS - Create JSON data for Service Parts Trailer Build
          //  LEC            2021.12.16
          // ***********************************************************
          //

       ctl-opt  DftActgrp(*No)    BndDir('YAJL')
                Option(*SrcStmt : *NODEBUGIO)  DecEdit('0.');


       DCL-F AM#PL21S2 DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F ALBPL30  DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP400 DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP63 DISK(*EXT) USAGE(*OUTPUT) KEYED;

       /copy yajl/qrpglesrc,yajl_h

       dcl-s  SuppFirst Char(9);
       dcl-s  SuppLast Char(12);
       dcl-s  wait          Char(1);
       dcl-s  errMsg        VarChar(500) Inz;
       dcl-s  pathname      VarChar(500) Inz;
       dcl-s  e             int(10);
       dcl-s  pos           int(10);
       dcl-s  Surt_route    like(S2SURT);
       dcl-s  Surt_run      like(S2SURT);
       dcl-s  PickUpDtTm    Char(16);
       dcl-s  STime         Char(6);
       dcl-s  SysDtTm  timestamp(0) inz(*sys) ;
       dcl-s  exDate        Char(10);
       dcl-s  exTime        Char(6);
       dcl-s  PickUpId      Char(20);
       dcl-s  SaveSuppCd    Char(5);
       dcl-s  KTime       like(S2SHIT);
       dcl-s  KDate       like(S2SHID);
       dcl-s  wkcd        like(ALWKCD);
       dcl-s  TT            Char(25);
       dcl-s  WgtKG         packed(7);

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       // Get Input Parameters ....
         dcl-pr   Main      extpgm('AM#R403');
                *N    char(6) ;
                *N    char(5) ;
                *N    char(9) ;
                *N    char(8) ;
                *N    char(4) ;
                *N    char(20) ;
                *N    char(9) ;
                *N    char(12) ;
                *N    char(20) ;
                *N    char(1) ;
                *N    char(1) ;
                *N    char(6) ;
                *N    char(50) ;
         end-pr ;

         dcl-pi   Main;
               Worker char(6);
               SuppCd char(5);
               Route char(9);
               SHID char(8);
               SHIT char(4);
               Trailer#   Char(20);
               DriverFirst Char(9);
               DriverLast Char(12);
               appid      Char(20);
               exists     Char(1);
               pretty     Char(1);
               SCAC       Char(6);
               File       Char(50);
         end-pi;

         dcl-pr   AM#R22W  extpgm('AM#R22W');
                *N    char(5) ;
                *N    char(25) ;
                *N    packed(7) ;
         end-pr ;


          If %subst(route:1:3) = 'EX-';
          exists = 'N';
          *InLr = *On;
          Return;
          Else;
          STime = SHIT + '00';
          KTime = %dec(STime:6:0);
          EndIf;

          If SHID = *blanks;
          *InLr = *On;
          Return;
          Else;
          KDate = %dec(SHID:8:0);
          EndIf;

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

      // if expedite route, use current date/time as pickup time...
          if %subst(route:1:3) = 'EX-' or route ='EXPDIT';
           exDate = %char(%date(SysDtTm));
           exTime  = %char(%time(SysDtTm));
           PickUpDtTm = %subst(exDate:1:10) + 'T' + %subst(exTime:1:2) + ':' +
            %subst(exTime:4:2);
          else;
      // string together ship date/time = pickup time...
           PickUpDtTm = %subst(SHID:1:4) + '-' + %subst(SHID:5:2) + '-' +
            %subst(SHID:7:2) + 'T' + %subst(SHIT:1:2) + ':' + %subst(SHIT:3:2);
          endif;

      // extract route and run from the Route scanned from the Truck Ticket...
             route = %trim(route);
             pos = %Scan(' ' : Route : 1);
              if pos > *zero;
                 Surt_route  = %trim(%subst(Route:1:pos-3));
                 Surt_run    = %trim(%subst(Route:pos-2:2));
              else;
                 Surt_route  = %trim(Route);
                 Surt_run    = *blanks;
              endif;

      // if route is an expedite route, leave it alone and make run = 01
             If %subst(route:1:3) = 'EX-';
                Surt_route = %trim(route);
                 Surt_run    = '01';
             EndIf;

      // if route is an expedite route, leave it alone and make run = 01
             If route  = 'EXPDIT';
                Surt_route = 'EX-EXPD';
                 Surt_run    = 'IT';
             EndIf;

             pos = %Scan( ' ': ALWKNM);
             SuppFirst = %trim(%subst(ALWKNM:1:pos-1));
             SuppLast = %trim(%subst(ALWKNM:pos+1:20-pos));

       // Truck Ticket...
          TT = %subst(Route:1:7) + SHID + SHIT;

       // calculate total s.p. shipment weight in kg...
          AM#R22W(SuppCd:TT:WgtKG);

       exists= 'N';

       // Main Process Begins ...

       if pretty = '1';
       yajl_genOpen(*On);
       else;
       yajl_genOpen(*Off);
       endif;

       yajl_beginObj();  // Start the root object

               yajl_addChar('trailerNumber': %trim(Trailer#));
               yajl_addChar('route': %trim(Surt_route));
               yajl_addChar('run': %trim(Surt_run));
               yajl_addChar('planPickupDate': %trim(PickUpDtTm));
               yajl_addChar('sealNumber': '');
               yajl_addChar('supplierFirstName': %trim(SuppFirst));
               yajl_addChar('supplierLastName': %trim(SuppLast));
               yajl_addChar('lpCode': %trim(SCAC));
               yajl_addChar('driverFirstName': %trim(DriverFirst));
               yajl_addChar('driverLastName':  %trim(DriverLast));
               yajl_addNum('freightWeightInKg': %char(WgtKG));
               yajl_addChar('pickupId':  %trim(PickupId));


              yajl_beginArray('vendors');

         SetLL (SuppCd:KDate:KTime:Route) AM#PL21S2;
         DoW NOT %eof(AM#PL21S2);

         ReadE (SuppCd:KDate:KTime:Route) AM#PL21S2;

         If %eof(AM#PL21S2);
            Leave;
         EndIf;

         If S2SKJY <> *blank;
            Iter;
         EndIf;

         exists= 'Y';

         If SuppCd <> SaveSuppCd;

                      if SaveSuppCd <> *blanks;
                         yajl_endObj();
                      endif;

                        yajl_beginObj();
                        yajl_addChar('vendorCode': %trim(S2SUPP));
                        yajl_addChar('shipmentID': %trim(S2SERL));

         EndIf;

         SaveSuppCd = SuppCd;

                          yajl_beginArray('cases');

             SetLL (SuppCd:KDate:KTime:Route) AM#PL21S2;
             DoW  NOT  %eof(AM#PL21S2);
             ReadE (SuppCd:KDate:KTime:Route) AM#PL21S2;
                         If %eof(AM#PL21S2);
                            Leave;
                         EndIf;

                         If S2SKJY <> *blank;
                            Iter;
                         EndIf;


                             yajl_beginObj();
                                yajl_addChar('caseNumber': %trim(S2MLBL));
                             yajl_endObj();  // End case number object
             EndDo;

             SetGT (SuppCd:KDate:KTime:Route) AM#PL21S2;

                          yajl_endArray();  // End cases array

          EndDo;

                         yajl_endObj();  // End vendor object

                      yajl_endArray();  // End vendors array

       yajl_endObj();  // End root object


      //  if the route exists in s.p. shipment scan file (am#pp21s), save json data to ifs...
       if exists = 'Y';
       pathname = %trim(T1FILE) + %trim(File);

       yajl_saveBuf(pathname: errMsg );
       endif;


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

