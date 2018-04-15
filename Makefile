PC=fpc
PFLAGS= -O3
OBJECTS= 2048.pas
x32= 2048_i386
x64= 2048_x86_64
W32= -o"$(x32).exe" -Pi386 -Twin32
W64= -o"$(x64).exe" -Px86_64 -Twin64
L32= -o$(x32) -Pi386 -Tlinux
L64= -o$(x64) -Px86_64 -Tlinux

all: win32 win64 linux32 linux64

win32:	$(OBJECTS)
	$(PC) $(PFLAGS) $(W32) $(OBJECTS)
	$(RM) *.o
	
win64:	$(OBJECTS)
	$(PC) $(PFLAGS) $(W64) $(OBJECTS)
	$(RM) *.o
	
linux32:	$(OBJECTS)
	$(PC) $(PFLAGS) $(L32) $(OBJECTS)
	$(RM) *.o

linux64:	$(OBJECTS)
	$(PC) $(PFLAGS) $(L64) $(OBJECTS)
	$(RM) *.o
	
clean:
	$(RM) *.o
	$(RM) $(x32).*
	$(RM) $(x64).*
