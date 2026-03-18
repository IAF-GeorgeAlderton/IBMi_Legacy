     H OPTION(*SRCSTMT : *NODEBUGIO)

     FFCEPL01   UF   E           K DISK

     D                 DS
     D #yy                     1      4  0
     D #mm                     5      6  0
     D #dd                     7      8  0
     D #today                  1      8  0

     D                 DS
     D #hh                     1      2  0
     D #mn                     3      4  0
     D #now                    1      6  0


      /FREE

       dcl-s  Result    like(a2mmei);
       dcl-s  pos           int(10);

       dcl-ds pgm_stat PSDS;
              pgm    *PROC;
              status *STATUS;
              routine *ROUTINE;
              library CHAR(10) POS(81);
              user    CHAR(10) POS(254);
       end-ds;

          #today = %dec(%date():*iso);
          #now = %dec(%time():*hms);

      // process parts master file....
        SetLL (*loval) FCEPL01;

        DoU  %eof(FCEPL01);

          Read FCEPL01;

          if %eof(FCEPL01);
             Leave;
          endif;

          if a2gskd = 'D';
             Iter;
          endif;

          pos = %Scan('TNT15':A2MMEI);
          if pos > *zero;
             result = %ScanRpl('TNT15':'FG113':A2MMEI:1);
             a2mmei = result;
             a2gknm = user;
             A2GKYY = #yy;
             A2GKMM = #mm;
             A2GKDD = #dd;
             A2GKJI = #hh;
             A2GKHU = #mn;
             update fcepl011;
          endif;
        EndDo;

       *InLr = *On;
       Return;
      /END-FREE
