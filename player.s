
LINE_INT_LSB		 equ $23
LAYER_2_Y_OFFSET 	 equ $17
LAYER2_CLIP_WINDOW   equ $18
PAL_INDEX            equ $40
PAL_VALUE_8BIT       equ $41
DMA_PORT    	     equ $6b ;//: zxnDMA
PAL_CTRL			 equ $43
LAYER2_OUT			 equ $123B
LAYER_3_CTRL		 equ $6b
TILE_DEF_ATTR		 equ $6c
LAYER3_MAP_HI		 equ $6e
LAYER3_TILE_HI		 equ $6f

NO_PAGING			 equ 1

MMU_6				equ $56
MMU_7				equ $57


;TILE_DEF_ATTR_PAL macro LO(\0*16) endm


CLS_INDEX equ $ff

bordera macro
         out ($fe),a
        endm

border macro
           ld a,\0
           bordera
        endm

MY_BREAK	macro
        db $fd,00
		endm


	OPT Z80
	OPT ZXNEXTREG    



    seg     CODE_SEG, 			 4:$0000,$8000
if  NO_PAGING = 0
	SEG_GFX equ 60
	seg 	GFX_SEG,			SEG_GFX:$0000,$c000
endif

;	seg     ULA_SEG
    seg     CODE_SEG
start:
;; set the stack pointer
	ld sp , StackStart

	call video_setup

;	call objs_init

	call backdrop_init

	call scroller_init


	call init_vbl


	ld a, 6
	call ReadNextReg
	and %01011111		; 
	Nextreg 6,a


	ld a, 8
	call ReadNextReg
	or %0100000
	Nextreg 8,a

	nextreg 7,%11 ; 28mhz
    nextreg $68,%10000000   ;ula disable
    nextreg $15,%00000111 ; no low rez , LSU , no sprites , no over border
 
frame_loop:
;	call update_3d
;	call test_draw
	call wait_vbl
	call swap_frames
	jp frame_loop

StackEnd:
	ds	128*3
StackStart:
	ds  2

include "irq.s"

include "video.s"

include "scroller.s"
include "backdrop.s"



THE_END:

 	savenex "player.nex",start

