PC=fpc
PFLAGS= -O3
OBJECTS= 2048.pas

ifeq ($(OS),Windows_NT)
	name=2048.exe
else
	name=2048
endif

PFLAGS+= -o"$(name)"

Param32= -Pi386
Param64= -Px86_64

all: auto

auto:   $(OBJECTS)
	$(PC) $(PFLAGS) $(OBJECTS)
	$(RM) *.o

x32:	$(OBJECTS)
	$(PC) $(PFLAGS) $(Param32) $(OBJECTS)
	$(RM) *.o
	
x64:	$(OBJECTS)
	$(PC) $(PFLAGS) $(Param64) $(OBJECTS)
	$(RM) *.o
	
clean:
	$(RM) *.o
	$(RM) *.ppu
