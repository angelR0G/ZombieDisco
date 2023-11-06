.include "cpctelera.h.s"
.include "man/game.h.s"
.include "sys/menu.h.s"
.include "sys/hud.h.s"
.include "sprites/screens/screen_menuz.h.s"
.include "sprites/screens/screen_controlz.h.s"
.include "sprites/screens/screen_game_overz.h.s"



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Initial menu screen render
;;
sys_menu_screen_render:
    ld hl, #_screen_menuz_end
    ld de, #0xFFFF
    call cpct_zx7b_decrunch_s_asm
ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Controls screen render
;;
sys_menu_controls_render:
    ld hl, #_screen_controlz_end
    ld de, #0xFFFF
    call cpct_zx7b_decrunch_s_asm
ret


text_score_go: .asciz "Score"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Game over screen
;;
sys_menu_game_over_render:
    ld hl, #_screen_game_overz_end
    ld de, #0xFFFF
    call cpct_zx7b_decrunch_s_asm

    ld de, #CPCT_VMEM_START_ASM
    ld c,#30;x
    ld b,#60;y
    call cpct_getScreenPtr_asm
    ld iy, #text_score_go
    call cpct_drawStringM0_asm

    ;;Print number score

    ;;Render high value byte 1
    ld a, (score  )
    ;;Rotate 4 bits 
    rra
    rra
    rra
    rra
    ;;Mask 0000 1111
    and #0x0F
    ;;Add 48 to transfor number into ascii
    add #48
    ;;Adjust number 0-9
    daa
    ;;Print first character
    ld e, a
    push de
    ld de, #0xC000
    ld c, #SCORE_GO_X
    ld b, #SCORE_GO_Y
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm

    ;;Render low value byte 1
    ld a, (score)
    and #0x0F
    add #48
    daa
    ld e, a
    push de
    ld de, #0xC000
    ld c, #SCORE_GO_X+4
    ld b, #SCORE_GO_Y
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm

    ;;Render high value byte 2
    ld a, (score+1)
    rra
    rra
    rra
    rra
    and #0x0F
    add #48
    ld e, a
    push de
    ld de, #0xC000
    ld c, #SCORE_GO_X+8
    ld b, #SCORE_GO_Y
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm

    ;;Render low value byte 2
    ld a, (score+1)
    and #0x0F
    add #48
    ld e, a
    push de
    ld de, #0xC000
    ld c, #SCORE_GO_X+12
    ld b, #SCORE_GO_Y
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm
ret





menu_screen: .db 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Check inputs of menu
;;Output:   d - stay in menu (0 stay, 1 start game)
;;
sys_menu_check_inputs:
    ;Comprobar pantalla de menu actual
    ld a, (menu_screen)
    cp #0
    jr z,menu
    cp #1
    jr z,controls
    jr menu_end
    ;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;MENU
    menu:
        ;call cpct_scanKeyboard_asm
        ld   hl, #Key_1
        call cpct_isKeyPressed_asm
        jr z, loop_m_next
            ld  d, #1   ;Start game
        jr menu_end
        loop_m_next:
        ld   hl, #Key_2
        call cpct_isKeyPressed_asm
        jr z, menu_end
            ld  a, #1
            ld  (menu_screen), a   ;Change to controls
        jr menu_end
    ;;CONTROLS
    controls:
        ;call cpct_scanKeyboard_asm
        ld   hl, #Key_3
        call cpct_isKeyPressed_asm
        jr z, menu_end
            ld  a, #0
            ld  (menu_screen), a   ;Change to menu
    menu_end:

    ;Poner en b la pantalla de menu a dibujar
    ld  a, (menu_screen)
    ld  b, a

    ;Si d != 1, d = 0
    ld a, d
    cp #1
    jr z,d_exit
        ld d, #0
    d_exit:

ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Check inputs of game over menu
;;Output:   d - stay in menu (0 stay, 1 start game)
;;
sys_menu_check_inputs_game_over:
    ;Comprobar pantalla de menu actual
    ld a, (menu_screen)
    cp #0
    jr z,game_over
    ;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;MENU
    game_over:
        ;call cpct_scanKeyboard_asm
        ld   hl, #Key_1
        call cpct_isKeyPressed_asm
        jr z, loop_go_next
            ld  d, #1   ;Start game
        jr game_over_end
        loop_go_next:
        ld   hl, #Key_2
        call cpct_isKeyPressed_asm
        jr z, game_over_end
            ld  a, #2
            ld  (menu_screen), a   ;Change to main menu
        jr game_over_end
    game_over_end:

    ;Poner en b la pantalla de menu a dibujar
    ld  a, (menu_screen)
    ld  b, a

    ;Si d != 1, d = 0
    ld a, d
    cp #1
    jr z,d_exit_go
        ld d, #0
    d_exit_go:

ret