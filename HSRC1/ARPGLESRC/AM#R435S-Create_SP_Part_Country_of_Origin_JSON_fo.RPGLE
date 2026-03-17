          // ***********************************************************
          //  Toyota SCS - Create SP Part Country of Origin JSON for TSCS
          //  LEC            2022.05.23
          // ***********************************************************
          //

       ctl-opt  DftActgrp(*No)    BndDir('YAJL')
                Option(*SrcStmt : *NODEBUGIO);


       DCL-F AM#PP435 DISK(*EXT) USAGE(*OUTPUT) KEYED;
       DCL-F ALBPL30  DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AB#PL56  DISK(*EXT) USAGE(*INPUT) KEYED;
       DCL-F AM#PP400 DISK(*EXT) USAGE(*INPUT) KEYED;

       /copy yajl/qrpglesrc,yajl_h

       dcl-s  wait          Char(1);
       dcl-s  errMsg        VarChar(500) Inz;
       dcl-s  pathname      VarChar(500) Inz;
       dcl-s  e             int(10);
       dcl-s  wkcd        like(ALWKCD);
       dcl-s  COO           Char(2);
       dcl-s  MHIN          Char(12);
       dcl-s  MHN1          Char(5);
       dcl-s  MHN2          Char(5);
       dcl-s  MHN3          Char(5);
       dcl-s  MHN4          Char(5);
       dcl-s  Group         Char(3);

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

       // Get Input Parameters ....
         dcl-pr   Main      extpgm('AM#R435S');
                *N    char(20) ;
                *N    char(6) ;
                *N    char(5) ;
                *N    char(12) ;
                *N    char(50) ;
         end-pr ;

         dcl-pi   Main;
               AppId char(20);
               Worker char(6);
               SuppCd char(5);
               Part#  char(12);
               File   char(50);
         end-pi;

       // -------------------------------------------------------------
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

         Group = 'TYT';                                    // toyota
         MHN1 = %subst(Part#:1:5);
         MHN2 = %subst(Part#:6:5);
         MHN3 = %subst(Part#:11:2);

       // -------------------------------------------------------------

       // Main Process Begins ...

         SetLL (Group:MHN1:MHN2:MHN3:MHN4) AB#PL56;
         DoW NOT %eof(AB#PL56);

           ReadE (Group:MHN1:MHN2:MHN3:MHN4) AB#PL56;

           If %eof(AB#PL56);
              Leave;
           EndIf;

           If A5SKJY = *blank;
              COO = A5EDIC;
              Leave;
           EndIf;

         EndDo;

           If COO = *blanks;
              COO = 'US';
           EndIf;

       // write to part country of origin file...
        M5SUPP = SuppCd;
        M5MHIN = Part#;
        M5COC  = COO;
        M5KODT = %char(%date());
        M5KOTM = %char(%time());
        M5KOME = ALWKNM;
        Write AM#PP43R;

       // -------------------------------------------------------------
       // build json data...

       yajl_genOpen(*On);

       yajl_beginObj();  // Start the root object

               yajl_addChar('vendorCode': %trim(SuppCd));
               yajl_addChar('partNumber': %trim(Part#));
               yajl_addChar('countryOfOrigin': %trim(COO));


       yajl_endObj();  // End root object


       pathname = %trim(T1FILE) + %trim(File);

       yajl_saveBuf(pathname: errMsg );


       *InLr = *On;
       Return;
