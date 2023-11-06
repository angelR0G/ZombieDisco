.module GAME
.include "cpctelera.h.s"
.include "man/game.h.s"
.include "man/level.h.s"
.include "man/entity.h.s"
.include "man/animations.h.s"
.include "sys/render.h.s"
.include "sys/physics.h.s"
.include "sys/ai.h.s"
.include "sys/animations.h.s"
.include "sys/collision.h.s"
.include "sys/menu.h.s"
.include "sys/hud.h.s"
.include "sys/music.h.s"

.include "man/entity_templates.h.s"
;.include "sprites/player.h.s"
m_player_shot::  .db 0
m_can_shot:: .db 0
m_player_direccion:: .db 0

m_enemy_dead:: .db 0
m_ingame:: .db 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Initialize game
;;
man_game_init::
    call man_entity_init
    call sys_render_init
    call _init_anim_player


    ;Create player
    ld hl, #_player_tmpl
    call man_game_create_template_entity
    xor a
    ld (m_can_shot), a
    ld (m_player_shot), a
    
    ; ld hl, #_enemy_zombie_tmpl
    ; call man_game_create_template_entity
    ;Initialize level
    ld hl, #enemy_level0
    call sys_level_init
    
    ;Draw menu
    ld b, #0
    call sys_render_draw_menu

    call sys_music_sfx_init

    ;Restart collision cooldown
    call sys_collision_cd_restart

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Game loop
;;
man_game_play::
    

    game_main_loop:
        ;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;MENU
        call man_game_loop_main_menu
        call sys_render_clean_screen
        ;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;INGAME
        game:
            call sys_render_draw_map
        loop:
            call cpct_waitVSYNC_asm
            call sys_render_update

            ld iy, #enemy_type
            call sys_level_generate_enemy
            call sys_physics_update
            call sys_collision_update
            call sys_ai_update
            call sys_animations_update
            call man_entity_update
            ld a, (m_ingame)
            cp #1
            jr z, loop
        game_over_screen:
            call man_game_loop_game_over_menu
        ;;Clean screen
        call sys_render_clean_screen
        ;;Clean all entities in the game
        call man_entity_clear_all_entities
        call man_game_init
    jr game_main_loop
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Loop main menu
;;Main loop for render and update the main menu
man_game_loop_main_menu::
    loop_m:
        call sys_render_draw_menu
        call sys_menu_check_inputs

        ;;d = 1, exit menu
        ld a, d
        cp #1
        jr nz, loop_m
        ld a, #1
        ld (m_ingame), a
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Loop main menu
;;Main loop for render and update the main menu
man_game_loop_game_over_menu::
    call sys_menu_game_over_render
    loop_go:
        call sys_menu_check_inputs_game_over

        ;;d = 1, exit menu
        ld a, d
        cp #1
        jr nz, loop_go
        ld a, #1
        ld (m_ingame), a
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Crates an entity with a template
;;Input:    hl - template position
;;Output:   ix - new entity
man_game_create_template_entity::
    push hl
    call man_entity_create
    ;;return hl
    ex de, hl
    pop hl
    push de
    pop ix
    ld bc, #sizeof_e
    call cpct_memcpy_asm
ret

shotCooldown: .db #SHOT_CD_COUNT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Shot cooldown
;;Input: ix - entity shoting
man_game_shot_cd:
    ;;Check if cooldown is at maximum
    ld  a, (shotCooldown)
	cp #SHOT_CD_COUNT
	jr z,shot_cd_max
        ;;Increase shot cooldown
		ld a, (shotCooldown)
		inc a
		ld (shotCooldown), a
        jr end_shot_cd
    shot_cd_max:
        ;;If player can already shoot, end
        ;;0 -> can shot
        ld  a, (m_player_shot)
	    cp #0
        jr z,end_shot_cd
            ;;Player can shoot
            ld a, #0
            ld (m_player_shot), a
            ;;Restart cooldown
            ld a, (shotCooldown)
            ld a, #0
            ld (shotCooldown), a
    end_shot_cd:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Player shot
;;Input: ix - entity shoting
man_game_entity_shot:
    ;;Check if entity can shot
    ld a, (m_can_shot)
    cp #0
    jr nz, no_create_shot
    ;Save in iy 
    push ix
    pop iy

    ;One shot in a time
    ld a, (m_player_shot)
    cp #0
    jp nz, no_create_shot

        ;Generate shot
        ld hl, #_bullet_tmpl
        call man_game_create_template_entity

        ;Change direcction
        ld a, (m_player_direccion)
        cp #0
        jr nz, sig_izq
            ;Derecha
            ld e_vx(ix), #V_SHOT_MAX_X
            jr end_if_dir
        sig_izq:
            ld a, (m_player_direccion)
            cp #1
            jr nz, sig_up
            ;Izquierda
            ld e_vx(ix), #-V_SHOT_MAX_X
            jr end_if_dir
        sig_up:
            ld a, (m_player_direccion)
            cp #2
            jr nz, sig_down
            ;Arriba
            ld e_vy(ix), #-V_SHOT_MAX_Y
            jr end_if_dir
        sig_down:
            ;Abajo
            ld e_vy(ix), #V_SHOT_MAX_Y
            jr end_if_dir
        end_if_dir:
        ;New position
        ; x
        ld a, e_x(iy)
        ld e_x(ix), a
        ;y
        ld a, e_y(iy)
        ld e_y(ix), a

        ;Increase shot counter
        ld a, #1
        ld (m_player_shot), a
        ;;Shot sfx
        call sys_music_sfx_shot
    no_create_shot:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Destroy an entity from the game
;;Input: ix - entity to destroy
;;
man_game_entity_destroy::
    ;Erase destroyed entity

    call man_entity_clone
    ld a, #e_type_dead
    ld e_type(iy), a
    ld a, #e_cmp_render
    ld e_cmp(iy), a
    ld a, e_x(iy)
    add #1
    ld e_sprite(iy), #0
    ld e_sprite+1(iy), #0
    push iy
    call man_entity_set4destruction
    pop ix

    call man_entity_set4destruction
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,
;;Destroy bullet
;;  Input:
;;      -ix: bullet entity
man_game_destroy_bullet::
    call sys_physics_undo_move
    call man_game_entity_destroy
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Enemy dead
;;Increase the number of dead enemies and check change level
man_game_enemy_dead::
    ;;increase score
    ld bc, #10
    call sys_hud_score_modify
    ;Increase number of dead enemies
    ld a, (m_enemy_dead)
    add #1
    ld (m_enemy_dead), a
    ;;Check m_enemy_dead - max_enemies == 0
    ld b, a
    ld a, (ref_actual_level)
    ld l, a
    ld a, (ref_actual_level+1)
    ld h, a
    ld de, #TYPES_ENEMIES
    add hl, de
    ld a, (hl)
    cp b
    ret nz
    ;;Reset number of dead enemies
    xor a
    ld (m_enemy_dead), a
    ;;Change level
    call sys_level_next
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Exit game
;;Change m_ingame to 0, the main loop ends
man_game_exit_game::
    xor a
    ld (m_ingame), a
ret
