       ctl-opt  DFTACTGRP(*NO) Option(*SrcStmt:*NoDebugIO);

         //====================================================================================
         // AL#R426
         // LEC          2023/07/20
         // This program executes SQL to create workfile AL#WP26 with
         // kanban numbers for Toyota part #s and IAF part #s.
         //
         //====================================================================================
         //

         dcl-f al#wp26 disk(*ext) USAGE(*OUTPUT);


         dcl-s  lastdate  date;
         dcl-s  lastyear char(8);

         //-------------------------------------------------------------
         // Get date for first day of last year as a character field...

         lastdate = %date() - %years(1);
         lastyear = %char(%subdt(lastdate:*years)) + '0101';


         //-------------------------------------------------------------
         // Get list of all kanban #s / dock codes in web order file from
         //     beg of last year forward...

              exec sql
                declare c1 cursor for

                select  distinct(caknb# || canuke) as key, caknb# as knb#,
                canuke as nuke
                from al#pp01
                where caskjy = ' ' and cashid >= :lastyear
                order by key;

         //-------------------------------------------------------------
         // Open data set just created...
              exec sql open c1;


              exec sql whenever not found go to DONE1;



         //-------------------------------------------------------------
         // Read and output all entries in data set...

             dou sqlcod <> 0;
              exec sql fetch c1 into :cakey, :caknb#, :canuke;
              write al#wp261;
             enddo;


         //-------------------------------------------------------------


     C     DONE1         TAG


         //-------------------------------------------------------------
         // Close data set...
              exec sql close c1;


             *InLR = *On;
             Return;
