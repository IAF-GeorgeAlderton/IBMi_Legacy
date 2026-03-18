       ctl-opt  DftActgrp(*No)    BndDir('YAJL')
                Option(*SrcStmt)  DecEdit('0.');


       DCL-F AM#PL29 DISK(*EXT) USAGE(*INPUT) KEYED;

       /copy yajl/qrpglesrc,yajl_h


       dcl-s  In_trailer#   Char(20);
       dcl-s  In_DriverFirst Char(9);
       dcl-s  In_DriverLast Char(12);
       dcl-s  SuppTeamFirst Char(9);
       dcl-s  SuppTeamLast Char(12);
       dcl-s  wait          Char(1);
       dcl-s  errMsg        VarChar(500) Inz;
       dcl-s  filename      VarChar(500) Inz;
       dcl-s  e             int(10);
       dcl-s  pos           int(10);

       // Get Input Parameters ....
         dcl-pr AM#R999 extpgm ;
           Parm1 char(7) ;
           Parm2 char(8) ;
           Parm3 char(4) ;
         end-pr ;

         dcl-s Route char(7);
         dcl-s SHID char(8);
         dcl-s SHIT char(4);

      // call pgm to get truck ticket info....route, ship date, ship time.
         AM#R999(Route:SHID:SHIT) ;

         PickUpDtTm = %subst(SHID:1:4) + '-' + %subst(SHID:5:2) + '-' +
          %subst(SHID:7:2) + 'T' + %subst(SHIT:1:2) + ':' + %subst(SHIT:3:2);


       // Main Process Begins ...


             pos = %Scan( ' ': R2KOME);
             SuppTeamFirst = %trim(%subst(R2USNM:1:pos-1));
             SuppTeamLast = %trim(%subst(R2USNM:pos+1:20-pos));


       yajl_genOpen(*On);


       yajl_beginObj();  // Start the root object
               yajl_addChar('supplier': R2SUPP);
               yajl_addChar('route': R2SURT_route);
               yajl_addChar('run': R2SURT_run);
               yajl_addChar('trailerNumber': In_trailer#);
               yajl_addChar('dropHook': 'false');
               yajl_addChar('sealNumber': '');
               yajl_addChar('supplierTeamFirstName': SuppTeamFirst);
               yajl_addChar('supplierTeamLastName': SuppTeamLast);
               yajl_addChar('lpCode': 'NOPE');
               yajl_addChar('driverTeamFirstName': In_DriverFirst);
               yajl_addChar('driverTeamLastName': In_DriverLast);

                     yajl_beginArray('exceptions');

                          for e = 1 to 5;

                        yajl_beginObj();
                           yajl_addChar('exceptionCode': TrailExcCd);
                           yajl_addChar('comments': TrailExcCom);
                        yajl_endObj();

                          ENDFOR;

                     yajl_endArray();  // End exception array


                     yajl_beginArray('orders');
                        yajl_beginObj();

                        yajl_addChar('order': R2ORDN);
                        yajl_addChar('supplier': R2SUPP);
                        yajl_addChar('plant': R2NAMC);
                        yajl_addChar('dock': R2NUKE);

                        yajl_addChar('pickUp': PickUpDtTm);

                          yajl_beginArray('skids');
                             yajl_beginObj();
                                yajl_addChar('palletization': R2PLTC);
                                yajl_addChar('skidId': %subst(R2SKID:1:3));
                                yajl_beginArray('exceptions');
                                yajl_beginObj();

                                    yajl_addChar('exceptionCode': R2EXCD);
                                  if R2EXCD <> *blanks;
                                     key = %dec(R2EXCD:5:0);
                                    yajl_addChar('comments': SkidExcCom);
                                  ENDIF;

                                yajl_endObj();   // End exceptions object


                                yajl_endArray();  // End exceptions array

                             yajl_endObj();  // End skid object

                         yajl_endArray();  // End skids array

                         yajl_endObj();  // End order object

                      yajl_endArray();  // End orders array

       yajl_endObj();  // End root object

       filename ='/qntc/IAF-AS400-FILE/AS400-TRANS/PC/Upload/jsontest/' +
       %trim(Route) + '_' + %trim(SHID) + '_' + %trim(SHIT) + '.json';

       yajl_saveBuf(filename: errMsg );


       if errMsg <> '';
         Dsply 'Ooppppssss - problem!' ' ' Wait;
       EndIf;


       *InLr = *On;
       Return;


