uses crt;
type mang=array[0..10,0..10] of longint;
var a,c:mang;
        i,j,diff,diff1,difftotal,code,count:word;
        ch,ch1,ch2,ch3:char;
        fmove,fnum:longint;
        moved,loaded,easy:boolean;
        hidden,hardrock:shortint;
        cs:byte;
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
a[i,j]:=random(17);
until (a[i,j]=0) or (a[i,j]=2) or (a[i,j]=4) or (a[i,j]=8);
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
writeln('-------------------------------------------------------------------------------');
if diff1=0 then
writeln('                                  EASY ',diff);
if diff1=1 then
writeln('                                  NORMAL ',diff);
if diff1=2 then
writeln('                                   HARD ',diff);
if diff1=3 then
writeln('                                VERY HARD ',diff);
if diff1=4 then
writeln('                                  MASTER ',diff);
writeln('-------------------------------------------------------------------------------');
for i:=1 to difftotal do
write('* ');
writeln;
writeln('-------------------------------------------------------------------------------');
if lose(a,cs)=false then
for i:=1 to health(a,cs) do
write('##');
for i:=1 to sqr(cs+1)-health(a,cs) do
write('  ');
if lose(a,cs)=false then
write('|')
else write('  |');
writeln;
writeln('-------------------------------------------------------------------------------');
for i:=0 to cs do
begin
write('                          |');
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
if i<cs then
begin
write('                          |');
for k:=1 to cs do
write('------');
writeln('-----|');
end;
end;
writeln('-------------------------------------------------------------------------------');
writeln('                                 Moves:',count);
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
for j:=0 to cs-1 do
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
writeln(f,maxnum(a,cs),' ',count);
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
writeln('If you attempt to save,the save file will be overwrite');
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
write(f,ch2,' ',diff1,' ',count,' ',hidden,' ',hardrock);
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
readln(f,ch2,diff1,count,hidden,hardrock);
if hidden=0 then hidden:=-1;
if hardrock=0 then hardrock:=-1;
close(f);
end;
procedure cleargame;
var f:text;
begin
assign(f,'save.txt');
erase(f);
end;
procedure menu1;
begin
clrscr;
writeln('-------------------------------------------------------------------------------');
writeln('                               2048 Lite for DOS');
writeln('-------------------------------------------------------------------------------');
writeln('                            Hit 1 to start a game');
writeln('                            Hit 2 to use Night theme');
writeln('                            Hit 3 to use Classic theme');
if checkfile('save.txt')=true then
begin
writeln('                            Hit 4 to load your game');
writeln('                            Hit d to clear your game');
end;
if hidden=-1 then
writeln('                            Hit 5 to turn on hidden mod')
else
writeln('                            Hit 5 to turn off hidden mod');
if easy=true then
writeln('                            Hit 6 to turn off easy mod')
else
writeln('                            Hit 6 to turn on easy mod');
if hardrock=-1 then
writeln('                            Hit 7 to turn on hard rock mod')
else
writeln('                            Hit 7 to turn off hard rock mod');
writeln('                            Hit esc to Exit');
writeln('                            UPDATE 2.2');
writeln('                            RECORD:',fnum,';moves:',fmove);
end;
procedure menu2;
begin
clrscr;
writeln('-------------------------------------------------------------------------------');
writeln('                              Select Target Number');
writeln('-------------------------------------------------------------------------------');
writeln('                               Hit 0 for endless');
writeln('                               Hit 1 for 512');
writeln('                               Hit 2 for 1024');
writeln('                               Hit 3 for 2048');
writeln('                               Hit 4 for 4096');
writeln('                               Hit 5 for 8192');
writeln('                               Hit 6 for 16384');
end;
procedure menu3;
begin
clrscr;
writeln('-------------------------------------------------------------------------------');
writeln('                               Select Difficulty');
writeln('-------------------------------------------------------------------------------');
writeln('                               Hit 0 for easy');
writeln('                               Hit 1 for normal');
writeln('                               Hit 2 for hard');
writeln('                               Hit 3 for very hard');
writeln('                               Hit 4 for extreme');
end;
begin
hidden:=-1;hardrock:=-1;cs:=3;easy:=false;
textcolor(black);
textbackground(white);
repeat
count:=0;if checkfile('record.txt')=true then readf;moved:=false;loaded:=false;
repeat
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
if ch='7' then hardrock:=hardrock*(-1);
if (ch='d') and (checkfile('save.txt')=true) then
cleargame;
if (ch='4') and (checkfile('save.txt')=true) then break;
if ch='6' then
if easy=true then easy:=false
else easy:=true;
until (ch='1') or (ch=chr(27));
if ch='4' then
begin
load;
loaded:=true;
end;
if loaded=false then
if easy=true then cs:=4
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
until (win(a,diff,cs)=true) or (lose(a,cs)=true);
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
if maxnum(a,cs)>fnum then
writef;
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
