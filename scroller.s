scroller_init:
    ld hl,scrolltext
    ld (scroller_ptr),hl
    call scroller_get_letter
    ret

scroller_get_letter:
    ld hl,(scroller_ptr)
    ld a,(hl)
    inc hl
    or a
    jr nz,.no_wrap
    ld hl,scrolltext
    ld a,(hl)
    inc hl
.no_wrap:
    ld (scroller_ptr),hl 
    call get_letter
    ret


FNT_COMMA:   equ 'Z'-'A'+0
FNT_DOT:     equ 'Z'-'A'+1
FNT_SPACE:   equ 'Z'-'A'+2

get_letter:
    cp ' '
    jr nz,.not_space
    ld a,FNT_SPACE
    jr .got_letter
.not_space:
    cp '.'
    jr nz,.not_dot
    ld a, FNT_DOT
    jr .got_letter
.not_dot:
    cp ','
    jr nz,.not_comma
    ld a, FNT_COMMA
    jr .got_letter:
.not_comma:
    cp 'Q'
    jr c,.not_r
    dec a    
.not_r:
    sub 'A'
    jr nc,.got_letter
    ld a,FNT_SPACE
.got_letter:

    ld d,a
    ld e,20
    mul
    ld hl, fonts2ax_map
    add hl,de

    ld (letter_top),hl

    ld a,20
    ld (scroll_shift),a
    ret

SCROLLER_VBL:
    ld hl,(scroller_map)
    ld de,(scroller_map)
    inc hl
    ld bc, 40*5-1
    ldir

    ld hl,(scroller_map)
    add hl,39

    call swap_out_MMU_67
    ld de,(letter_top)
    ld b, 5
.lp:
    ld a,(de)
    ld (hl),a

    add hl,40
    add de,4480/8
    djnz .lp

    call swap_back_MMU_67

    ld hl,(letter_top)
    inc hl
    ld (letter_top),hl

    ld a,(scroll_shift)
    dec a
    ld (scroll_shift),a
    ret nz

    jp scroller_get_letter


letter: ds 1
letter_top: ds 2

scroll_shift: ds 1  ; how many pixels left

scroller_ptr: ds 2

scroller_map: ds 2
scrolltext:   db "      A HAPPY HI TO EVERYBODY ON THE GLOBE WE LOVINGLY CALL EARTH, AND WELCOME TO THE BEATNIC DEMO SCREEN. ALL CODE BY MANIKIN WITH SOME ASSISTANCE FROM CHRIS JUNGEN, GRAPHICS BY SPAZ, MUSIC BY MAD MAX, SCROLL TEXT BY CRONOS. THIS SCREEN IS DEDICATED TO HE WHO THINKS HE IS THE BEST DEMO PROGRAMMER AROUND, NIC OF THE CAREBEARS. THIS DEMO HAS BEEN SPECIALLY DESIGNED TO ANNOY HIM A BIT, BUT IT WAS ONLY MEANT TO BE THIS IN A VERY FRIENDLY WAY AS HE ACTUALLY IS A VERY NICE PERSON, AND SO ARE THE OTHER CAREBEARS. JUST FOR YOUR INFORMATION, NIC, THIS ROUTINE USES THE SOCALLED CLF CODING FOR VECTOR GRAPHICS, WHERE CLF STANDS FOR CHEAT LIKE FUCK. THE ROUTINES WERE NOT NICKED FROM ANY OF YOUR CODE! AND THE CLF METHOD WAS WRITTEN IN LESS THAN TWO BLOODY HOURS!! WE HAVE NOW PROVEN THAT WE ARE NOT JUST THE MOST MAJOR PAIN IN YOUR ASS. NO! WE HAVE PROVEN THAT WE SHOT YOUR ASS CLEAN OFF!! SO FAR THIS BIT OF LAMING. WE DO NOT LIKE TO DO THIS, BUT COULD NOT RESIST. PLEASE, CAREBEARS, DO NOT MAKE THE DEMO CODING WORLD INTO A WARZONE. LET US JUST ALL HAVE FUN AND CODE NICE DEMO SCREENS!         GOOD.    WELCOME TO THE BEATNIC SCREEN AGAIN. IT FEATURES THE FASTEST 3D VECTOR GRAPHICS IN THE KNOWN UNIVERSE PLUS MORE! WE CONSIDER 3D VECTOR GRAPHICS IN THEIR PURE FORM, NO MATTER HOW FAST, TO BE EXTREMELY BORING. SO THAT IS WHY WE INCLUDED QUITE A BIT MORE TO MAKE IT LESS BORING. WE HAD OVER 75% OF PROCESSOR TIME LEFT ANYWAY...  SO THAT IS WHY A LANDSCAPE SCROLLER, A BIG SCROLLER TEXT AND SOME MUSIC WITH DIGI DRUMS HAVE BEEN INCLUDED. THERE IS STILL SOME PROCESSOR TIME LEFT, BUT WHATTAHECK. I REALLY DO NOT FEEL LIKE WRITING A LOT, ALSO BECAUSE IT HAS BEEN A TIRING DAY AND ALL KINDS OF COMPLICATIONS IN ALL KINDS OF FIELDS HAVE POPPED UP. ALSO, I MISS MY GIRL. SO THAT IS IT THEN. OF COURSE, WE HAVE TO GREET A COUPLE OF PEOPLE WHICH WE HEREBY DO. THE GREETINGS GO TO THE GIGABYTE CREW, THE UNION AND THE RESPECTASETTABLES WHO WE WOULD VERY MUCH LIKE TO THANK FOR ARRANGING THE TEE SHIRTS. THAT IS IT, FELLAS!   WRAP TIME....... ",0


