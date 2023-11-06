.include "man/game.h.s"
.include "cpctelera.h.s"
.globl cpct_disableFirmware_asm
.globl cpct_akp_musicPlay_asm
.globl cpct_akp_musicInit_asm
.globl cpct_scanKeyboard_if_asm
.globl cpct_setPALColour_asm
.globl _music6
.area _DATA
.area _CODE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,
;;Interruptions
;;
cont_inter: .db 06
int_handler::
    push af
    push bc
    push de
    push hl

    ld a, (cont_inter)
    dec a
    jr nz, _cont
; _zero:
;     cpctm_setBorder_asm HW_BRIGHT_WHITE
_guard:
    ; scf
    ; call c, cpct_akp_musicPlay_asm
    ; call cpct_akp_musicPlay_asm
    call cpct_scanKeyboard_if_asm

    ; ld a, (_guard)
    ; xor #0x80
    ; ld (_guard), a

    ld a, #6
_cont:
    ld (cont_inter), a
    cp #1
    jr nz, no_music
        ; cpctm_setBorder_asm HW_BRIGHT_WHITE
        call cpct_akp_musicPlay_asm
        ; call cpct_scanKeyboard_if_asm
    no_music:

    ; ld h, a
    ; ld l, #16
    ; call cpct_setPALColour_asm

    pop hl
    pop de 
    pop bc 
    pop af 

    ei
    reti

set_int_handler:
    ei
    im 1
    ; call cpct_waitVSYNC_asm
    ; halt
    ; halt
    ; call cpct_waitVSYNC_asm

    di
    ld hl, #0x38
    ld (hl), #0xC3
    inc hl
    ld (hl), #<int_handler
    inc hl
    ld (hl), #>int_handler
    inc hl
    ld (hl), #0xC9
    ei
ret

_main::
    ;call cpct_disableFirmware_asm
    ld de, #_music6
    call cpct_akp_musicInit_asm
    call set_int_handler
    call man_game_init
    call man_game_play
    ret