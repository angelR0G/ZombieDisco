.module PHYSICS
.include "cpctelera.h.s"
.include "sys/physics.h.s"
.include "man/game.h.s"
.include "man/entity.h.s"
.include "man/animations.h.s"
.include "man/entity_templates.h.s"

;.include "sprites/zombie.h.s"
;.include "sprites/player.h.s"
.include "sprites/bullet.h.s"

VX_MAX = 1
VY_MAX = 2

UPDATES_ENEMY = 3
updates_enemy: .db 0

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;Comprueba si una entidad se sale de pantalla
; ;;Input: ix - puntero a la entidad
; sys_physics_check_border::
; 	;Borde izquierdo
; 	ld a, e_x(ix)
;     cp #0
;     jp nz, no_izq
;         ;Colision izq
; 		ld l, 	e_border(ix)
; 		ld h, 	e_border+1(ix)
; 		ld  d,	#e_cmp_border
; 		call man_entity_forall_matching
; 	no_izq:
; 		;Borde derecho
; 		ld a, e_x(ix)
;         push af
;         ld a, #80
;         sub e_w(ix)
;         ld b, a
;         pop af
;         cp b
;         jp nz, end_if_hor
; 			;Colision dere
;             ld l, 	e_border(ix)
; 			ld h, 	e_border+1(ix) 
; 			ld  d,	#e_cmp_border
; 			call man_entity_forall_matching
	
; 	end_if_hor:
; 	;Borde superior
; 	ld a, e_y(ix)
; 		cp #0
; 		jp nz, no_arriba
; 			;Colision arriba
; 			ld l, 	e_border(ix)
; 			ld h, 	e_border+1(ix) 
; 			ld  d,	#e_cmp_border
; 			call man_entity_forall_matching
; 	no_arriba:
; 	;Borde inferior
; 		ld a, e_y(ix)
;         push af
;         ld a, #199
;         sub e_h(ix)
;         ld b, a
;         pop af
;         cp b
;         jp nz, end_if_ver
; 			;Colision abajo
; 			ld l, 	e_border(ix)
; 			ld h, 	e_border+1(ix) 
; 			ld  d,	#e_cmp_border
; 			call man_entity_forall_matching
; 	end_if_ver:
; ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Comprueba los inputs del jugador y las colisiones
;;Input: ix - la entidad del jugador
;;
sys_physics_input_player::
	;call cpct_scanKeyboard_asm

	;Velociadad por defecto
	ld e_vx(ix), #0
	ld e_vy(ix), #0
	
	;Colision izq
	ld  a, e_x(ix)
	cp #0
	jr z, endif_playerupdateIzq
		
			ld   hl, #Key_O
			call cpct_isKeyPressed_asm
			jr z, endif_playerupdateIzq
			;izquierda pulsada
				ld a, #PLAYER_DIR_LEFT
				ld (m_player_direccion), a
				call man_anim_change_sprite_anim
				
				ld e_vx(ix),#-VX_MAX
	endif_playerupdateIzq:

	;Colision dere
	ld  a, e_x(ix)
	sub #(80 - SPR_PLAYER_0_W)
	jr nc, endif_playerupdateDere

			ld   hl, #Key_P
			call cpct_isKeyPressed_asm
			jr z, endif_playerupdateDere
				; Derecha pulsada
				ld a, #PLAYER_DIR_RIGHT
				ld (m_player_direccion), a
				call man_anim_change_sprite_anim
				ld e_vx(ix),#VX_MAX

				jr z, endif_playerupdateDere
	endif_playerupdateDere:

	;Colision arriba
	ld  a, e_y(ix)
	cp #0
	jr z, endif_playerupdateArriba
			ld   hl, #Key_Q
			call cpct_isKeyPressed_asm
			jr z, endif_playerupdateArriba
				; Arriba pulsado
				ld a, #PLAYER_DIR_UP
				ld (m_player_direccion), a
				call man_anim_change_sprite_anim
				ld e_vy(ix),#-VY_MAX
				jr z, endif_playerupdateArriba
	endif_playerupdateArriba:

	;Colision abajo
	ld  a, e_y(ix)
	sub #(200 - SPR_PLAYER_0_H)
	jr nc, endif_playerupdateAbajo

			ld   hl, #Key_A
			call cpct_isKeyPressed_asm
			jr z, endif_playerupdateAbajo
				; Abajo pulsada
				ld a, #PLAYER_DIR_DOWN
				ld (m_player_direccion), a
				call man_anim_change_sprite_anim
				ld e_vy(ix),#VY_MAX

				jr z, endif_playerupdateAbajo
	endif_playerupdateAbajo:

	;;Update shot cd
	call man_game_shot_cd

	ld   hl, #Key_Space
	call cpct_isKeyPressed_asm
	jr z, endif_playerupdateshot
		; Abajo pulsada
		call man_game_entity_shot

		endif_playerupdateshot:

ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Update one entity from pointer
;;Input:
;;  -ix: entity pointer
sys_physics_update_one_entity:
	ld a,#e_cmp_input
	and e_cmp(ix)
	jr z,no_check_input
		call sys_physics_input_player
	no_check_input:
	; ld a,#e_cmp_border
	; and e_cmp(ix)
	; jr z,no_check_border
	; 	call sys_physics_check_border
	; no_check_border:
	call sys_physics_move
	

    ret

sys_physics_move::
	ld a, e_x(ix)
	add e_vx(ix)
	ld e_x(ix), a
	ld a, e_y(ix)
	add e_vy(ix)
	ld e_y(ix), a
ret
sys_physics_undo_move::
	ld a, (direccCollision)
	and #1
	cp #1
	jr nz, next_move
	ld a, e_x(ix)
	sub e_vx(ix)
	ld e_x(ix), a

	next_move:
	ld a, (direccCollision)
	and #2
	cp #2
	ret nz
	ld a, e_y(ix)
	sub e_vy(ix)
	ld e_y(ix), a

ret

sys_physics_update:
	ld hl, 	#sys_physics_update_one_entity
	ld  d,	#e_cmp_movable
	call man_entity_forall_matching
	ret

