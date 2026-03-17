       ctl-opt dftactgrp(*no);

       readTheJson();
       *inlr = *on;

       // FIXME:
       //   - The field lengths (varchar/packed) are guesses
       //       and should be adjusted based on your business rules.
       //   - The array lengths (dim keywords) are also guesses
       //       and should be adjusted based on your business rules

       dcl-proc readTheJson;

         dcl-ds jsonDoc qualified;
           CODE packed(3) inz(0);
           num_MESSAGES int(10) inz(0);
           MESSAGES varchar(1) dim(1); // empty;
           CONFIRMATIONNUMBER varchar(15) inz('');
           num_CONFIRMEDORDERS int(10) inz(0);
           CONFIRMEDORDERS varchar(1) dim(1); // empty;
           dcl-ds CONFIRMEDTRAILER;
             SUPPLIER varchar(5) inz('');
             ROUTE varchar(4) inz('');
             RUN varchar(2) inz('');
             TRAILERNUMBER varchar(6) inz('');
             PICKUP varchar(16) inz('');
           end-ds;
         end-ds;

         dcl-s ifsPathName varchar(5000);

         ifsPathName = '/toyota/scs/masspro/json/post/trailer/results/2023031

         data-into jsonDoc %DATA( ifsPathname
                                : 'doc=file case=convert countprefix=num_')
                         %PARSER( 'YAJLINTO'
                                : '{ "document_name": "jsonDoc", +
                                     "number_prefix": "YAJL_" }');

       end-proc;
