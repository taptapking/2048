PC=fpc
PFLAGS= -O3
OBJECTS= 2048.pas
n32= 2048_i386
n64= 2048_x86_64
Param32= -o"$(n32).exe" -Pi386
Param64= -o"$(n64).exe" -Px86_64

all: x32 x64

x32:	$(OBJECTS)
	$(PC) $(PFLAGS) $(Param32) $(OBJECTS)
	$(RM) *.o
	
x64:	$(OBJECTS)
	$(PC) $(PFLAGS) $(Param64) $(OBJECTS)
	$(RM) *.o
	
clean:
	$(RM) *.o
	$(RM) *.ppu
