uses crt;
type mang=array[0..10,0..10] of longint;
var a,c:mang;
        i,j,diff,diff1,difftotal,code,count:word;
        ch,ch1,ch2,ch3:char;
        fmove,fnum:longint;
        moved,loaded{,wide}:boolean;
        hidden,hardrock,spunout,nofail,easy:shortint;
        cs,s:byte;
function lnth(a:longint):byte;
var l:byte;
begin
     l:=0;
     repeat
           l:=l+1;
           a:=a div 10;
     until a=a div 10;
     lnth:=l;
end;
function multiplier(ez,hd,hr,so,nf:byte):real;
var m:real;
begin
     m:=1;
     if ez=1 then m:=m*0.5;
     if hd=1 then m:=m*1.12;
     if hr=1 then m:=m*1.06;
     if so=1 then m:=m*0.9;
     if nf=1 then m:=m*0.5;
     multiplier:=m;
end;
function point(a:mang;cs,hd,hr,so,nf:byte;diff:word):longint;
var i,j,pt:longint;
begin
     pt:=0;
     for i:=0 to cs do
         for j:=0 to cs do
             pt:=pt+a[i,j];
     if cs>=4 then pt:=round(pt*0.5);
     if hd=1 then pt:=round(pt*1.12);
     if hr=1 then pt:=round(pt*1.06);
     if so=1 then pt:=round(pt*0.9);
     if nf=1 then pt:=round(pt*0.5);
     pt:=pt*(diff+1);
     point:=pt;
end;
procedure continue;
var b:array[1..121] of longint;
    tmp:longint;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             b[i*(cs+1)+(j+1)]:=a[i,j];
     for i:=1 to sqr(cs+1)-1 do
         for j:=i+1 to sqr(cs+1) do
             if  b[i]>b[j] then
             begin
                  tmp:=b[i];
                  b[i]:=b[j];
                  b[j]:=tmp;
             end;
     for i:=0 to cs do
         for j:=0 to cs do
             if (a[i,j]=b[1]) or (a[i,j]=b[2]) then a[i,j]:=0;
end;
function checkfile(fl:string):boolean;
var f:text;
    chk:boolean;
begin
     assign(f,fl);
{$I-}
     reset(f);
{$I+}
     if IOResult=0 then chk:=true
     else chk:=false;
     if chk=true then close(f);
     checkfile:=chk;
end;
procedure rewind;
var i,j:byte;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             a[i,j]:=c[i,j];
end;
procedure backup;
var i,j:byte;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             c[i,j]:=a[i,j];
end;
function difference(a,b:mang;cs:byte):boolean;
var i,j:byte;
    chk:boolean;
begin
     chk:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]<>b[i,j] then chk:=true;
     difference:=chk;
end;
function win(a:mang;n:word;cs:byte):boolean;
var i,j:byte;
begin
     win:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=n then win:=true;
end;
function lose(a:mang;cs:byte):boolean;
var i,j:byte;
begin
     lose:=true;
     for i:=0 to cs do
         for j:=0 to cs-1 do
             if a[i,j]=a[i,j+1] then lose:=false;
     for i:=0 to cs-1 do
         for j:=0 to cs do
             if a[i,j]=a[i+1,j] then lose:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=0 then lose:=false;
end;
procedure start;
var i,j,k:byte;
    check:boolean;
begin
     randomize;
     for k:=1 to cs do
     begin
          check:=false;
          for i:=0 to cs do
              for j:=0 to cs do
                  if a[i,j]=0 then check:=true;
          if check=true then
          repeat
                i:=random(cs+1);
                j:=random(cs+1);
          until a[i,j]=0;
          repeat
                a[i,j]:=random(5);
          until (a[i,j]=2) or (a[i,j]=4);
     end;
end;
procedure spawn;
var i,j:byte;
    check:boolean;
begin
     randomize;
     check:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=0 then check:=true;
     if check=true then
     begin
          repeat
                i:=random(cs+1);
                j:=random(cs+1);
          until a[i,j]=0;
          repeat
                a[i,j]:=random(5);
          until a[i,j] mod 2=0;
     end;
end;
procedure spawnhardrock;
var i,j:byte;
    check:boolean;
begin
     randomize;
     check:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=0 then check:=true;
     if check=true then
     begin
          repeat
                i:=random(cs+1);
                j:=random(cs+1);
          until a[i,j]=0;
          repeat
                a[i,j]:=random(9);
          until (a[i,j] mod 2=0) and (a[i,j]<>6);
     end;
end;
function health(a:mang;cs:byte):byte;
var i,j,count:byte;
begin
     count:=1;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=0 then count:=count+1;
     health:=count;
end;
procedure printf;
var i,j,k:byte;
begin
     for i:=1 to s-1 do
         write('-');
     writeln;
     if diff1=0 then
     begin
          for i:=1 to (s-9) div 2  do
              write(' ');
          writeln('EASY ',diff);
     end;
     if diff1=1 then
     begin
          for i:=1 to (s-11) div 2  do
              write(' ');
          writeln('NORMAL ',diff);
     end;
     if diff1=2 then
     begin
          for i:=1 to (s-9) div 2  do
              write(' ');
          writeln('HARD ',diff);
     end;
     if diff1=3 then
     begin
          for i:=1 to (s-14) div 2  do
              write(' ');
          writeln('VERY HARD ',diff);
     end;
     if diff1=4 then
     begin
          for i:=1 to (s-11) div 2  do
              write(' ');
          writeln('MASTER ',diff);
     end;
     for i:=1 to s-1 do
         write('-');
     writeln;
     for i:=1 to difftotal do
         write('* ');
     writeln;
     if nofail<>1 then
     begin
        for i:=1 to sqr(cs+1) do
            write('--');
        write('|');
        writeln;
        if lose(a,cs)=false then
           for i:=1 to health(a,cs) do
               write('##');
           for i:=1 to sqr(cs+1)-health(a,cs) do
               write('  ');
        if lose(a,cs)=false then
           write('|')
           else write('  |');
        for i:=2 to (s-sqr(cs+1)*2-1-lnth(point(a,cs,hidden,hardrock,spunout,nofail,diff1))) do
            write(' ');
        writeln(point(a,cs,hidden,hardrock,spunout,nofail,diff1));
        for i:=1 to sqr(cs+1) do
            write('--');
        write('|');
        writeln;
     end
     else
     begin
          for k:=1 to s-1-lnth(point(a,cs,hidden,hardrock,spunout,nofail,diff1)) do
              write(' ');
          writeln(point(a,cs,hidden,hardrock,spunout,nofail,diff1));
     end;
     for k:=2 to (s-6*(cs+1)) div 2 do
         write(' ');
     write('|');
     for k:=1 to cs+1 do
         write('-----|');
     for k:=1 to (s-6*(cs+1)) div 2-round((nofail+hidden+hardrock+spunout+cs+2)*1.5)-1 do
         write(' ');
     if cs>=4 then write('EZ ');
     if nofail=1 then write('NF ');
     if spunout=1 then write('SO ');
     if hidden=1 then write('HD ');
     if hardrock=1 then write('HR ');
     writeln;
     for i:=0 to cs do
     begin
          for k:=2 to (s-6*(cs+1)) div 2 do
              write(' ');
          write('|');
          for j:=0 to cs do
              if a[i,j]<>0 then
              begin
                   if (a[i,j]<=10) and (hidden=1) then write('  ',a[i,j],'  |');
                   if (a[i,j]=16) and (hidden=1) then write('  ',a[i,j],' |');
                   if (a[i,j]>16) and (hidden=1) then write('  ','?','  |');
                   if (a[i,j]<10) and (hidden=-1) then
                      write('  ',a[i,j],'  |');
                   if (a[i,j]>9) and (a[i,j]<100) and (hidden=-1) then
                      write('  ',a[i,j],' |');
                   if (a[i,j]>99) and (a[i,j]<1000) and (hidden=-1) then
                      write(' ',a[i,j],' |');
                   if (a[i,j]>999) and (a[i,j]<10000) and (hidden=-1) then
                      write(' ',a[i,j],'|');
                   if (a[i,j]>9999) and (a[i,j]<100000) and (hidden=-1) then
                      write(a[i,j],'|');
              end
              else write('     |');
          writeln;
          if i<=cs then
          begin
               for k:=2 to (s-6*(cs+1)) div 2 do
                   write(' ');
               write('|');
               for k:=1 to cs do
                   write('-----|');
               writeln('-----|');
          end;
     end;
     writeln('Moves:',count);
end;
procedure move(c:char);
var i,j,n:byte;
    b:array[0..10,0..10] of longint;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             b[i,j]:=0;
     if c=#72 then
        for j:=0 to cs do
        begin
             n:=0;
             for i:=0 to cs do
                 if a[i,j]<>0 then
                 begin
                      b[n,j]:=a[i,j];
                      n:=n+1;
                 end;
        end;
     if c=#80 then
        for j:=0 to cs do
        begin
             n:=0;
             for i:=cs downto 0 do
                 if a[i,j]<>0 then
                 begin
                      b[cs-n,j]:=a[i,j];
                      n:=n+1;
                 end;
        end;
     if c=#75 then
        for i:=0 to cs do
        begin
             n:=0;
             for j:=0 to cs do
                 if a[i,j]<>0 then
                 begin
                      b[i,n]:=a[i,j];
                      n:=n+1;
                 end;
        end;
     if c=#77 then
        for i:=0 to cs do
        begin
             n:=0;
             for j:=cs downto 0 do
                 if a[i,j]<>0 then
                 begin
                      b[i,cs-n]:=a[i,j];
                      n:=n+1;
                 end;
        end;
        for i:=0 to cs do
            for j:=0 to cs do
                a[i,j]:=b[i,j];
end;
procedure clear(c:char);
var i,j,k:byte;
begin
     if c=#72 then
        for i:=0 to cs-1 do
            for j:=0 to cs do
                if a[i,j]=a[i+1,j] then
                begin
                     a[i,j]:=a[i,j]+a[i+1,j];
                     a[i+1,j]:=0;
                end;
     if c=#80 then
        for i:=cs-1 downto 0 do
            for j:=0 to cs do
                if a[i,j]=a[i+1,j] then
                begin
                     a[i+1,j]:=a[i,j]+a[i+1,j];
                     a[i,j]:=0;
                end;
     if c=#75 then
        for i:=0 to cs do
            for j:=0 to cs-1 do
                if a[i,j]=a[i,j+1] then
                begin
                     a[i,j]:=a[i,j]+a[i,j+1];
                     a[i,j+1]:=0;
                end;
     if c=#77 then
        for i:=0 to cs do
            for j:=cs-1 downto 0 do
                if a[i,j]=a[i,j+1] then
                begin
                     a[i,j+1]:=a[i,j]+a[i,j+1];
                     a[i,j]:=0;
                end;
     move(c);
end;
procedure readf;
var f:text;
begin
     assign(f,'record.txt');
     reset(f);
     readln(f,fnum,fmove);
     close(f);
end;
function maxnum(a:mang;cs:byte):longint;
var i,j,m:longint;
begin
     m:=a[0,0];
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]>m then m:=a[i,j];
     maxnum:=m;
end;
procedure writef;
var f:text;
begin
     assign(f,'record.txt');
     rewrite(f);
     writeln(f,point(a,cs,hidden,hardrock,spunout,nofail,diff1),' ',maxnum(a,cs));
     close(f);
end;
procedure save;
var i,j:byte;
    f:text;
    c:char;
begin
     if checkfile('save.txt')=true then
     begin
          writeln('We have detected that there is a save file on your computer');
          writeln('If you attempt to save,the save file will be overwritten');
          writeln('Do you want to proceed');
          writeln('Press y to proceed');
          writeln('Press n to cancel');
          repeat
                c:=readkey;
          until (c='y') or (c='n');
     end
     else c:='y';
     if c='y' then
     begin
          assign(f,'save.txt');
          rewrite(f);
          for i:=0 to cs do
          begin
               for j:=0 to cs do
               begin
                    if j<cs then
                       write(f,a[i,j],' ')
                    else
                        write(f,a[i,j]);
               end;
               writeln(f);
          end;
          write(f,ch2,' ',diff1,' ',count,' ',hidden,' ',hardrock,' ',spunout,' ',nofail);
          close(f);
     end;
end;
procedure load;
var f:text;
    i,j:byte;
begin
        assign(f,'save.txt');
        reset(f);
        cs:=0;
        while eoln(f)=false do
        begin
             read(f,a[0,cs]);
             inc(cs);
        end;
        cs:=cs-1;
        for i:=1 to cs do
        begin
             for j:=0 to cs do
                 read(f,a[i,j]);
             readln(f);
        end;
        readln(f,ch2,diff1,count,hidden,hardrock,spunout,nofail);
        if hidden=0 then hidden:=-1;
        if hardrock=0 then hardrock:=-1;
        if spunout=0 then spunout:=-1;
        if nofail=0 then nofail:=-1;
        close(f);
end;
procedure cleargame;
var f:text;
begin
     assign(f,'save.txt');
     erase(f);
end;
procedure calibrate(st:string;s:byte);
var k:byte;
begin
     for k:=1 to (s-length(st)) div 2 do
         write(' ');
     writeln(st);
end;
procedure menu1;
var k:byte;
begin
     clrscr;
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('2048 Advanced for DOS',s);
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Hit 1 to start a game',s-2);
     calibrate('Hit 2 to use Night theme',s);
     calibrate('Hit 3 to use Classic theme',s+2);
     if checkfile('save.txt')=true then
     begin
          calibrate('Hit 4 to load your game',s-1);
          calibrate('Hit d to clear your game',s);
     end;
     if hidden=-1 then
        calibrate('Hit 5 to turn on hidden mod',s+3)
        else
        calibrate('Hit 5 to turn off hidden mod',s+4);
     if easy=-1 then
        calibrate('Hit 6 to turn on easy mod',s+1)
        else
        calibrate('Hit 6 to turn off easy mod',s+2);
     if hardrock=-1 then
        calibrate('Hit 7 to turn on hard rock mod',s+6)
        else
        calibrate('Hit 7 to turn off hard rock mod',s+7);
     if spunout=-1 then
        calibrate('Hit 8 to turn on spun out mod',s+5)
        else
        calibrate('Hit 8 to turn off spun out mod',s+6);
     if nofail=-1 then
        calibrate('Hit 9 to turn on no-fail mod',s+4)
        else
        calibrate('Hit 9 to turn off no-fail mod',s+5);
{
     calibrate('hit w to toggle widescreen mode',s+7);
}
     calibrate('Hit esc to Exit',s-8);
     calibrate('UPDATE 3.01',s-12);
     writeln('RECORD:',fnum,';max number:',fmove);
     for k:=2 to (s-21) div 2 do
         write(' ');
     writeln('Score multiplier:',multiplier(easy,hidden,hardrock,spunout,nofail):0:2);
end;
procedure menu2;
var k:byte;
begin
     clrscr;
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Select Target Number',s);
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Hit 0 for endless',s);
     calibrate('Hit 1 for 512',s-4);
     calibrate('Hit 2 for 1024',s-3);
     calibrate('Hit 3 for 2048',s-3);
     calibrate('Hit 4 for 4096',s-3);
     calibrate('Hit 5 for 8192',s-3);
     calibrate('Hit 6 for 16384',s-2);
end;
procedure menu3;
var k:byte;
begin
     clrscr;
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Select Difficulty',s);
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Hit 0 for easy',s-3);
     calibrate('Hit 1 for normal',s-1);
     calibrate('Hit 2 for hard',s-3);
     calibrate('Hit 3 for very hard',s+2);
     calibrate('Hit 4 for master',s-1);
end;
begin
     hidden:=-1;hardrock:=-1;spunout:=-1;nofail:=-1;cs:=3;easy:=-1;s:=80;{wide:=false;}
     textcolor(black);
     textbackground(white);
     repeat
           count:=0;if checkfile('record.txt')=true then readf;moved:=false;loaded:=false;
           repeat
{case wide of
true:s:=120;
false:s:=80;
end;}
                menu1;
                ch:=readkey;
                if ch='2' then
                begin
                     textcolor(white);
                     textbackground(black);
                     lowvideo;
                end;
                if ch='3' then
                begin
                     textcolor(black);
                     textbackground(white);
                end;
                if ch='5' then hidden:=hidden*(-1);
                if ch='6' then easy:=easy*(-1);
                if ch='7' then hardrock:=hardrock*(-1);
                if ch='8' then spunout:=spunout*(-1);
                if ch='9' then nofail:=nofail*(-1);
{if ch='w' then
case s of
80:wide:=true;
120:wide:=false;
end;}
                if (ch='d') and (checkfile('save.txt')=true) then
                   cleargame;
                if (ch='4') and (checkfile('save.txt')=true) then break;
           until (ch='1') or (ch=chr(27));
           if ch='4' then
           begin
                load;
                loaded:=true;
           end;
           if loaded=false then
              if easy=1 then cs:=4
           else cs:=3;
           if ch=chr(27) then exit;
           repeat
                 if loaded=true then break;
                 menu2;
                 ch2:=readkey;
           until (ch2='0') or (ch2='1') or (ch2='2') or (ch2='3') or (ch2='4') or (ch2='5') or (ch2='6');
           if ch2='1' then
              diff:=512;
           if ch2='2' then
              diff:=1024;
           if ch2='3' then
              diff:=2048;
           if ch2='4' then
              diff:=4096;
           if ch2='5' then
              diff:=8192;
           if ch2='6' then
              diff:=16384;
           if ch2='0' then
              diff:=1;
           repeat
                 if loaded=true then break;
                 menu3;
                 ch3:=readkey;
           until (ch3='0') or (ch3='1') or (ch3='2') or (ch3='3') or (ch3='4');
           if loaded=false then
              val(ch3,diff1,code);
           val(ch2,difftotal,code);
           difftotal:=difftotal+diff1;
           if cs=4 then difftotal:=round(difftotal*0.75);
           if hardrock=1 then difftotal:=round(difftotal*1.5);
           if spunout=1 then difftotal:=round(difftotal*0.85);
           if loaded=false then
           begin
                for i:=0 to cs do
                    for j:=0 to cs do
                        a[i,j]:=0;
                        start;
           end;
           repeat
                 clrscr;
                 printf;
                 ch:=readkey;
                 if (count>0) and (ch='r') and (moved=true) then rewind;
                 if (ch=#72) or (ch=#80) or (ch=#75) or (ch=#77) then
                 begin
                      moved:=true;
                      backup;
                      move(ch);
                      if spunout<>1 then
                         clear(ch)
                         else
                         for i:=1 to 11 do
                         clear(ch);
                      if difference(a,c,cs)=true then
                      begin
                           for i:=1 to diff1+1 do
                               if hardrock=-1 then
                                  spawn
                                  else
                                  spawnhardrock;
                           count:=count+1;
                      end;
                 end;
                 if ch=chr(27) then
                 begin
                      ch:=#0;
                      writeln('ARE YOU SURE YOU WANT TO QUIT?');
                      writeln('Press y to return to menu');
                      writeln('Press n to continue');
                      writeln('Press s to save your game and return to menu');
                      repeat
                            ch:=readkey;
                      until (ch='y') or (ch='n') or (ch='s');
                if (ch='y') or (ch='s') then break;
                end;
                if (lose(a,cs)=true) and (nofail=1) then continue;
           until (win(a,diff,cs)=true) or (lose(a,cs)=true);
           if (point(a,cs,hidden,hardrock,spunout,nofail,diff1)>fnum) then
              writef;
           repeat
                 if win(a,diff,cs)=true then
                 begin
                      hidden:=-1;
                      clrscr;
                      printf;
                      writeln('YOU WON');
                      if loaded=true then
                         cleargame;
                 end;
                 if lose(a,cs)=true then
                 begin
                      hidden:=-1;
                      clrscr;
                      printf;
                      writeln('YOU LOST');
                      if loaded=true then
                         cleargame;
                 end;
                 if ch='s' then save;
                 if (ch='y') or (ch='s') then ch1:='y';
                 if (ch<>'y') and (ch<>'s') then
                 begin
                      writeln('Wanna try again?');
                      writeln('Hit y for yes');
                      writeln('Hit n for no');
                      ch1:=readkey;
                 end;
           until (ch1='y') or (ch1='n');
     until ch1='n';
end.
