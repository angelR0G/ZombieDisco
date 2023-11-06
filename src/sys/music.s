.include "music.h.s"
.include "cpctelera.h.s"


; cont_effect:: .db 0
; sfx_on:: .db 0
; EFFECT_SHORT = 0xff

sys_music_sfx_init::
    ld de, #_sfx
    call cpct_akp_SFXInit_asm
ret

sys_music_sfx_shot::
    ; (1B L ) sfx_num	Number of the instrument in the SFX Song (>0), same as the number given to the instrument in Arkos Tracker.
    ; (1B H ) volume	Volume [0-15], 0 = off, 15 = maximum volume.
    ; (1B E ) note	Note to be played with the given instrument [0-143]
    ; (1B D ) speed	Speed (0 = As original, [1-255] = new Speed (1 is fastest))
    ; (2B BC) inverted_pitch	Inverted Pitch (-0xFFFF -> 0xFFFF).  0 is no pitch.  The higher the pitch, the lower the sound.
    ; (1B A ) channel_bitmask	Bitmask representing channels to use for reproducing the sound (Ch.A = 001 (1), Ch.B = 010 (2), Ch.C = 100 (4))
    ld l, #3
    ld h, #2
    ld e, #2
    ld d, #1
    ld bc, #2
    ld a, #0b00000100
    call cpct_akp_SFXPlay_asm
ret

;;;;;;;
;;stop sfx
;;Input : a-----> 4 = C, 2 = B, 1 = A 
;; call cpct_akp_SFXStop_asm



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;
; sys_music_sfx_stop:
;     ;;Check if is sfx on
;     ld a, (sfx_on)
;     cp #0
;     jr z,  end_stop
;         ;;Check timer sfx active
;         ld a, (cont_effect)
;         cp #EFFECT_SHORT
;         jr nz, incre_time
;             ld a, #2
;             call cpct_akp_SFXStop_asm
;             xor a
;             ld (cont_effect), a
;             ld (sfx_on), a
;             jr end_stop
;         incre_time:
;         ld a, (cont_effect)
;         inc a
;         ld (cont_effect), a
;     end_stop:
; ret