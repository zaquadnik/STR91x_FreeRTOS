/* 	Startup code for STR91x ARM-based microcontrollers
	based on STR912 startup source and some examples from www.stm.com

	This file contains ONLY the very low-level device initialization code such as memory setup
	and it shouldn't be modified (except stack sizes).
*/


.equ    Mode_USR,       0x10
.equ    Mode_FIQ,       0x11
.equ    Mode_IRQ,       0x12
.equ    Mode_SVC,       0x13
.equ    Mode_ABT,       0x17
.equ    Mode_UND,       0x1B
.equ    Mode_SYS,       0x1F

.equ	SCRO_AHB_UNB,   0x5C002034

.equ    I_Bit,          0x80    /* when I bit is set, IRQ is disabled */
.equ    F_Bit,          0x40    /* when F bit is set, FIQ is disabled */

.equ    Top_Stack,      0x04018000
.equ    UND_Stack_Size, 0x00000004
.equ    SVC_Stack_Size, 0x00000100
.equ    ABT_Stack_Size, 0x00000004
.equ    FIQ_Stack_Size, 0x00000004
.equ    IRQ_Stack_Size, 0x00000100
.equ    USR_Stack_Size, 0x00001000

.text
.arm
.section .vectrom, "ax"

Vectors:        ldr     pc,Reset_Addr         	// RESET vector
                ldr     pc,Undef_Addr		// Undefined instruction vector
                ldr     pc,SWI_Addr		// Software interrupt vector
                ldr     pc,PAbt_Addr		// Prefetch abort vector
                ldr     pc,DAbt_Addr
                nop                            /* Reserved Vector */
                LDR     PC,[PC,#-0xFF0]        /* Vector From AIC_IVR */
                LDR     PC,FIQ_Addr

Reset_Addr:     .word   Reset_Handler
Undef_Addr:     .word   Undef_Handler
SWI_Addr:       .word   vPortYieldProcessor
PAbt_Addr:      .word   PAbt_Handler
DAbt_Addr:      .word   DAbt_Handler
                .word   0                      /* Reserved Address */
IRQ_Addr:       .word   IRQ_Handler
FIQ_Addr:       .word   FIQ_Handler

Undef_Handler:  B       Undef_Handler
SWI_Handler:    B       SWI_Handler
PAbt_Handler:   B       PAbt_Handler
DAbt_Handler:   B       DAbt_Handler
IRQ_Handler:    B       IRQ_Handler
FIQ_Handler:    B       FIQ_Handler


// Starupt Code must be linked first at Address at which it expects to run.

.text
.arm
.section .init, "ax"

.global _startup
.func   _startup

_startup:

// Reset Handler

        ldr  pc, =Reset_Handler
Reset_Handler:

// Initialize flash memory controller

        ldr r6, =0x54000000
        ldr r7, = 4                 //flash size 512k
        str r7, [r6]

        ldr r6, =0x54000004
        ldr r7, = 2                  //Bank niebootowalny 32k
        str r7, [r6]

        ldr r6, =0x5400000C
        ldr r7, =0x0                //Adres banku bootowalnego 0
        str r7, [r6]

        ldr r6, =0x54000010         //Adres banku niebootowalnego
        ldr r7, =0x00020000         //Powyzej 512kB (32k)
        str r7, [r6]

        ldr r6, =0x54000018         //Enable bank 0 and bank 1
        ldr r7, =0x18
        str r7, [r6]


// Enable 96K RAM

        ldr     r0, = SCRO_AHB_UNB
        ldr     r1, = 0x0191
        str     r1, [r0]

//Enable branch cache
        ldr r6,=0x5400001C
        ldr r7,=0x10
        str r7,[r6]

// Setup stack pointers
        LDR     R0, =Top_Stack

//  Enter Undefined Instruction Mode and set its Stack Pointer
        MSR     CPSR_c, #Mode_UND|I_Bit|F_Bit
        MOV     SP, R0
        SUB     R0, R0, #UND_Stack_Size

//  Enter Abort Mode and set its Stack Pointer
        MSR     CPSR_c, #Mode_ABT|I_Bit|F_Bit
        MOV     SP, R0
        SUB     R0, R0, #ABT_Stack_Size

//  Enter FIQ Mode and set its Stack Pointer
        MSR     CPSR_c, #Mode_FIQ|I_Bit|F_Bit
        MOV     SP, R0
        SUB     R0, R0, #FIQ_Stack_Size

//  Enter IRQ Mode and set its Stack Pointer
        MSR     CPSR_c, #Mode_IRQ|I_Bit|F_Bit
        MOV     SP, R0
        SUB     R0, R0, #IRQ_Stack_Size

//  Enter Supervisor Mode and set its Stack Pointer
        MSR     CPSR_c, #Mode_SVC|I_Bit|F_Bit
        MOV     SP, R0
        SUB     R0, R0, #SVC_Stack_Size



//  Enter User Mode and set its Stack Pointer
        MSR     CPSR_c, #Mode_SYS|I_Bit|F_Bit
        MOV     SP, R0

// Setup a default Stack Limit (when compiled with "-mapcs-stack-check")
        SUB     SL, SP, #USR_Stack_Size


	MOV     r0, #0x60000
	MCR     p15,0x1,r0,c15,c1,0

// Relocate .data section (Copy from ROM to RAM)

        LDR     R1, =_etext
        LDR     R2, =_data
        LDR     R3, =_edata
LoopRel:
	CMP     R2, R3
        LDRLO   R0, [R1], #4
        STRLO   R0, [R2], #4
        BLO     LoopRel

// Clear .bss section (Zero init)

        MOV     R0, #0
        LDR     R1, =__bss_start__
        LDR     R2, =__bss_end__
LoopZI:
	CMP     R1, R2
        STRLO   R0, [R1], #4
        BLO     LoopZI

//Wywolaj konstruktory
			  	LDR R0, =__ctors_start__
			  	LDR R1, =__ctors_end__
ctor_loop:
			  	CMP R0, R1
			  	BEQ ctor_end
			  	LDR R2, [R0], #+4
			  	STMFD SP!, {R0-R1}
			  	MOV LR, PC
			  	MOV PC, R2
			  	LDMFD SP!, {R0-R1}
			  	B ctor_loop
ctor_end:

//Uruchom funkcje main
                LDR R2, =main
                MOV LR, PC
                MOV PC, R2

//Wywolaj destruktory
			   	LDR R0, =__dtors_start__
			  	LDR R1, =__dtors_end__
dtor_loop:
			  	CMP R0, R1
			  	BEQ dtor_end
			  	LDR R2, [R0], #+4
			  	STMFD SP!, {R0-R1}
			  	MOV LR, PC
			  	MOV PC, R2
			  	LDMFD SP!, {R0-R1}
			  	B dtor_loop
dtor_end:

//Koniec krec sie w pustej petli
exit_loop:
  				B exit_loop

        .size   _startup, . - _startup
        .endfunc
        .end


