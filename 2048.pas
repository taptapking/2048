uses crt;
type mang=array[0..3,0..3] of longint;
var a,c:mang;
        i,j,diff,count:word;
        ch,ch1:char;
        fmove,fnum:longint;
function checkfile:boolean;
var f:text;
    chk:boolean;
begin
assign(f,'record.txt');
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
for i:=0 to 3 do
for j:=0 to 3 do
a[i,j]:=c[i,j];
end;
procedure backup;
var i,j:byte;
begin
for i:=0 to 3 do
for j:=0 to 3 do
c[i,j]:=a[i,j];
end;
function difference(a,b:mang):boolean;
var i,j:byte;
    chk:boolean;
begin
chk:=false;
for i:=0 to 3 do
for j:=0 to 3 do
if a[i,j]<>b[i,j] then chk:=true;
difference:=chk;
end;
function win(a:mang;n:word):boolean;
var i,j:byte;
begin
win:=false;
for i:=0 to 3 do
for j:=0 to 3 do
if a[i,j]=n then win:=true;
end;
function lose(a:mang):boolean;
var i,j:byte;
begin
lose:=true;
for i:=0 to 3 do
for j:=0 to 2 do
if a[i,j]=a[i,j+1] then lose:=false;
for i:=0 to 2 do
for j:=0 to 3 do
if a[i,j]=a[i+1,j] then lose:=false;
for i:=0 to 3 do
for j:=0 to 3 do
if a[i,j]=0 then lose:=false;
end;
procedure start;
var i,j,k:byte;
    check:boolean;
begin
randomize;
for k:=1 to 3 do
begin
check:=false;
for i:=0 to 3 do
for j:=0 to 3 do
if a[i,j]=0 then check:=true;
if check=true then
repeat
i:=random(4);
j:=random(4);
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
for i:=0 to 3 do
for j:=0 to 3 do
if a[i,j]=0 then check:=true;
if check=true then
begin
repeat
i:=random(4);
j:=random(4);
until a[i,j]=0;
repeat
a[i,j]:=random(5);
until a[i,j] mod 2=0;
end;
end;
procedure printf;
var i,j:byte;
begin
writeln('-------------------------------------------------------------------------------');
if diff=512 then
writeln('                                BEGINNER:512');
if diff=1024 then
writeln('                                  EASY:1024');
if diff=2048 then
writeln('                                 NORMAL:2048');
if diff=4096 then
writeln('                                  HARD:4096');
if diff=8192 then
writeln('                                VERY HARD:8192');
if diff=16384 then
writeln('                                MASTER:16384');
if diff=1 then
writeln('                                   ENDLESS');
writeln('-------------------------------------------------------------------------------');
for i:=0 to 3 do
begin
write('                          |');
for j:=0 to 3 do
if a[i,j]<>0 then
begin
if a[i,j]<10 then
write('  ',a[i,j],'  |');
if (a[i,j]>9) and (a[i,j]<100) then
write('  ',a[i,j],' |');
if (a[i,j]>99) and (a[i,j]<1000) then
write(' ',a[i,j],' |');
if (a[i,j]>999) and (a[i,j]<10000) then
write(a[i,j],' |');
if (a[i,j]>9999) and (a[i,j]<100000) then
write(a[i,j],'|');
end
else write('     |');
writeln;
if i<3 then
writeln('                          |-----------------------|');
end;
writeln('-------------------------------------------------------------------------------');
writeln('                                 Moves:',count);
end;
procedure move(c:char);
var i,j,n:byte;
    b:array[0..3,0..3] of longint;
begin
for i:=0 to 3 do
for j:=0 to 3 do
b[i,j]:=0;
if c=#72 then
for j:=0 to 3 do
begin
n:=0;
for i:=0 to 3 do
if a[i,j]<>0 then
begin
b[n,j]:=a[i,j];
n:=n+1;
end;
end;
if c=#80 then
for j:=0 to 3 do
begin
n:=0;
for i:=3 downto 0 do
if a[i,j]<>0 then
begin
b[3-n,j]:=a[i,j];
n:=n+1;
end;
end;
if c=#75 then
for i:=0 to 3 do
begin
n:=0;
for j:=0 to 3 do
if a[i,j]<>0 then
begin
b[i,n]:=a[i,j];
n:=n+1;
end;
end;
if c=#77 then
for i:=0 to 3 do
begin
n:=0;
for j:=3 downto 0 do
if a[i,j]<>0 then
begin
b[i,3-n]:=a[i,j];
n:=n+1;
end;
end;
for i:=0 to 3 do
for j:=0 to 3 do
a[i,j]:=b[i,j];
end;
procedure clear(c:char);
var i,j,k:byte;
begin
if c=#72 then
for i:=0 to 2 do
for j:=0 to 3 do
if a[i,j]=a[i+1,j] then
begin
a[i,j]:=a[i,j]+a[i+1,j];
a[i+1,j]:=0;
end;
if c=#80 then
for i:=2 downto 0 do
for j:=0 to 3 do
if a[i,j]=a[i+1,j] then
begin
a[i+1,j]:=a[i,j]+a[i+1,j];
a[i,j]:=0;
end;
if c=#75 then
for i:=0 to 3 do
for j:=0 to 2 do
if a[i,j]=a[i,j+1] then
begin
a[i,j]:=a[i,j]+a[i,j+1];
a[i,j+1]:=0;
end;
if c=#77 then
for i:=0 to 3 do
for j:=2 downto 0 do
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
function maxnum(a:mang):longint;
var i,j,m:longint;
begin
m:=a[0,0];
for i:=0 to 3 do
for j:=0 to 3 do
if a[i,j]>m then m:=a[i,j];
maxnum:=m;
end;
procedure writef;
var f:text;
begin
assign(f,'record.txt');
rewrite(f);
writeln(f,maxnum(a),' ',count);
close(f);
end;
begin
textcolor(black);
textbackground(white);
repeat
count:=0;if checkfile=true then readf;
repeat
clrscr;
writeln('-------------------------------------------------------------------------------');
writeln('                             2048 Lite for Windows');
writeln('-------------------------------------------------------------------------------');
writeln('                      Hit 0 to choose Beginner Diff (512)');
writeln('                      Hit 1 to choose Easy Diff (1024)');
writeln('                      Hit 2 to choose Normal Diff (2048)');
writeln('                      Hit 3 to choose Hard Diff (4096)');
writeln('                      Hit 4 to choose Very Hard Diff (8192)');
writeln('                      Hit 5 to choose Master Diff (16384)');
writeln('                      Hit 6 to choose Endless Diff');
writeln('                      Hit 7 to use Night theme');
writeln('                      Hit 8 to use Classic theme');
writeln('                      Hit esc to Exit');
writeln('                      UPDATE 1.0');
writeln('                      RECORD:',fnum,';moves:',fmove);
ch:=readkey;
if ch='7' then
begin
textcolor(white);
textbackground(black);
lowvideo;
end;
if ch='8' then
begin
textcolor(black);
textbackground(white);
end;
until (ch='0') or (ch='1') or (ch='2') or (ch='3') or (ch='4') or (ch='5') or (ch='6') or (ch=chr(27));
if ch='0' then
diff:=512;
if ch='1' then
diff:=1024;
if ch='2' then
diff:=2048;
if ch='3' then
diff:=4096;
if ch='4' then
diff:=8192;
if ch='5' then
diff:=16384;
if ch='6' then
diff:=1;
if ch=chr(27) then exit;
for i:=0 to 3 do
for j:=0 to 3 do
a[i,j]:=0;
start;
repeat
clrscr;
printf;
ch:=readkey;
if (count>0) and (ch='r') then rewind;
if (ch=#72) or (ch=#80) or (ch=#75) or (ch=#77) then
begin
backup;
move(ch);
for i:=1 to 10 do
clear(ch);
if difference(a,c)=true then
begin
spawn;
count:=count+1;
end;
end;
if ch=chr(27) then break;
until (win(a,diff)=true) or (lose(a)=true);
repeat
clrscr;
printf;
if win(a,diff)=true then
write('YOU WON');
if lose(a)=true then
write('YOU LOST');
if ch=chr(27) then
write('YOU RAGE-QUITTED');
writeln;
if maxnum(a)>fnum then
writef;
writeln('Wanna try again?');
writeln('Hit y for yes');
writeln('Hit n for no');
ch1:=readkey;
until (ch1='y') or (ch1='n');
until ch1='n';
end.
