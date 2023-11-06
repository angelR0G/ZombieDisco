.module RENDER
.include "cpctelera.h.s"
.include "man/entity.h.s"
.include "man/game.h.s"
.include "sys/render.h.s"
.include "sys/hud.h.s"
.include "sys/menu.h.s"
;.include "sprites/main_palette.h.s"
.globl _g_tiles_00
.globl _level0
.globl _main_palette

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Inititalize render
;;
sys_render_init:
    ;Change amstrad video mode to zero
    ld c, #0
    ;halt
    call cpct_setVideoMode_asm

    cpctm_setBorder_asm HW_BLACK
    ;;Render border menu
    
    ld hl, #_main_palette
    ld de, #16
    call cpct_setPalette_asm

    call sys_render_set_tileset
    call sys_hud_init
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Set tileset
;;
sys_render_set_tileset:
    ld bc, #map_TAM
    ld de, #0x0014
    ld hl, #_g_tiles_00
    call cpct_etm_setDrawTilemap4x8_ag_asm

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Draw tilemap
;;
sys_render_draw_map:
    ld hl, #CPCT_VMEM_START_ASM
    ld de, #_level0
    call cpct_etm_drawTilemap4x8_ag_asm
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Update all entities
;;
sys_render_update:
    xor a
    call man_entity_get
    ld a, e_updateAnim(ix)
    cp #0
    jr nz, border_hit
        ;;Change border
		ld l, #16
		ld h, #BORDER
		call cpct_setPALColour_asm
        jr end_border
    border_hit:
        ;;Change border
		ld l, #16
		ld h, #HIT_COLOR
		call cpct_setPALColour_asm
    end_border:
	ld hl, #sys_render_one_entity
    ld  d, #e_cmp_render
	call man_entity_forall_matching
    call sys_hud_score_render
    call sys_hud_round_render
    call sys_hud_health
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Render one entity
;;Input:
;;  -ix: pointer to the entity
;;
sys_render_one_entity:

    ; ld a,e_type(ix)
    ; and #e_type_dead
    ; ret nz
    
    ld de, #CPCT_VMEM_START_ASM
    ld c,e_x(ix)
    ld b,e_y(ix)
    call cpct_getScreenPtr_asm

    push hl
    pop de
    ;;Comprueba si la entidad esta viva
    ld a, e_type(ix)
    and #e_type_dead
    cp #e_type_dead
    jr nz, esta_viva
        ld a, #0x33
        ld c, e_w(ix)
        ld b, e_h(ix)
        call cpct_drawSolidBox_asm
        jr fin_render
    esta_viva:
    ld l, e_sprite(ix)
    ld h, e_sprite+1(ix)
    ld c, e_w(ix)
    ld b, e_h(ix)
    call cpct_drawSprite_asm

    fin_render:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Draw menu screen
;;Input:
;;    -b: menu screen (0 main menu, 1 controls)
sys_render_draw_menu:
    ld a, b
    cp #0
    jr nz,check_next
        call sys_menu_screen_render
        jr end_render_photo
    check_next:
    cp #1
    jr nz,end_render_photo
        call sys_menu_controls_render
    end_render_photo:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Clean screen
;;
sys_render_clean_screen::
    ;;Change all video memory values to zero
    ld de, #CPCT_VMEM_START_ASM 
    xor a
    ld bc, #16335
    call cpct_memset_asm
ret

;;;;;;;;;;;;;;;;;;;
;;Wait 4us
wait_4us::
    dec l
    jr nz, wait_4us
    ret

ret

;;;;;;;;;;;;;;;;;
;;Wait 64us, one raster line
;;Input:
;;      - L: lines number
sys_render_wait_lines::
    ld b, l
    _wait_loop:
        ld l, #13
        call wait_4us
        djnz _wait_loop
ret