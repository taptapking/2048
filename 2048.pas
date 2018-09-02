(*
    2048 - A game based on Gabriele Cirulli's 2048 (the official 2048).
    
    Copyright (C) 2017-2018 Le Ngoc Dang Khoa <lethanhbinhkts@gmail.com>
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
uses crt;
type mang=array[0..10,0..10] of longint;
var a,d,c,e:mang;
        i,j,code,c1,count,count1,diff:word;
        ch,ch1,ch2,ch3,ch4,ch5,up,down,left,right,re,re1,up1,down1,left1,right1:char;
        fmove,fnum:longint;
        moved,moved1,loaded,wide:boolean;
        hidden,bg,txt,hardrock,spunout,nofail,easy,flashlight,color,efl,gfx,diff1,difftotal,soun,nofail1:shortint;
        cs,s,x,y,x1,y1:byte;
        username,s1:string;
procedure losingtune;
begin
     delay(150);
     sound(262);
     delay(250);
     sound(147);
     delay(250);
     sound(262);
     delay(200);
     sound(196);
     delay(200);
     nosound;
     delay(500);
     sound(131);
     delay(520);
     nosound;
end;
procedure winningtune;
begin
     delay(150);
     Sound(650);
     Delay(600);
     NoSound;

     Delay(180);
     Sound(500);
     Delay(150);

     Sound(570);
     Delay(150);

     Sound(640);
     Delay(150);

     Sound(570);
     Delay(150);
     NoSound;

     Delay(200);
     Sound(770);
     Delay(150);
     nosound;
     Sound(770);
     Delay(200);
     NoSound;
end;
procedure titlegfx; {renders the top difficulty board in high settings}
begin
        clrscr;
        for i:=1 to s-1 do
                write(chr(196));
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
                write(chr(196));
        writeln;
        for i:=1 to difftotal do
                write('* ');
        writeln;
end;
procedure title; {renders the top difficulty board in low settings}
begin
        clrscr;
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
end;
function log2(a:longint):integer;   {no need explaination here}
var c:integer;
begin
        c:=0;
        while a>1 do
        begin
                a:=a div 2;
                c:=c+1;
        end;
        log2:=c;
end;
function pow2(a:byte):longint;      {2^any number}
var i,c:integer;
begin
        c:=1;
        for i:=1 to a do
        c:=c*2;
        pow2:=c;
end;
procedure calibrate(st:string;s3:byte);{print a string to the middle of the screen}
var k:byte;
begin
     for k:=1 to (s3-length(st)) div 2 do
         write(' ');
     writeln(st);
end;
function lnth(a:longint):byte; {determine how many digit does a number have}
var l:byte;
begin
     l:=0;
     repeat
           l:=l+1;
           a:=a div 10;
     until a=a div 10;
     lnth:=l;
end;
function multiplier(ez,hd,hr,so,nf,fl:byte):real;{recalculate score after applying mods}
var m:real;
begin
     m:=1;
     if ez=1 then m:=m*0.5;
     if hd=1 then m:=m*1.12;
     if fl=1 then m:=m*1.12;
     if hr=1 then m:=m*1.06;
     if so=1 then m:=m*0.9;
     if nf=1 then m:=m*0.5;
     multiplier:=m;
end;
procedure modsintro(ez1,hd1,hr1,so1,nf1,fl1:byte);{prints mods selection board}
var i:byte;
begin
        for i:=1 to s-1 do write('-');writeln;
        calibrate('Mods',s);
        for i:=1 to s-1 do write('-');writeln;
        for i:=1 to 2 do
                writeln;
        for i:=2 to (s-21) div 2 do
                write(' ');
        writeln('Score multiplier:',multiplier(easy,hidden,hardrock,spunout,nofail,flashlight):0:2);
        writeln;
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        write('Difficulty reduction:    ');
        if color<>-1 then textbackground(2);
        if ez1=1 then write('EZ') else write('ez');
        if color<>-1 then textbackground(bg);write('   ');
        if color<>-1 then textbackground(1);
        if nf1=1 then write('NF') else write('nf');
        if color<>-1 then textbackground(bg);
        writeln;
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        write('Difficulty increase:     ');
        if color<>-1 then textbackground(4);
        if hr1=1 then write('HR') else write('hr');
        if color<>-1 then textbackground(bg);write('   ');
        if color<>-1 then textbackground(6);
        if hd1=1 then write('HD') else write('hd');
        if color<>-1 then textbackground(bg);write('   ');
        if fl1=1 then write('FL') else write('fl');
        writeln;
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        write('Special:                 ');
        if color<>-1 then textbackground(3);
        if so1=1 then write('SO') else write('so');
        if color<>-1 then textbackground(bg);
        writeln;
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        writeln('Hit 1 to reset all mods');
        writeln;
        for i:=1 to (s-40) div 2 do
                write(' ');
        write('Hit esc to close');
end;
function point(a:mang;cs,hd,hr,so,nf,fl:byte;diff:word):longint;{calculate score based on mods and the board}
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
procedure conti(var a: mang);{delete 2 lowest numbers on P1 and/or P2 Board when there are no moves left to prevent game-over when using No-Fail}
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
function checkfile(fl:string):boolean;{verify if a file is avaliable}
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
procedure rewind;{rewind a move on P1 Board}
var i,j:byte;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             a[i,j]:=c[i,j];
end;
procedure rewind1;{rewind a move on P2 Board}
var i,j:byte;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             d[i,j]:=e[i,j];
end;
procedure backup;{backup the recent move from P1 board to rewind later}
var i,j:byte;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             c[i,j]:=a[i,j];
end;
procedure backup1;{backup the recent move from P2 board to rewind later}
var i,j:byte;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             e[i,j]:=d[i,j];
end;
function difference(a,b:mang;cs:byte):boolean;{check the difference between 2 boards}
var i,j:byte;
    chk:boolean;
begin
     chk:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]<>b[i,j] then chk:=true;
     difference:=chk;
end;
function win(a:mang;n:word;cs:byte):boolean;{determine if the player has won or not}
var i,j:byte;
begin
     win:=false;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=n then win:=true;
end;
function lose(a:mang;cs:byte):boolean;{determine if the player has lost or not}
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
procedure start(var a: mang);{spawn random numbers on P1 and/or P2 board when starting the game}
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

procedure spawn(var a: mang);{spawn random number on P1 and/or P2 board when the player make a legit move}
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
procedure spawnhardrock(var a: mang);{spawn larger random number on P1 and/or P2 board when the player make a legit move}
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
function health(a:mang;cs:byte):byte;{generates health bar value}
var i,j,count:byte;
begin
     count:=1;
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]=0 then count:=count+1;
     if count>sqr(cs+1) then count:=sqr(cs+1);
     health:=count;
end;
procedure printf;{prints a board and health bar in singleplayer mode}
var i,j,k,k1:byte;
begin
     k1:=0;
     if ((nofail<>1) and (s<80) and (cs<4)) or ((nofail<>1) and (s>=80)) then
     begin
        for i:=1 to sqr(cs+1) do
            if gfx<>1 then write('--') else write(chr(196),chr(196));
        if gfx<>1 then write(':') else write(chr(191));
        writeln;
        if color<>-1 then
        begin
                if (health(a,cs)>sqr(cs-1)*2) and (health(a,cs)<=sqr(cs-1)*4) then textbackground(2);
                if (health(a,cs)>sqr(cs-1)) and (health(a,cs)<=sqr(cs-1)*2) then textbackground(3);
                if (health(a,cs)<=sqr(cs-1)) then textbackground(4);
                if lose(a,cs)=false then
                        for i:=1 to health(a,cs) do
                                write('  ');
                        textbackground(bg);
        end
        else
                if lose(a,cs)=false then
                begin
                        textbackground(txt);
                        for i:=1 to health(a,cs) do
                                write('  ');
                        textbackground(bg);
                end;
        for i:=1 to sqr(cs+1)-health(a,cs) do
            write('  ');
        if lose(a,cs)=false then
           if gfx<>1 then write('|') else write(chr(179))
           else if gfx<>1 then write('  |') else write('  ',chr(179));
        gotoxy(s-lnth(point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1)) ,6);
        writeln(point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1));
        for i:=1 to sqr(cs+1)-1 do
            if gfx<>1 then write('__') else write(chr(196),chr(196));
        if gfx<>1 then write('_/') else write(chr(196),chr(196),chr(217));
        writeln;
     end {renders health bar when not using NF}
     else
     begin
          gotoxy(s-lnth(point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1)),5);
          writeln(point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1));
     end; {prints score to the screen}
     if (nofail=1) or ((s<80) and (cs>3)) then nofail1:=1 else nofail1:=-1;
     gotoxy((s-6*(cs+1)) div 2,7-nofail1);
     if gfx<>1 then write('|') else write(chr(218));
     for k:=1 to cs+1 do
         if gfx<>1 then write('-----|') else write(chr(196),chr(196),chr(196),chr(196),chr(196),chr(194));
     {prints the top of the board}
     if cs>=4 then k1:=k1+3;
     if nofail=1 then k1:=k1+3;
     if spunout=1 then k1:=k1+3;
     if hidden=1 then k1:=k1+3;
     if hardrock=1 then k1:=k1+3;
     if flashlight=1 then k1:=k1+3;
     if s>=80 then
     begin
          gotoxy(s-k1,7-nofail1);
          if cs>=4 then
          begin
               if color<>-1 then textbackground(2);
               write('EZ');
               if color<>-1 then textbackground(bg);
               write(' ');
          end;
          if nofail=1 then
          begin
               if color<>-1 then textbackground(1);
               write('NF');
               if color<>-1 then textbackground(bg);
               write(' ');
          end;
          if spunout=1 then
          begin
               if color<>-1 then textbackground(3);
               write('SO');
               if color<>-1 then textbackground(bg);
               write(' ');
          end;
          if hidden=1 then
          begin
               if color<>-1 then textbackground(6);
               write('HD');
               if color<>-1 then textbackground(bg);
               write(' ');
          end;
          if hardrock=1 then
          begin
               if color<>-1 then textbackground(4);
               write('HR');
               if color<>-1 then textbackground(bg);
               write(' ');
          end;
          if flashlight=1 then write('FL');
     end; {prints mods that the player is using}
     writeln;
     for i:=0 to cs do
     begin
          gotoxy((s-6*(cs+1)) div 2,7-nofail1+i*2+1);
          if gfx<>1 then write('|') else write(chr(179));
          for j:=0 to cs do
          begin
                   if (a[i,j]<>0) and (flashlight<>1) then
                   {print numbers when flashlight mod is disabled and the number inside is not 0}
                   begin
                        if color<>-1 then
                        begin
                                textbackground(round(log2(a[i,j])));
                                if (round(log2(a[i,j]))+8=txt) or (round(log2(a[i,j]))-8=txt)
                                then textbackground(round(log2(a[i,j])-1));
                        end;{generate colors when color is enabled}
                        if (a[i,j]=16) and (hidden=1) then write('  ',a[i,j],' ');
                        if (a[i,j]>16) and (hidden=1) then {prints numbers when hidden mod is enabled}
                        begin
                                textbackground(bg);
                                write('  ','?','  ');
                        end;
                        if a[i,j]<10 then
                           write('  ',a[i,j],'  ');
                        if (a[i,j]>9) and (a[i,j]<100) and (hidden=-1) then
                           write('  ',a[i,j],' ');
                        if (a[i,j]>99) and (a[i,j]<1000) and (hidden=-1) then
                           write(' ',a[i,j],' ');
                        if (a[i,j]>999) and (a[i,j]<10000) and (hidden=-1) then
                           write(' ',a[i,j]);
                        if (a[i,j]>9999) and (a[i,j]<100000) and (hidden=-1) then
                           write(a[i,j]);
                        textbackground(bg);
                        if gfx<>1 then write('|') else write(chr(179));
                   end;
                   if (a[i,j]=0) and (flashlight<>1) then
                   {print numbers when flashlight mod is disabled and the number inside is 0}
                          if gfx<>1 then write('     |')
                   else write('     ',chr(179));
                   if (flashlight=1) and (efl=1) then
                   begin{print numbers when flashlight mod and enhanced mode are enabled}
                        if (x-1<=i) and (i<=x+1) and (y-1<=j) and (j<=y+1) then
                        begin
                                if a[i,j]=0 then
                                        if gfx<>1 then write('     |')  else write('     ',chr(179))
                                else
                                begin
                                        if color<>-1 then
                                        begin
                                                textbackground(round(log2(a[i,j])));
                                                if (round(log2(a[i,j]))+8=txt) or (round(log2(a[i,j]))-8=txt)
                                                then textbackground(round(log2(a[i,j])-1));
                                        end;{generate colors when color is enabled}
                                        if (a[i,j]=16) and (hidden=1) then write('  ',a[i,j],' ');
                                        if (a[i,j]>16) and (hidden=1) then{print numbers when hidden mod is enabled}
                                        begin
                                                textbackground(bg);
                                                write('  ','?','  ');
                                        end;
                                        if a[i,j]<10 then
                                                write('  ',a[i,j],'  ');
                                        if (a[i,j]>9) and (a[i,j]<100) and (hidden=-1) then
                                                write('  ',a[i,j],' ');
                                        if (a[i,j]>99) and (a[i,j]<1000) and (hidden=-1) then
                                                write(' ',a[i,j],' ');
                                        if (a[i,j]>999) and (a[i,j]<10000) and (hidden=-1) then
                                                write(' ',a[i,j]);
                                        if (a[i,j]>9999) and (a[i,j]<100000) and (hidden=-1) then
                                                write(a[i,j]);
                                        textbackground(bg);
                                        if gfx<>1 then write('|') else write(chr(179));
                                end;{prints numbers in the visible area}
                        end
                        else
                        begin
                                textbackground(txt);
                                write('     ');
                                textbackground(bg);
                                if gfx<>1 then write('|') else write(chr(179));
                        end;   {hides numbers not in the visible area}
                    end;
                    if (flashlight=1) and (efl=-1) then
                    begin {print numbers when flashlight mod is enabled and enhanced mode is disabled}
                        if ((health(a,cs)>2) and (i>=1) and (j<=cs-1)) or ((health(a,cs)<=2) and (i>=2) and (j<=cs-2)) then
                        begin
                             if a[i,j]=0 then
                             if gfx<>1 then write('     |') else write('     ',chr(179));
                             if a[i,j]<>0 then
                             begin
                                  if color<>-1 then
                                  begin
                                        textbackground(round(log2(a[i,j])));
                                        if (round(log2(a[i,j]))+8=txt) or (round(log2(a[i,j]))-8=txt)
                                        then textbackground(round(log2(a[i,j])-1));
                                  end;{generate colors when color is enabled}
                                  if (a[i,j]=16) and (hidden=1) then write('  ',a[i,j],' ');
                                  if (a[i,j]>16) and (hidden=1) then
                                  begin
                                        textbackground(bg);
                                        write('  ','?','  ');
                                  end;{print numbers when hidden is enabled}
                                  if a[i,j]<10 then
                                     write('  ',a[i,j],'  ');
                                  if (a[i,j]>9) and (a[i,j]<100) and (hidden=-1) then
                                     write('  ',a[i,j],' ');
                                  if (a[i,j]>99) and (a[i,j]<1000) and (hidden=-1) then
                                     write(' ',a[i,j],' ');
                                  if (a[i,j]>999) and (a[i,j]<10000) and (hidden=-1) then
                                     write(' ',a[i,j]);
                                  if (a[i,j]>9999) and (a[i,j]<100000) and (hidden=-1) then
                                     write(a[i,j]);
                                  textbackground(bg);
                                  if gfx<>1 then write('|') else write(chr(179));
                             end; {prints numbers in the visible area}
                        end
                        else
                        begin
                                textbackground(txt);
                                write('     ');
                                textbackground(bg);
                                if gfx<>1 then write('|') else write(chr(179));
                        end; {hides numbers not in the visible area}
                    end;
                    textbackground(bg);
          end;
          writeln;
          if i<=cs then
          begin
               gotoxy((s-6*(cs+1)) div 2,7-nofail1+i*2+2);
               if gfx<>1 then write('|') else write(chr(195));
               for k:=1 to cs do
                   if gfx<>1 then write('-----|') else write(chr(196),chr(196),chr(196),chr(196),chr(196),chr(197));
               if gfx<>1 then writeln('-----|') else writeln(chr(196),chr(196),chr(196),chr(196),chr(196),chr(180));
          end;
     end;
     writeln('Moves:',count);{prints borders between lines}
end;
procedure printfmulti; {prints health bar and board in multiplayer mode}
var i,j,k,k1:byte;
begin
     k1:=0;
     if ((nofail<>1) and (s<120) and (cs<4)) or ((nofail<>1) and (s>=120)) then
     begin
        for i:=1 to sqr(cs+1) do
            if gfx<>1 then write('--') else write(chr(196),chr(196));
        if gfx<>1 then write(':') else write(chr(191));
        for i:=1 to s-(4*(sqr(cs+1)+1))+1 do
            write(' ');
        if gfx<>1 then write(':') else write(chr(218));
        for i:=1 to sqr(cs+1) do
            if gfx<>1 then write('--') else write(chr(196),chr(196));
        writeln;
        if color<>-1 then
        begin
                if (health(a,cs)>sqr(cs-1)*2) and (health(a,cs)<=sqr(cs-1)*4) then textbackground(2);
                if (health(a,cs)>sqr(cs-1)) and (health(a,cs)<=sqr(cs-1)*2) then textbackground(3);
                if (health(a,cs)<=sqr(cs-1)) then textbackground(4);
                if lose(a,cs)=false then
                        for i:=1 to health(a,cs) do
                                write('  ');
                        textbackground(bg);
        end
        else
                if lose(a,cs)=false then
                begin
                        textbackground(txt);
                        for i:=1 to health(a,cs) do
                                write('  ');
                        textbackground(bg);
                end;
        for i:=1 to sqr(cs+1)-health(a,cs) do
            write('  ');
        if lose(a,cs)=false then
           if gfx<>1 then write('|') else write(chr(179))
           else if gfx<>1 then write('  |') else write('  ',chr(179));
        for i:=2 to s-((sqr(cs+1)+1)*4)+2 do
            write(' ');
        if lose(d,cs)=false then
           if gfx<>1 then write('|') else write(chr(179))
           else if gfx<>1 then write('|  ') else write(chr(179),'  ');
        for i:=1 to sqr(cs+1)-health(d,cs) do
            write('  ');
        if color<>-1 then
        begin
                if (health(d,cs)>sqr(cs-1)*2) and (health(d,cs)<=sqr(cs-1)*4) then textbackground(2);
                if (health(d,cs)>sqr(cs-1)) and (health(d,cs)<=sqr(cs-1)*2) then textbackground(3);
                if (health(d,cs)<=sqr(cs-1)) then textbackground(4);
                if lose(d,cs)=false then
                        for i:=1 to health(d,cs) do
                                write('  ');
                        textbackground(bg);
        end
        else
                if lose(d,cs)=false then
                begin
                        textbackground(txt);
                        for i:=1 to health(d,cs) do
                                write('  ');
                        textbackground(bg);
                end;
        writeln;
        {writeln(point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1));}
        for i:=1 to sqr(cs+1)-1 do
            if gfx<>1 then write('__') else write(chr(196),chr(196));
        if gfx<>1 then write('_/') else write(chr(196),chr(196),chr(217));
        for i:=1 to s-((sqr(cs+1)+1)*4)+1 do
            write(' ');
        if gfx<>1 then write('  \_') else write(chr(192),chr(196),chr(196));
        for i:=1 to sqr(cs+1)-1 do
            if gfx<>1 then write('__') else write(chr(196),chr(196));
        writeln;
     end;
     for k:=2 to (s-12*(cs+1)) div 3 do
         write(' ');
     if gfx<>1 then write('|') else write(chr(218));
     for k:=1 to cs+1 do
         if gfx<>1 then write('-----|') else write(chr(196),chr(196),chr(196),chr(196),chr(196),chr(194));
     for i:=2 to (s-12*(cs+1)-((s-12*(cs+1)) div 3)) div 2+1 do
            write(' ');
     if gfx<>1 then write('|') else write(chr(218));
     for k:=1 to cs+1 do
         if gfx<>1 then write('-----|') else write(chr(196),chr(196),chr(196),chr(196),chr(196),chr(194));
     writeln;
     for i:=0 to cs do
     begin
          for k:=2 to (s-12*(cs+1)) div 3 do
              write(' ');
          if gfx<>1 then write('|') else write(chr(179));
          for j:=0 to cs do
          begin
                   if (a[i,j]<>0) and (flashlight<>1) then
                   begin
                        if color<>-1 then
                        begin
                                textbackground(round(log2(a[i,j])));
                                if (round(log2(a[i,j]))+8=txt) or (round(log2(a[i,j]))-8=txt)
                                then textbackground(round(log2(a[i,j])-1));
                        end;
                        if (a[i,j]=16) and (hidden=1) then write('  ',a[i,j],' ');
                        if (a[i,j]>16) and (hidden=1) then
                        begin
                                textbackground(bg);
                                write('  ','?','  ');
                        end;
                        if a[i,j]<10 then
                           write('  ',a[i,j],'  ');
                        if (a[i,j]>9) and (a[i,j]<100) and (hidden=-1) then
                           write('  ',a[i,j],' ');
                        if (a[i,j]>99) and (a[i,j]<1000) and (hidden=-1) then
                           write(' ',a[i,j],' ');
                        if (a[i,j]>999) and (a[i,j]<10000) and (hidden=-1) then
                           write(' ',a[i,j]);
                        if (a[i,j]>9999) and (a[i,j]<100000) and (hidden=-1) then
                           write(a[i,j]);
                        textbackground(bg);
                        if gfx<>1 then write('|') else write(chr(179));
                   end;
                   if (a[i,j]=0) and (flashlight<>1) then
                   if gfx<>1 then write('     |')
                   else write('     ',chr(179));
                    if (flashlight=1) and (efl=1) then
                    begin
                        if (x-1<=i) and (i<=x+1) and (y-1<=j) and (j<=y+1) then
                        begin
                                if a[i,j]=0 then
                                        if gfx<>1 then write('     |')  else write('     ',chr(179))
                                else
                                begin
                                        if color<>-1 then
                                        begin
                                                textbackground(round(log2(a[i,j])));
                                                if (round(log2(a[i,j]))+8=txt) or (round(log2(a[i,j]))-8=txt)
                                                then textbackground(round(log2(a[i,j])-1));
                                        end;
                                        if (a[i,j]=16) and (hidden=1) then write('  ',a[i,j],' ');
                                        if (a[i,j]>16) and (hidden=1) then
                                        begin
                                                textbackground(bg);
                                                write('  ','?','  ');
                                        end;
                                        if a[i,j]<10 then
                                                write('  ',a[i,j],'  ');
                                        if (a[i,j]>9) and (a[i,j]<100) and (hidden=-1) then
                                                write('  ',a[i,j],' ');
                                        if (a[i,j]>99) and (a[i,j]<1000) and (hidden=-1) then
                                                write(' ',a[i,j],' ');
                                        if (a[i,j]>999) and (a[i,j]<10000) and (hidden=-1) then
                                                write(' ',a[i,j]);
                                        if (a[i,j]>9999) and (a[i,j]<100000) and (hidden=-1) then
                                                write(a[i,j]);
                                        textbackground(bg);
                                        if gfx<>1 then write('|') else write(chr(179));
                                end;
                        end
                        else
                        begin
                                textbackground(txt);
                                write('     ');
                                textbackground(bg);
                                if gfx<>1 then write('|') else write(chr(179));
                        end;
                   end;
                    if (flashlight=1) and (efl=-1) then
                    begin
                        if ((health(a,cs)>2) and (i>=1) and (j<=cs-1)) or ((health(a,cs)<=2) and (i>=2) and (j<=cs-2)) then
                        begin
                             if a[i,j]=0 then
                             if gfx<>1 then write('     |') else write('     ',chr(179));
                             if a[i,j]<>0 then
                             begin
                                  if color<>-1 then
                                  begin
                                        textbackground(round(log2(a[i,j])));
                                        if (round(log2(a[i,j]))+8=txt) or (round(log2(a[i,j]))-8=txt)
                                        then textbackground(round(log2(a[i,j])-1));
                                  end;
                                  if (a[i,j]=16) and (hidden=1) then write('  ',a[i,j],' ');
                                  if (a[i,j]>16) and (hidden=1) then
                                  begin
                                        textbackground(bg);
                                        write('  ','?','  ');
                                  end;
                                  if a[i,j]<10 then
                                     write('  ',a[i,j],'  ');
                                  if (a[i,j]>9) and (a[i,j]<100) and (hidden=-1) then
                                     write('  ',a[i,j],' ');
                                  if (a[i,j]>99) and (a[i,j]<1000) and (hidden=-1) then
                                     write(' ',a[i,j],' ');
                                  if (a[i,j]>999) and (a[i,j]<10000) and (hidden=-1) then
                                     write(' ',a[i,j]);
                                  if (a[i,j]>9999) and (a[i,j]<100000) and (hidden=-1) then
                                     write(a[i,j]);
                                  textbackground(bg);
                                  if gfx<>1 then write('|') else write(chr(179));
                             end;
                        end
                        else
                        begin
                                textbackground(txt);
                                write('     ');
                                textbackground(bg);
                                if gfx<>1 then write('|') else write(chr(179));
                        end;
                    end;
                    textbackground(bg);
          end;
          for k:=1 to (s-12*(cs+1)-((s-12*(cs+1)) div 3)) div 2 do
              write(' ');
          if gfx<>1 then write('|') else write(chr(179));
          for j:=0 to cs do
          begin
                   if (d[i,j]<>0) and (flashlight<>1) then
                   begin
                        if color<>-1 then
                        begin
                                textbackground(round(log2(d[i,j])));
                                if (round(log2(d[i,j]))+8=txt) or (round(log2(d[i,j]))-8=txt)
                                then textbackground(round(log2(d[i,j])-1));
                        end;
                        if (d[i,j]=16) and (hidden=1) then write('  ',d[i,j],' ');
                        if (d[i,j]>16) and (hidden=1) then
                        begin
                                textbackground(bg);
                                write('  ','?','  ');
                        end;
                        if d[i,j]<10 then
                           write('  ',d[i,j],'  ');
                        if (d[i,j]>9) and (d[i,j]<100) and (hidden=-1) then
                           write('  ',d[i,j],' ');
                        if (d[i,j]>99) and (d[i,j]<1000) and (hidden=-1) then
                           write(' ',d[i,j],' ');
                        if (d[i,j]>999) and (d[i,j]<10000) and (hidden=-1) then
                           write(' ',d[i,j]);
                        if (d[i,j]>9999) and (d[i,j]<100000) and (hidden=-1) then
                           write(d[i,j]);
                        textbackground(bg);
                        if gfx<>1 then write('|') else write(chr(179));
                   end;
                   if (d[i,j]=0) and (flashlight<>1) then
                   if gfx<>1 then write('     |') else write('     ',chr(179));
                    if (flashlight=1) and (efl=1) then
                    begin
                        if (x1-1<=i) and (i<=x1+1) and (y1-1<=j) and (j<=y1+1) then
                        begin
                                if d[i,j]=0 then
                                        if gfx<>1 then write('     |') else write('     ',chr(179))
                                else
                                begin
                                        if color<>-1 then
                                        begin
                                                textbackground(round(log2(d[i,j])));
                                                if (round(log2(d[i,j]))+8=txt) or (round(log2(d[i,j]))-8=txt)
                                                then textbackground(round(log2(d[i,j])-1));
                                        end;
                                        if (d[i,j]=16) and (hidden=1) then write('  ',d[i,j],' ');
                                        if (d[i,j]>16) and (hidden=1) then
                                        begin
                                                textbackground(bg);
                                                write('  ','?','  ');
                                        end;
                                        if d[i,j]<10 then
                                                write('  ',d[i,j],'  ');
                                        if (d[i,j]>9) and (d[i,j]<100) and (hidden=-1) then
                                                write('  ',d[i,j],' ');
                                        if (d[i,j]>99) and (d[i,j]<1000) and (hidden=-1) then
                                                write(' ',d[i,j],' ');
                                        if (d[i,j]>999) and (d[i,j]<10000) and (hidden=-1) then
                                                write(' ',d[i,j]);
                                        if (d[i,j]>9999) and (d[i,j]<100000) and (hidden=-1) then
                                                write(d[i,j]);
                                        textbackground(bg);
                                        if gfx<>1 then write('|') else write(chr(179));
                                end;
                        end
                        else
                        begin
                                textbackground(txt);
                                write('     ');
                                textbackground(bg);
                                if gfx<>1 then write('|') else write(chr(179));
                        end;
                   end;
                    if (flashlight=1) and (efl=-1) then
                    begin
                        if ((health(d,cs)>2) and (i>=1) and (j<=cs-1)) or ((health(d,cs)<=2) and (i>=2) and (j<=cs-2)) then
                        begin
                             if d[i,j]=0 then
                             if gfx<>1 then write('     |') else write('     ',chr(179));
                             if d[i,j]<>0 then
                             begin
                                  if color<>-1 then
                                  begin
                                        textbackground(round(log2(d[i,j])));
                                        if (round(log2(d[i,j]))+8=txt) or (round(log2(d[i,j]))-8=txt)
                                        then textbackground(round(log2(d[i,j])-1));
                                  end;
                                  if (d[i,j]=16) and (hidden=1) then write('  ',d[i,j],' ');
                                  if (d[i,j]>16) and (hidden=1) then
                                  begin
                                        textbackground(bg);
                                        write('  ','?','  ');
                                  end;
                                  if d[i,j]<10 then
                                     write('  ',d[i,j],'  ');
                                  if (d[i,j]>9) and (d[i,j]<100) and (hidden=-1) then
                                     write('  ',d[i,j],' ');
                                  if (d[i,j]>99) and (d[i,j]<1000) and (hidden=-1) then
                                     write(' ',d[i,j],' ');
                                  if (d[i,j]>999) and (d[i,j]<10000) and (hidden=-1) then
                                     write(' ',d[i,j]);
                                  if (d[i,j]>9999) and (d[i,j]<100000) and (hidden=-1) then
                                     write(d[i,j]);
                                  textbackground(bg);
                                  if gfx<>1 then write('|') else write(chr(179));
                             end;
                        end
                        else
                        begin
                                textbackground(txt);
                                write('     ');
                                textbackground(bg);
                                if gfx<>1 then write('|') else write(chr(179));
                        end;
                    end;
                    textbackground(bg);
          end;
          writeln;
          if i<=cs then
          begin
               for k:=2 to (s-12*(cs+1)) div 3 do
                   write(' ');
               if gfx<>1 then write('|') else write(chr(195));
               for k:=1 to cs do
                   if gfx<>1 then write('-----|') else write(chr(196),chr(196),chr(196),chr(196),chr(196),chr(197));
               if gfx<>1 then write('-----|') else write(chr(196),chr(196),chr(196),chr(196),chr(196),chr(180));
               for k:=2 to (s-12*(cs+1)-((s-12*(cs+1)) div 3)) div 2+1 do
                   write(' ');
               if gfx<>1 then write('|') else write(chr(195));
               for k:=1 to cs do
                   if gfx<>1 then write('-----|') else write(chr(196),chr(196),chr(196),chr(196),chr(196),chr(197));
               if gfx<>1 then writeln('-----|') else writeln(chr(196),chr(196),chr(196),chr(196),chr(196),chr(180));
          end;
     end;
     writeln('Moves P1:',count);
     writeln('Moves P2:',count1);
end;
procedure move(c:char; var a: mang); {moves all number to a side of P1 board}
var i,j,n:byte;
    b:array[0..10,0..10] of longint;
begin
     for i:=0 to cs do
         for j:=0 to cs do
             b[i,j]:=0;
     if c=up then
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
     if c=down then
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
     if c=left then
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
     if c=right then
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
procedure clear(c:char);  {combines 2 numbers when they collide on P1 Board}
var i,j,k:byte;
begin
     if c=up then
        for i:=0 to cs-1 do
            for j:=0 to cs do
                if a[i,j]=a[i+1,j] then
                begin
                     a[i,j]:=a[i,j]+a[i+1,j];
                     a[i+1,j]:=0;
                end;
     if c=down then
        for i:=cs-1 downto 0 do
            for j:=0 to cs do
                if a[i,j]=a[i+1,j] then
                begin
                     a[i+1,j]:=a[i,j]+a[i+1,j];
                     a[i,j]:=0;
                end;
     if c=left then
        for i:=0 to cs do
            for j:=0 to cs-1 do
                if a[i,j]=a[i,j+1] then
                begin
                     a[i,j]:=a[i,j]+a[i,j+1];
                     a[i,j+1]:=0;
                end;
     if c=right then
        for i:=0 to cs do
            for j:=cs-1 downto 0 do
                if a[i,j]=a[i,j+1] then
                begin
                     a[i,j+1]:=a[i,j]+a[i,j+1];
                     a[i,j]:=0;
                end;
     move(c, a);
end;
procedure clear1(c:char);{combines 2 numbers when they collide on P2 board}
var i,j,k:byte;
begin
     if c=up1 then
        for i:=0 to cs-1 do
            for j:=0 to cs do
                if d[i,j]=d[i+1,j] then
                begin
                     d[i,j]:=d[i,j]+d[i+1,j];
                     d[i+1,j]:=0;
                end;
     if c=down1 then
        for i:=cs-1 downto 0 do
            for j:=0 to cs do
                if d[i,j]=d[i+1,j] then
                begin
                     d[i+1,j]:=d[i,j]+d[i+1,j];
                     d[i,j]:=0;
                end;
     if c=left1 then
        for i:=0 to cs do
            for j:=0 to cs-1 do
                if d[i,j]=d[i,j+1] then
                begin
                     d[i,j]:=d[i,j]+d[i,j+1];
                     d[i,j+1]:=0;
                end;
     if c=right1 then
        for i:=0 to cs do
            for j:=cs-1 downto 0 do
                if d[i,j]=d[i,j+1] then
                begin
                     d[i,j+1]:=d[i,j]+d[i,j+1];
                     d[i,j]:=0;
                end;
     move(c, d);
end;
procedure readf;    {reads configurations from a file}
var f:text;
begin
     assign(f,'record.txt');
     reset(f);
     readln(f,fnum,fmove);
     readln(f,username);
     readln(f,txt);
     readln(f,bg);
     readln(f,color);
     readln(f,up);
     readln(f,down);
     readln(f,left);
     readln(f,right);
     readln(f,re);
     readln(f,efl);
     readln(f,soun);
     readln(f,gfx);
     readln(f,s);
     readln(f,up1);
     readln(f,down1);
     readln(f,left1);
     readln(f,right1);
     readln(f,re1);
     close(f);
     if (bg=0) and (txt=0) then bg:=15;
     if color=0 then color:=-1;
     if up=#26 then up:='H';
     if down=#26 then down:='P';
     if left=#26 then left:='K';
     if right=#26 then right:='M';
     if re=#26 then re:='r';
     if up1=#26 then up1:='w';
     if down1=#26 then down1:='s';
     if left1=#26 then left1:='a';
     if right1=#26 then right1:='d';
     if re1=#26 then re1:='z';
     if efl=0 then efl:=-1;
     if soun=0 then soun:=-1;
     if gfx=0 then gfx:=-1;
     if s=0 then s:=80;
end;
procedure writef1;    {writes configuration to a file}
var f:text;
begin
     assign(f,'record.txt');
     rewrite(f);
     writeln(f,fnum,' ',fmove);
     writeln(f,username);
     writeln(f,txt);
     writeln(f,bg);
     writeln(f,color);
     writeln(f,up);
     writeln(f,down);
     writeln(f,left);
     writeln(f,right);
     writeln(f,re);
     writeln(f,efl);
     writeln(f,soun);
     writeln(f,gfx);
     writeln(f,s);
     writeln(f,up1);
     writeln(f,down1);
     writeln(f,left1);
     writeln(f,right1);
     writeln(f,re1);
     close(f);
end;
function maxnum(a:mang;cs:byte):longint; {determines what number is the largest on the board}
var i,j,m:longint;
begin
     m:=a[0,0];
     for i:=0 to cs do
         for j:=0 to cs do
             if a[i,j]>m then m:=a[i,j];
     maxnum:=m;
end;
procedure writef; {writes configuration to a file}
var f:text;
begin
     assign(f,'record.txt');
     rewrite(f);
     writeln(f,point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1),' ',maxnum(a,cs));
     writeln(f,username);
     writeln(f,txt);
     writeln(f,bg);
     writeln(f,color);
     writeln(f,up);
     writeln(f,down);
     writeln(f,left);
     writeln(f,right);
     writeln(f,re);
     writeln(f,efl);
     writeln(f,soun);
     writeln(f,gfx);
     writeln(f,s);
     writeln(f,up1);
     writeln(f,down1);
     writeln(f,left1);
     writeln(f,right1);
     writeln(f,re1);
     close(f);
end;
procedure save;  {saves game to a file}
var i,j:byte;
    f:text;
    c:char;
begin
     if (checkfile('save.txt')=true) and (loaded=false) then
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
          write(f,ch2,' ',diff1,' ',count,' ',hidden,' ',hardrock,' ',spunout,' ',nofail,' ',flashlight);
          writeln(f);
          write(f,efl,' ',x,' ',y);
          close(f);
     end;
end;
procedure load; {loads game from a file}
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
        readln(f,ch2,diff1,count,hidden,hardrock,spunout,nofail,flashlight);
        readln(f,efl,x,y);
        if hidden=0 then hidden:=-1;
        if hardrock=0 then hardrock:=-1;
        if spunout=0 then spunout:=-1;
        if nofail=0 then nofail:=-1;
        if flashlight=0 then flashlight:=-1;
        if efl=0 then efl:=-1;
        close(f);
end;
procedure cleargame;   {deletes save file}
var f:text;
begin
     assign(f,'save.txt');
     erase(f);
end;
procedure menu1;
var k:byte;
begin
     clrscr;
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('2048 Remastered',s);
     for k:=1 to s-1 do
         write('-');
     writeln;
     calibrate('Hit 1 to start a single player game',s+4);
     calibrate('Hit 2 to access user preferences',s);
     if checkfile('save.txt')=true then
          calibrate('Hit 3 to load your game',s-9)
     else
         writeln;
     calibrate('Hit 4 to use mods',s-14);
     for i:=1 to (s-32) div 2 do
        write(' ');
     write('Hit 5 to change final score ');writeln('(',diff,')');
     for i:=1 to (s-32) div 2 do
        write(' ');
     write('Hit 6 to change difficulty ');writeln('(',chr(ord(ch3)+1),'x)');
     if s>=80 then calibrate('Hit 7 to start a multiplayer game',s+2) else writeln;
     if checkfile('save.txt')=true then
        calibrate('Hit d to clear your game',s-8)
     else
         writeln;
     calibrate('Hit esc to Exit',s-16);
     calibrate('Update 5.2.3',s-20);
     writeln;
     for i:=1 to (s-32) div 2 do
        write(' ');
     writeln(username);
     for i:=1 to (s-32) div 2 do
        write(' ');
     write('Score:',fnum);
     writeln;
     for i:=1 to (s-32) div 2 do
        write(' ');
     write('Max number:',fmove);
     if (s>=80) and (gfx<>-1) then
        begin
           gotoxy((s-34) div 2-2,1);
           write(chr(201));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(187));
           for i:=1 to 16 do
           begin
                gotoxy((s-34) div 2-2,i+1);
                write(chr(186));
                gotoxy((s-34) div 2+37,i+1);
                write(chr(186));
           end;
           gotoxy((s-34) div 2-2,3);
           write(chr(204));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(185));
           gotoxy((s-34) div 2-2,18);
           write(chr(200));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(188));
           gotoxy((s-34) div 2-2,14);
           write(chr(204));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(185));
        end;
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
     writeln;
     calibrate('Hit esc to exit',s-2);
     if (gfx<>-1) then
        begin
           gotoxy((s-20) div 2-2,1);
           write(chr(201));
           for i:=1 to 22 do
               write(chr(205));
           write(chr(187));
           for i:=1 to 11 do
           begin
                gotoxy((s-20) div 2-2,i+1);
                write(chr(186));
                gotoxy((s-20) div 2+21,i+1);
                write(chr(186));
           end;
           gotoxy((s-20) div 2-2,3);
           write(chr(204));
           for i:=1 to 22 do
               write(chr(205));
           write(chr(185));
           gotoxy((s-20) div 2-2,13);
           write(chr(200));
           for i:=1 to 22 do
               write(chr(205));
           write(chr(188));
        end;
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
     writeln;
     calibrate('Hit esc to exit',s-2);
     if (gfx<>-1) then
        begin
           gotoxy((s-20) div 2-2,1);
           write(chr(201));
           for i:=1 to 22 do
               write(chr(205));
           write(chr(187));
           for i:=1 to 9 do
           begin
                gotoxy((s-20) div 2-2,i+1);
                write(chr(186));
                gotoxy((s-20) div 2+21,i+1);
                write(chr(186));
           end;
           gotoxy((s-20) div 2-2,3);
           write(chr(204));
           for i:=1 to 22 do
               write(chr(205));
           write(chr(185));
           gotoxy((s-20) div 2-2,11);
           write(chr(200));
           for i:=1 to 22 do
               write(chr(205));
           write(chr(188));
        end;
end;
procedure menu4;
begin
        clrscr;
        for i:=1 to s-1 do write('-');
        writeln;
        calibrate('User preferences',s);
        for i:=1 to s-1 do write('-');
        writeln;
        calibrate('Hit 1 to use dark theme',s-14);
        calibrate('Hit 2 to use light theme',s-13);
        {calibrate('Hit 3 to change between 40/80 columns',s);}
        calibrate('Hit 3 to trigger widescreen mode',s-5);
        calibrate('Hit 4 to change username',s-13);
        calibrate('Hit 5 to change keyboard bindings',s-4);
        if color=-1 then calibrate('Hit 6 to turn on color',s-15)
        else calibrate('Hit 6 to turn off color',s-14);
        if efl=1 then calibrate('Hit 7 to turn off enhanced flashlight',s)
        else calibrate('Hit 7 to turn on enhanced flashlight',s-1);
        if soun=1 then calibrate('Hit 8 to turn off sound',s-15)
        else calibrate('Hit 8 to turn on sound',s-15);
        if gfx=1 then calibrate('Hit 9 to turn on low settings',s-8)
        else calibrate('Hit 9 to turn on high settings',s-8);
        writeln;
        calibrate('Hit esc to exit',s-22);
        if (s>=80) and (gfx<>-1) then
        begin
           gotoxy((s-34) div 2-3,1);
           write(chr(201));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(187));
           for i:=1 to 13 do
           begin
                gotoxy((s-34) div 2-3,i+1);
                write(chr(186));
                gotoxy((s-34) div 2+36,i+1);
                write(chr(186));
           end;
           gotoxy((s-34) div 2-3,3);
           write(chr(204));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(185));
           gotoxy((s-34) div 2-3,15);
           write(chr(200));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(188));
        end;
end;
procedure menu5;
var k:byte;
begin
        clrscr;
        for i:=1 to s-1 do write('-');
        writeln;
        calibrate('Keyboard bindings',s);
        for i:=1 to s-1 do write('-');
        writeln;
        calibrate('Hit 1 to reassign player 1 up key',s-4);
        calibrate('Hit 2 to reassign player 1 down key',s-2);
        calibrate('Hit 3 to reassign player 1 left key',s-2);
        calibrate('Hit 4 to reassign player 1 right key',s-1);
        calibrate('Hit 5 to reassign player 1 rewind key',s);
        calibrate('Hit 6 to reassign player 2 up key',s-4);
        calibrate('Hit 7 to reassign player 2 down key',s-2);
        calibrate('Hit 8 to reassign player 2 left key',s-2);
        calibrate('Hit 9 to reassign player 2 right key',s-1);
        calibrate('Hit 0 to reassign player 2 rewind key',s);
        writeln;
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('up1: ',up,'           up2: ',up1);
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('down1: ',down,'         down2: ',down1);
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('left1: ', left,'         left2: ',left1);
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('right1: ',right,'        right2: ',right1);
        for k:=1 to (s-28) div 2 do
        write(' ');
        writeln('rewind1: ',re,'       rewind2: ',re1);
        writeln;
        calibrate('Hit esc to exit',s-13);
        if (s>=80) and (gfx<>-1) then
        begin
           gotoxy((s-34) div 2-3,1);
           write(chr(201));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(187));
           for i:=1 to 20 do
           begin
                gotoxy((s-34) div 2-3,i+1);
                write(chr(186));
                gotoxy((s-34) div 2+36,i+1);
                write(chr(186));
           end;
           gotoxy((s-34) div 2-3,3);
           write(chr(204));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(185));
           gotoxy((s-34) div 2-3,22);
           write(chr(200));
           for i:=1 to 38 do
               write(chr(205));
           write(chr(188));
        end;
end;
begin
     s:=80;
     hidden:=-1;hardrock:=-1;spunout:=-1;nofail:=-1;flashlight:=-1;cs:=3;easy:=-1;wide:=false;
     ch3:='1';ch2:='1';diff:=512;up:='H';down:='P';left:='K';right:='M';re:='r';
     bg:=0;txt:=15;color:=-1;efl:=-1;soun:=-1;gfx:=-1;
     up1:='w';down1:='s';left1:='a';right1:='d';re1:='z';
     repeat
           count:=0;count1:=0;if checkfile('record.txt')=true then readf;moved:=false;loaded:=false;
           {if s=40 then textmode(c40) else textmode(c80);}
           if s>=120 then wide:=true else wide:=false;
           textcolor(txt);
           textbackground(bg);
           lowvideo;
           x:=4;y:=4;x1:=4;y1:=4;j:=4;
           repeat
                if (username='') or (length(username)>16) then username:='Guest';
                menu1;
                repeat
                      gotoxy((s-32) div 2-2,x);write('->');
                      repeat
                            ch:=readkey;
                      until (ch='1') or (ch='2') or (ch='3') or (ch='4') or (ch='d') or (ch=chr(27)) or (ch='5') or (ch='6')
                      or ((ch='7') and (s>=80)) or ((ch=#72) and (x>4)) or ((ch=#80) and (x<12)) or (ch=#13);
                if (ch=#72) then
                begin
                     gotoxy((s-32) div 2-2,x);write('  ');
                     x:=x-1;
                end;
                if (ch=#80) then
                begin
                     gotoxy((s-32) div 2-2,x);write('  ');
                     x:=x+1;
                end;
                until (ch='1') or (ch='2') or (ch='3') or (ch='4') or (ch='d') or (ch=chr(27)) or (ch='5') or (ch='6')
                or ((ch='7') and (s>=80)) or (ch=#13);
                if (ch=#13) then
                begin
                     str(x-3,s1);
                     if not ((x-3=7) and (s<80)) then
                        ch:=s1[1];
                     if ch='8' then ch:='d';
                     if ch='9' then ch:=#27;
                end;
                if ch='2' then
                repeat
                        case wide of
                              true:s:=120;
                              false:s:=80;
                        end;
                        menu4;
                        repeat
                              if y<13 then
                                 gotoxy((s-34) div 2-2,y)
                              else
                                  gotoxy((s-34) div 2-2,y+1);
                              write('>');
                              if (gfx=-1) or (s<80) then
                                 gotoxy(1,16);
                              repeat
                                    ch4:=readkey;
                              until (ch4='8') or (ch4='1') or (ch4='2') or (ch4='7') or (ch4=chr(27))
                              or (ch4='4') or (ch4='5') or (ch4='6') or (ch4='9') or (ch4='3')
                              or ((ch4=#72) and (y>4)) or ((ch4=#80) and (y<13)) or (ch4=#13);
                        if ch4=#72 then
                        begin
                             if y<13 then
                                 gotoxy((s-34) div 2-2,y)
                             else
                                 gotoxy((s-34) div 2-2,y+1);
                             write(' ');
                             y:=y-1;
                        end;
                        if ch4=#80 then
                        begin
                             if y<13 then
                                gotoxy((s-34) div 2-2,y)
                             else
                                 gotoxy((s-34) div 2-2,y+1);
                             write(' ');
                             y:=y+1;
                        end;
                        until (ch4='8') or (ch4='1') or (ch4='2') or (ch4='7') or (ch4=chr(27))
                        or (ch4='4') or (ch4='5') or (ch4='6') or (ch4='9') or (ch4='3') or (ch4=#13);
                        if ch4=#13 then
                        begin
                             str(y-3,s1);
                             ch4:=s1[1];
                             if s1='10' then ch4:=#27;
                        end;
                        if ch4='1' then
                        begin
                                bg:=0;txt:=15;
                                textcolor(txt);
                                textbackground(bg);
                                lowvideo;
                                writef1;
                        end;
                        if ch4='2' then
                        begin
                                bg:=15;txt:=0;
                                textcolor(txt);
                                textbackground(bg);
                                writef1;
                        end;
                        if ch4='3' then
                        begin
                             case s of
                             80:begin
                                        wide:=true;
                                        s:=120;
                             end;
                             120:begin
                                        wide:=false;
                                        s:=80;
                             end;
                             end;
                             writef1;
                        end;
                        {if ch4='3' then
                        begin
                           case s of
                                80:begin
                                        s:=40;
                                        textmode(c40);
                                   end;
                                40:begin
                                        s:=80;
                                        textmode(c80);
                                   end;
                           end;
                           textbackground(bg);
                           textcolor(txt);
                           writef1;
                        end;}
                        if ch4='6' then
                        begin
                                color:=color*-1;
                                writef1;
                        end;
                        if ch4='7' then
                        begin
                                efl:=efl*-1;
                                writef1;
                        end;
                        if ch4='8' then
                        begin
                                soun:=soun*-1;
                                writef1;
                        end;
                        if ch4='9' then
                        begin
                                gfx:=gfx*-1;
                                writef1;
                        end;
                        if ch4='4' then
                        begin
                                if (s>=80) and (gfx<>-1) then
                                begin
                                     gotoxy((s-34) div 2-3,6);
                                     write(chr(201));
                                     for i:=1 to 38 do
                                         write(chr(205));
                                     write(chr(187));
                                     gotoxy((s-34) div 2-3,8);
                                     write(chr(204));
                                     for i:=1 to 38 do
                                         write(chr(205));
                                     write(chr(185));
                                     gotoxy((s-34) div 2-3,10);
                                     write(chr(200));
                                     for i:=1 to 38 do
                                         write(chr(205));
                                     write(chr(188));
                                     gotoxy((s-34) div 2-2,7);
                                     writeln('        Type your new username');
                                     gotoxy((s-34) div 2-2,9);
                                     write('                        ');
                                     gotoxy((s-34) div 2-2,9);
                                end
                                else
                                    writeln('Type your new username');
                                readln(username);
                                writef1;
                        end;
                        if ch4='5' then
                        repeat
                                menu5;
                                repeat
                                      if x1<14 then
                                         gotoxy((s-34) div 2-2,x1)
                                      else
                                          gotoxy((s-28) div 2,21);
                                      write('>');
                                      if (gfx=-1) or (s<80) then
                                         gotoxy(1,23);
                                      repeat
                                            ch5:=readkey;
                                      until (ch5='1') or (ch5='2') or (ch5='3') or (ch5='4') or (ch5='5') or (ch5=chr(27))
                                      or (ch5='6') or (ch5='7') or (ch5='8') or (ch5='9') or (ch5='0')
                                      or ((ch5=#72) and (x1>4)) or ((ch5=#80) and (x1<14)) or (ch5=#13);
                                      if ch5=#72 then
                                      begin
                                           if x1<14 then
                                              gotoxy((s-34) div 2-2,x1)
                                           else
                                               gotoxy((s-28) div 2,21);
                                           write(' ');
                                           x1:=x1-1;
                                      end;
                                      if ch5=#80 then
                                      begin
                                           if x1<14 then
                                              gotoxy((s-34) div 2-2,x1)
                                           else
                                               gotoxy((s-28) div 2,21);
                                           write(' ');
                                           x1:=x1+1;
                                      end;
                                until (ch5='1') or (ch5='2') or (ch5='3') or (ch5='4') or (ch5='5') or (ch5=chr(27))
                                or (ch5='6') or (ch5='7') or (ch5='8') or (ch5='9') or (ch5='0')
                                or (ch5=#13);
                                if ch5=#13 then
                                begin
                                     str(x1-3,s1);
                                     ch5:=s1[1];
                                     if s1='10' then ch5:='0';
                                     if s1='11' then ch5:=#27;
                                end;
                                if (s>=80) and (gfx<>-1) then
                                begin
                                     gotoxy((s-34) div 2-3,6);
                                     write(chr(201));
                                     for i:=1 to 38 do
                                         write(chr(205));
                                     write(chr(187));
                                     gotoxy((s-34) div 2-3,8);
                                     write(chr(200));
                                     for i:=1 to 38 do
                                         write(chr(205));
                                     write(chr(188));
                                     gotoxy((s-34) div 2-2,7);
                                     for i:=1 to 37 do
                                     write(' ');
                                     gotoxy((s-34) div 2-2,7);
                                end;
                                if ch5='1' then
                                begin
                                        writeln('input new key for up1');
                                        repeat
                                                up:=readkey;
                                                if up=#0 then up:=readkey;
                                                writef1;
                                        until (up<>chr(27)) and (up<>down) and (up<>left) and (up<>right) and (up<>re);
                                end;
                                if ch5='2' then
                                begin
                                        writeln('input new key for down1');
                                        repeat
                                                down:=readkey;
                                                if down=#0 then down:=readkey;
                                                writef1;
                                        until (down<>up) and (down<>chr(27)) and (down<>left) and (down<>right) and (down<>re);
                                end;
                                if ch5='3' then
                                begin
                                        writeln('input new key for left1');
                                        repeat
                                                left:=readkey;
                                                if left=#0 then left:=readkey;
                                                writef1;
                                        until (left<>down) and (left<>up) and (left<>chr(27)) and (left<>right) and (left<>re);
                                end;
                                if ch5='4' then
                                begin
                                        writeln('input new key for right1');
                                        repeat
                                                right:=readkey;
                                                if right=#0 then right:=readkey;
                                                writef1;
                                        until (right<>left) and (right<>down)
                                        and (right<>up) and (right<>chr(27)) and (right<>re);
                                end;
                                if ch5='5' then
                                begin
                                        writeln('input new key for rewind1');
                                        repeat
                                                re:=readkey;
                                                if re=#0 then re:=readkey;
                                                writef1;
                                        until (re<>right) and (re<>left) and (re<>down) and (re<>up) and (re<>chr(27));
                                end;
                                if ch5='6' then
                                begin
                                        writeln('input new key for up2');
                                        repeat
                                                up1:=readkey;
                                                if up1=#0 then up1:=readkey;
                                                writef1;
                                        until (up1<>chr(27)) and (up1<>down) and (up1<>left) and (up1<>right) and (up1<>re)
                                        and (up1<>down1) and (up1<>left1) and (up1<>right1) and (up1<>re1) and (up1<>up);
                                end;
                                if ch5='7' then
                                begin
                                        writeln('input new key for down2');
                                        repeat
                                                down1:=readkey;
                                                if down1=#0 then down1:=readkey;
                                                writef1;
                                        until (down1<>up) and (down1<>chr(27)) and (down1<>left) and (down1<>right)
                                        and (down1<>re) and (down1<>up1) and (down1<>down) and (down1<>left1) and
                                        (down1<>right1) and (down1<>re1);
                                end;
                                if ch5='8' then
                                begin
                                        writeln('input new key for left2');
                                        repeat
                                                left1:=readkey;
                                                if left1=#0 then left1:=readkey;
                                                writef1;
                                        until (left1<>down) and (left1<>up) and (left1<>chr(27)) and (left1<>right)
                                        and (left1<>re)
                                        and (left1<>down1) and (left1<>up1) and (left1<>left) and (left1<>right1)
                                        and (left1<>re1);
                                end;
                                if ch5='9' then
                                begin
                                        writeln('input new key for right2');
                                        repeat
                                                right1:=readkey;
                                                if right1=#0 then right1:=readkey;
                                                writef1;
                                        until (right1<>left) and (right1<>down)
                                        and (right1<>up) and (right1<>chr(27)) and (right1<>re)
                                        and (right1<>left1) and (right1<>down1)
                                        and (right1<>up1) and (right1<>right) and (right1<>re1);
                                end;
                                if ch5='0' then
                                begin
                                        writeln('input new key for rewind2');
                                        repeat
                                                re1:=readkey;
                                                if re1=#0 then re1:=readkey;
                                                writef1;
                                        until (re1<>right) and (re1<>left) and (re1<>down) and (re1<>up) and (re1<>chr(27))
                                        and (re1<>right1) and (re1<>left1) and (re1<>down1) and (re1<>up1) and (re1<>re);
                                end;
                        until ch5=chr(27);
                until ch4=chr(27);
                if ch='4' then
                begin
                        repeat
                                clrscr;
                                modsintro(easy,hidden,hardrock,spunout,nofail,flashlight);
                                repeat
                                        ch4:=readkey;
                                until (ch4='h') or (ch4='e') or (ch4='r') or (ch4='s') or (ch4='n')
                                or (ch4='f') or (ch4=chr(27)) or (ch4='1');
                                if ch4='h' then hidden:=hidden*(-1);
                                if ch4='e' then easy:=easy*(-1);
                                if ch4='r' then hardrock:=hardrock*(-1);
                                if ch4='s' then spunout:=spunout*(-1);
                                if ch4='n' then nofail:=nofail*(-1);
                                if ch4='f' then flashlight:=flashlight*(-1);
                                if ch4='1' then
                                begin
                                        hidden:=-1;
                                        easy:=-1;
                                        hardrock:=-1;
                                        spunout:=-1;
                                        nofail:=-1;
                                        flashlight:=-1;
                                end;

                        until ch4=chr(27);
                end;

                if (ch='d') and (checkfile('save.txt')=true) then
                   cleargame;
                if (ch='3') and (checkfile('save.txt')=true) then break;
                if ch='5' then
                begin
                      menu2;
                      repeat
                            if y1<11 then
                                gotoxy((s-17) div 2-2,y1)
                            else
                                gotoxy((s-17) div 2-2,y1+1);
                            write('->');
                            repeat
                            ch2:=readkey;
                            until (ch2='0') or (ch2='1') or (ch2='2') or (ch2='3') or (ch2='4') or (ch2='5') or
                            (ch2='6') or (ch2=chr(27)) or (ch2=#72) or (ch2=#80) or (ch2=#13);
                            if (ch2=#72) and (y1>4) then
                            begin
                                 if y1<11 then
                                     gotoxy((s-17) div 2-2,y1)
                                 else
                                     gotoxy((s-17) div 2-2,y1+1);
                                 write('  ');
                                 y1:=y1-1;
                            end;
                            if (ch2=#80) and (y1<11) then
                            begin
                                 if y1<11 then
                                     gotoxy((s-17) div 2-2,y1)
                                 else
                                     gotoxy((s-17) div 2-2,y1+1);
                                 write('  ');
                                 y1:=y1+1;
                            end;
                      until (ch2='0') or (ch2='1') or (ch2='2') or (ch2='3') or (ch2='4') or (ch2='5')
                      or (ch2='6') or (ch2=chr(27)) or (ch2=#13);
                      if (ch2<>chr(27)) and (ch2<>#80) and (ch2<>#72) and (ch2<>#13) then
                      begin
                           val(ch2,c1,code);
                           if c1>0 then diff:=pow2(c1+8);
                           if c1=0 then diff:=1;
                      end;
                      if ch2=#13 then
                      begin
                           if (y1>4) and (y1<11) then
                           begin
                                diff:=pow2(y1+4);
                                str(log2(diff)-8,s1);
                                ch2:=s1[1];
                           end;
                           if y1=4 then
                           begin
                                diff:=1;
                                ch2:='0';
                           end;
                           if y1=11 then
                           begin
                                str(log2(diff)-8,s1);
                                ch2:=s1[1];
                           end;
                      end;
                end;
                if ch='6' then
                begin
                        menu3;
                        repeat
                              if j<9 then
                                  gotoxy((s-17) div 2-2,j)
                              else
                                  gotoxy((s-17) div 2-2,j+1);
                              write('->');
                              repeat
                                    ch4:=readkey;
                              until (ch4='0') or (ch4='1') or (ch4='2') or (ch4='3') or
                              (ch4='4') or (ch4=#27) or (ch4=#72) or (ch4=#80) or (ch4=#13);
                              if (ch4=#72) and (j>4) then
                              begin
                                   if j<9 then
                                       gotoxy((s-17) div 2-2,j)
                                   else
                                       gotoxy((s-17) div 2-2,j+1);
                                   write('  ');
                                   j:=j-1;
                              end;
                              if (ch4=#80) and (j<9) then
                              begin
                                   if j<9 then
                                       gotoxy((s-17) div 2-2,j)
                                   else
                                       gotoxy((s-17) div 2-2,j+1);
                                   write('  ');
                                   j:=j+1;
                              end;
                        until (ch4='0') or (ch4='1') or (ch4='2') or (ch4='3') or
                        (ch4='4') or (ch4=#27) or (ch4=#13);
                        if (ch4<>#27) and (ch4<>#13) then ch3:=ch4;
                        if (ch4=#13) and (j<9) then
                        begin
                             str(j-4,s1);
                             ch3:=s1[1];
                        end;
                end;
           until (ch='1') or (ch='7') or (ch=chr(27));
           if ch='3' then
           begin
                load;
                loaded:=true;
                val(ch2,c1,code);
                if c1>0 then diff:=pow2(c1+8);
                if c1=0 then
                        diff:=1;
           end;
           if loaded=false then
              begin
                if easy=1 then cs:=4 else cs:=3;
                x:=1;y:=1;
              end;
           if ch=chr(27) then
           begin
                clrscr;
                exit;
           end;
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
                    begin
                        a[i,j]:=0;
                        d[i,j]:=0;
                    end;
                start(a);
                start(d);
           end;
           if (ch='1') or (ch='3') then
           begin
              if gfx<>1 then title else titlegfx;
              repeat
                    gotoxy(1,5);
                    printf;
                    repeat
                          ch:=readkey;
                    until (ch=up) or (ch=down) or (ch=left) or (ch=right) or (ch=re) or (ch=chr(27));
                    if (count>0) and (ch=re) and (moved=true) then rewind;
                    if (ch=up) or (ch=down) or (ch=left) or (ch=right) then
                    begin
                         if (ch=left) and (y>1) then y:=y-1;
                         if (ch=right) and (y<cs-1) then y:=y+1;
                         if (ch=up) and (x>1) then x:=x-1;
                         if (ch=down) and (x<cs-1) then x:=x+1;
                         moved:=true;
                         backup;
                         move(ch, a);
                         if spunout<>1 then
                            clear(ch)
                         else
                             for i:=1 to 11 do
                                 clear(ch);
                         if difference(a,c,cs)=true then
                         begin
                              if soun=1 then
                              begin
                                   sound(1000);
                                   delay(100);
                                   nosound;
                              end;
                              for i:=1 to diff1+1 do
                                  if hardrock=-1 then
                                     spawn(a)
                                  else
                                      spawnhardrock(a);
                              count:=count+1;
                         end;
                    end;
                    if ch=chr(27) then
                    begin
                         ch:=#0;
                         writeln('PAUSED');
                         writeln('Press y to return to menu');
                         writeln('Press n to continue');
                         writeln('Press s to save your game and return to menu');
                         writeln('Press q to save and continue');
                         repeat
                               ch:=readkey;
                         until (ch='y') or (ch='n') or (ch='s') or (ch='q');
                         if (ch='y') or (ch='s') then break;
                         if ch='q' then
                         begin
                              save;
                              if gfx<>1 then title else titlegfx;
                         end;
                         if ch='n' then
                            if gfx<>1 then title else titlegfx;
                    end;
                    if (lose(a,cs)=true) and (nofail=1) then conti(a);
              until (win(a,diff,cs)=true) or (lose(a,cs)=true);
              if (point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1)>fnum) then
                 writef;
              repeat
                    if win(a,diff,cs)=true then
                    begin
                         flashlight:=-1;
                         hidden:=-1;
                         if gfx<>1 then title else titlegfx;
                         printf;
                         writeln('YOU WON');
                         if soun=1 then winningtune;
                    end;
                    if lose(a,cs)=true then
                    begin
                         flashlight:=-1;
                         hidden:=-1;
                         if gfx<>1 then title else titlegfx;
                         printf;
                         writeln('YOU LOST');
                         if soun=1 then losingtune;
                    end;
                    if ch='s' then save;
                    if (ch='y') or (ch='s') then ch1:='y';
                    if (ch<>'y') and (ch<>'s') then
                    begin
                         writeln('Hit ESC to return to menu');
                         repeat
                               ch1:=readkey;
                         until ch1=chr(27);
                    end;
              until (ch1='y') or (ch1='n') or (ch1=chr(27));
           end;
           if ch='7' then
           begin
              x1:=1;x:=1;y1:=1;y:=1;
              if gfx<>1 then title else titlegfx;
              repeat
                    gotoxy(1,5);
                    printfmulti;
                    repeat
                          ch:=readkey;
                    until (ch=up) or (ch=down) or (ch=left) or (ch=right) or (ch=re) or (ch=chr(27))
                    or (ch=up1) or (ch=down1) or (ch=left1) or (ch=right1) or (ch=re1);
                    if (count>0) and (ch=re) and (moved=true) then rewind;
                    if (count1>0) and (ch=re1) and (moved1=true) then rewind1;
                    if (ch=up) or (ch=down) or (ch=left) or (ch=right) then
                    begin
                         if (ch=left) and (y>1) then y:=y-1;
                         if (ch=right) and (y<cs-1) then y:=y+1;
                         if (ch=up) and (x>1) then x:=x-1;
                         if (ch=down) and (x<cs-1) then x:=x+1;
                         moved:=true;
                         backup;
                         move(ch, a);
                         if spunout<>1 then
                            clear(ch)
                         else
                             for i:=1 to 11 do
                                 clear(ch);
                         if difference(a,c,cs)=true then
                         begin
                              if soun=1 then
                              begin
                                   sound(1000);
                                   delay(100);
                                   nosound;
                              end;
                              for i:=1 to diff1+1 do
                                  if hardrock=-1 then
                                     spawn(a)
                                  else
                                      spawnhardrock(a);
                              count:=count+1;
                         end;
                    end;
                    if (ch=up1) or (ch=down1) or (ch=left1) or (ch=right1) then
                    begin
                         if (ch=left1) and (y1>1) then y1:=y1-1;
                         if (ch=right1) and (y1<cs-1) then y1:=y1+1;
                         if (ch=up1) and (x1>1) then x1:=x1-1;
                         if (ch=down1) and (x1<cs-1) then x1:=x1+1;
                         moved1:=true;
                         backup1;
                         move(ch, d);
                         if spunout<>1 then
                            clear1(ch)
                         else
                             for i:=1 to 11 do
                                 clear1(ch);
                         if difference(d,e,cs)=true then
                         begin
                              if soun=1 then
                              begin
                                   sound(1000);
                                   delay(100);
                                   nosound;
                              end;
                              for i:=1 to diff1+1 do
                                  if hardrock=-1 then
                                     spawn(d)
                                  else
                                      spawnhardrock(d);
                              count1:=count1+1;
                         end;
                    end;
                    if ch=chr(27) then
                    begin
                         ch:=#0;
                         writeln('PAUSED');
                         writeln('Press y to return to menu');
                         writeln('Press n to continue');
                         {writeln('Press s to save your game and return to menu');
                         writeln('Press q to save and continue');}
                         repeat
                               ch:=readkey;
                         until (ch='y') or (ch='n') {or (ch='s') or (ch='q')};
                         if (ch='y') or (ch='s') then break;
                         if ch='q' then
                         begin
                              save;
                              if gfx<>1 then title else titlegfx;
                         end;
                         if ch='n' then
                            if gfx<>1 then title else titlegfx;
                    end;
                    if (lose(a,cs)=true) and (nofail=1) then conti(a);
                    if (lose(d,cs)=true) and (nofail=1) then conti(d);
              until (win(a,diff,cs)=true) or (lose(a,cs)=true)
              or (win(d,diff,cs)=true) or (lose(d,cs)=true);
              if (point(a,cs,hidden,hardrock,spunout,nofail,flashlight,diff1)>fnum) then
                 writef;
              repeat
                    if (win(a,diff,cs)=true) or (lose(d,cs)=true) then
                    begin
                         flashlight:=-1;
                         hidden:=-1;
                         if gfx<>1 then title else titlegfx;
                         printfmulti;
                         writeln('PLAYER 1 WON');
                         if soun=1 then winningtune;
                    end;
                    if (win(d,diff,cs)=true) or (lose(a,cs)=true) then
                    begin
                         flashlight:=-1;
                         hidden:=-1;
                         if gfx<>1 then title else titlegfx;
                         printfmulti;
                         writeln('PLAYER 2 WON');
                         if soun=1 then winningtune;
                    end;
                    if ch='s' then save;
                    if (ch='y') or (ch='s') then ch1:='y';
                    if (ch<>'y') and (ch<>'s') then
                    begin
                         writeln('Hit ESC to return to menu');
                         repeat
                               ch1:=readkey;
                         until ch1=chr(27);
                    end;
              until (ch1='y') or (ch1='n') or (ch1=chr(27));
           end;
     until ch1='n';
end.
