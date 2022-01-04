##############################################################################################
#
#       !!!! Do NOT edit this makefile with an editor which replace tabs by spaces !!!!    
#
##############################################################################################
# 
# On command line:
#
# make all = Create project
#
# make clean = Clean project files.
#
# To rebuild project do "make clean" and "make all".
#

##############################################################################################
# Start of default section
#

TRGT = arm-none-eabi-
CC   = $(TRGT)gcc
CP   = $(TRGT)objcopy
AS   = $(TRGT)gcc -x assembler-with-cpp
SIZE = $(TRGT)size
OBJDUMP = $(TRGT)objdump
BIN  = $(CP) -O ihex 

MCU  = arm966e-s

# List all default C defines here, like -D_DEBUG=1
DDEFS = 

# List all default ASM defines here, like -D_DEBUG=1
DADEFS = 

# List all default directories to look for include files here
DINCDIR =

# List the default directory to look for the libraries here
DLIBDIR =

# List all default libraries here
DLIBS = 

#
# End of default section
##############################################################################################

##############################################################################################
# Start of user section
#

# Define project name here
PROJECT = main

# Define linker script file here
LDSCRIPT_ROM = ./LNK/str912-rom.ld

# List all user C define here, like -D_DEBUG=1
UDEFS = 

# Define ASM defines here
UADEFS = 

# List C source files here
SRC  = ./SRC/main.c \
	   ./SRC/CORE/armint.c \
	   ./SRC/RTOS/croutine.c \
	   ./SRC/RTOS/heap_2.c \
	   ./SRC/RTOS/port.c \
	   ./SRC/RTOS/queue.c \
	   ./SRC/RTOS/tasks.c \
	   ./SRC/RTOS/list.c \
	   ./SRC/RTOS/mpu_wrappers.c \
	   ./SRC/RTOS/timers.c \
#	   ./SRC/STDLIB/91x_can.c \
	   ./SRC/STDLIB/91x_enet.c \
	   ./SRC/STDLIB/91x_fmi.c \
	   ./SRC/STDLIB/91x_gpio.c \
	   ./SRC/STDLIB/91x_it.c \
	   ./SRC/STDLIB/91x_lib.c \
	   ./SRC/STDLIB/91x_scu.c \
	   ./SRC/STDLIB/91x_tim.c \
	   ./SRC/STDLIB/91x_uart.c \
	   ./SRC/STDLIB/91x_vic.c \
	   ./SRC/STDLIB/91x_wdg.c

# List ASM source files here
ASRC = ./SRC/RTOS/portasm.s \
	   ./SRC/CORE/rozbiegowka.s

# List all user directories here
UINCDIR = INC/ \
		  INC/CORE/ \
		  INC/STDLIB/ \
		  INC/RTOS/

# List the user directory to look for the libraries here
ULIBDIR =

# List all user libraries here
ULIBS = 

# Define optimisation level here
OPT = -O0

# set to 1 to optimize size by removing unused code and data during link phase
REMOVE_UNUSED = 1

#
# End of user defines
##############################################################################################


INCDIR  = $(patsubst %,-I%,$(DINCDIR) $(UINCDIR))
LIBDIR  = $(patsubst %,-L%,$(DLIBDIR) $(ULIBDIR))
DEFS    = $(DDEFS) $(UDEFS)
ADEFS   = $(DADEFS) $(UADEFS)
OBJS    = $(ASRC:.s=.o) $(SRC:.c=.o)
LIBS    = $(DLIBS) $(ULIBS)
MCFLAGS = -mcpu=$(MCU)
DMP     = $(PROJECT)_rom.dmp
ELF     = $(PROJECT)_rom.elf

ASFLAGS = $(MCFLAGS) -g -gdwarf-2 -Wa,-amhls=$(<:.s=.lst) $(ADEFS)
CPFLAGS = $(MCFLAGS) $(OPT) -gdwarf-2 -mthumb-interwork -fomit-frame-pointer -Wall -Wstrict-prototypes -fverbose-asm -Wa,-ahlms=$(<:.c=.lst) $(DEFS)
LDFLAGS_ROM = $(MCFLAGS) -nostartfiles -T$(LDSCRIPT_ROM) -Wl,-Map=$(PROJECT)_rom.map,--cref,--no-warn-mismatch $(LIBDIR)

ifeq ($(REMOVE_UNUSED), 1)
	LDFLAGS_ROM += -Wl,--gc-sections
	OPT += -ffunction-sections -fdata-sections
endif

# Generate dependency information
CPFLAGS += -MD -MP -MF .dep/$(@F).d

#
# makefile rules
#

all: ROM

ROM: $(OBJS) $(PROJECT)_rom.elf $(PROJECT)_rom.hex print_size $(DMP)

$(DMP) : $(ELF)
	@echo 'Creating memory dump: $(DMP)'
	$(OBJDUMP) -x --syms $< > $@
	@echo ' '

print_size:
	@echo 'Size of modules:'
	$(SIZE) -B -t --common $(OBJS)
	@echo ' '
	@echo 'Size of target .elf file:'
	$(SIZE) -B $(PROJECT)_rom.elf
	@echo ' '

%o : %c
	$(CC) -c $(CPFLAGS) -I . $(INCDIR) $< -o $@

%o : %s
	$(AS) -c $(ASFLAGS) $< -o $@
  
%_rom.elf: $(OBJS)
	$(CC) $(OBJS) $(LDFLAGS_ROM) $(LIBS) -o $@

%hex: %elf
	$(BIN) $< $@

clean:
	-rm -f $(OBJS)
	-rm -f $(PROJECT)_rom.elf
	-rm -f $(PROJECT)_rom.map
	-rm -f $(PROJECT)_rom.hex
	-rm -f $(SRC:.c=.c.bak)
	-rm -f $(SRC:.c=.lst)
	-rm -f $(ASRC:.s=.s.bak)
	-rm -f $(ASRC:.s=.lst)
	-rm -fR .dep

# 
# Include the dependency files, should be the last of the makefile
#
-include $(shell mkdir .dep 2>/dev/null) $(wildcard .dep/*)

# *** EOF ***