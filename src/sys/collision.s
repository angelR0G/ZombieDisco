;.include "cpctelera.h.s"
.include "sys/collision.h.s"
.include "man/game.h.s"
.include "man/entity.h.s"
.include "man/animations.h.s"
.include "sprites/sprites.h.s"
.globl _spr_playerdisco_00
.globl _spr_playerdisco_01
.globl _spr_playerdisco_02
.globl _spr_playerdisco_03
.globl _spr_playerdisco_04
.globl _spr_playerdisco_05
.globl _spr_playerdisco_06
.globl _spr_playerdisco_07
.globl _spr_playerdisco_08
.globl _spr_playerdisco_09
.globl _spr_playerdisco_10
.globl _spr_playerdisco_11
.globl _spr_playerdisco_12
.globl _spr_playerdisco_13
.globl _spr_playerdisco_14
.globl _spr_playerdisco_15
.globl _spr_zombiedisco_0
.globl _spr_zombiedisco_2

.globl _level0

direccCollision:: .db 0
collisionCooldown: .db #COLLISION_COUNT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Restart collision cooldown
;;
sys_collision_cd_restart:
	ld a, #COLLISION_COUNT
	ld (collisionCooldown), a
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Update collisions between 2 entities
;;Input:
;;  -ix: entity 1 pointer
;;  -iy: entity 2 pointer
;;	- d: signature
sys_collision_update_entities:
	;;Conteo cooldown de colision enemigo-jugador
	ld  a, (collisionCooldown)
	cp #COLLISION_COUNT
	ld b, #0
	ld e_updateAnim(ix), b
	jr z,cd_max
		;;Increase collision cooldown player
		ld a, (collisionCooldown)
		inc a
		ld (collisionCooldown), a
		;;Get player entity
		push ix
		xor a
		call man_entity_get
		;;No update animations
		ld a, #1
		ld e_updateAnim(ix), a
		call check_direction_red_sprite
		pop ix
	cd_max:
	;Guardar af al poder ser modificado
	push af
	;;Comprobar si entre ellos pueden colisionar
	ld a,e_collides(ix)
	cp e_type(iy)
	jr z,collision

		ld a,e_collides(iy)
		cp e_type(ix)
		jr z,collision2
		
		jp no_collision

		collision:
			;;El que es colisionado se coloca en ix
			push ix
			push iy
			pop  ix
			pop  iy
		collision2:

		;;Comprobar si colisionan
		;; 1_x < 2_x + 2_width - margin
		ld a, e_x(iy)
		add e_w(iy)
		sub #H_MARGIN
		sub e_x(ix)
		jp c, no_collision

		;; 1_x + 1_width - margin > 2_x 
		ld a, e_x(ix)
		add e_w(ix)
		sub #H_MARGIN
		sub e_x(iy)
		jp c, no_collision

		;; 2_y < 1_y + 1_height - margin
		ld a, e_y(ix)
		add e_h(ix)
		sub #V_MARGIN
		sub e_y(iy)
		jp c, no_collision
		
		;; 2_y + 2_height - margin > 1_y
		ld a, e_y(iy)
		add e_h(iy)
		sub #V_MARGIN
		sub e_y(ix)
		jp c, no_collision


		;;Comportamiento dependiendo de los tipos colisionados
		;;Caso bala
		ld a,e_type(iy)
		cp #e_type_shot
		jr nz,no_shot

			;;Con enemigo
			ld a,e_type(ix)
			cp #e_type_enemigo
			jr nz,no_collision
				;;Mark hit enemy
				ld a, #1
				ld e_hit(ix), a

				;;Bajar vida
				ld 	a, e_health(ix)	;;Vida enemigo
				ld 	b, e_damage(iy)	;;Danyo bala
				sub b
				ld 	e_health(ix), a
				;;Si su vida =< 0, eliminar
				sub #1
				jp nc, no_kill
					call man_game_entity_destroy ;;Eliminar enemigo
					call man_game_enemy_dead
					push iy
					pop  ix
					call man_game_entity_destroy ;;Eliminar bala
					jr	no_collision
				no_kill:
				push iy
				pop  ix
				call man_game_entity_destroy ;;Eliminar bala
				jr	no_collision
			
		no_shot:
		
		;;Caso enemigo
		ld a,e_type(iy)
		cp #e_type_enemigo
		jr nz,no_melee

			;;Con jugador
			ld a,e_type(ix)
			cp #e_type_player
			jr nz,no_collision
				
				ld  a, (collisionCooldown)
				cp #COLLISION_COUNT
				jr nz,collision_cooldown
					;;Reiniciar cooldown
					ld a, (collisionCooldown)
					ld a, #0
					ld (collisionCooldown), a

					;;Bajar vida
					ld 	a, e_health(ix)	;;Vida jugador
					ld 	b, e_damage(iy)	;;Danyo enemigo
					sub b
					ld 	e_health(ix), a
					;;Si su vida =< 0, eliminar
					sub #1
					jp nc, no_dead
						call man_game_entity_destroy ;;Eliminar jugador
						call man_game_exit_game
						jr	no_collision
					no_dead:
					jr	no_collision
				collision_cooldown:
		no_melee:
			

	no_collision:

	;Restaurar af
	pop af
	
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Collision update
;;Update all entities with collider component
sys_collision_update:

	ld hl, 	#sys_collision_update_entities
	ld  d,	#e_cmp_collider
	call man_entity_forall_pairs_matching

	ld hl, 	#sys_collision_map_update
	ld  d,	#e_cmp_border
	call man_entity_forall_matching
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Collision map update
;;Update collisions withe the tilemap
;;
sys_collision_map_update::
	; xor a
	; call man_entity_get
	call calculate_position_to_tile
	ld a, (m_can_shot)
	ld a, #0
	ld (m_can_shot), a
	;;CHECK COLLSIONS
	xor a
	cp (iy)
	jr z, next_collision
		ld l, e_border  (ix)
		ld h, e_border+1(ix)
		ld (collision_map+1), hl
		collision_map:
			call end_collisions
			ld a, (m_can_shot)
			ld a, #1
			ld (m_can_shot), a
			jp end_collisions
	next_collision:
		cp 1(iy)
		jr z, next_collision1
		ld l, e_border  (ix)
		ld h, e_border+1(ix)
		ld (collision_map1+1), hl
		collision_map1:
			call end_collisions
			ld a, (m_can_shot)
			ld a, #1
			ld (m_can_shot), a
			jr end_collisions
	next_collision1:
	cp 20(iy)
		jr z, next_collision2
		ld l, e_border  (ix)
		ld h, e_border+1(ix)
		ld (collision_map2+1), hl
		collision_map2:
			call end_collisions
			ld a, (m_can_shot)
			ld a, #1
			ld (m_can_shot), a
			jr end_collisions
	next_collision2:
	cp 21(iy)
		jr z, next_collision3
		ld l, e_border  (ix)
		ld h, e_border+1(ix)
		ld (collision_map3+1), hl
		collision_map3:
			call end_collisions
			ld a, (m_can_shot)
			ld a, #1
			ld (m_can_shot), a
			jr end_collisions
	next_collision3:
	cp 40(iy)
		jr z, next_collision4
		ld l, e_border  (ix)
		ld h, e_border+1(ix)
		ld (collision_map4+1), hl
		collision_map4:
			call end_collisions
			ld a, (m_can_shot)
			ld a, #1
			ld (m_can_shot), a
			jr end_collisions
	next_collision4:
	cp 41(iy)
		jr z, next_collision5
		ld l, e_border  (ix)
		ld h, e_border+1(ix)
		ld (collision_map5+1), hl
		collision_map5:
			call end_collisions
			ld a, (m_can_shot)
			ld a, #1
			ld (m_can_shot), a
	next_collision5:
	end_collisions:
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;Address = base + y*tam_mapa + x
;;pixelpos 6 = ty=> 8*ty = y <= 48   -------> ty = y/4
;;		   5 = tx=> 4*tx = x <= 20	 -------> tx = x/2
calculate_position_to_tile::
	;;1.Calcular Entity.x / tam_tile_W(4)
	push ix
	ld a, e_x(ix)		;; A = Entity.x
	and #0b00000011
	cp #0
	jr nz, horizontal_allingment
		ld a, (direccCollision)
		or #1
		ld (direccCollision), a
	horizontal_allingment:
	ld a, e_x(ix)		;; A = Entity.x
	srl a				;; A = Entity.x/2
	srl a				;; A = Entity.x/4
	ld c, a				;;/ Se guarda a en bc
	ld b, #0			;;\
	
	;;2.Calcular Entity.y / tam_tile_H(8)
	pop ix
	ld a, e_y(ix)
	and #0b00000111
	cp #0
	jr nz, vertical_allingment
		ld a, (direccCollision)
		or #2
		ld (direccCollision), a
	vertical_allingment:
	ld a, e_y(ix)
	and #0b11111000
	ld e, a
	srl e
	ld d, b
	ld l, a
	ld h, d
	add hl, hl
	add hl, de
	add hl, bc
	ex de, hl

	ld iy, #_level0
	add iy, de

ret


check_direction_red_sprite::
	ld a, (m_player_direccion)
    cp #PLAYER_DIR_UP
    jr nz, no_up_sprite
        ld hl, #_spr_playerdisco_07
        call man_anim_change_sprite
        jr end_if_direc
    no_up_sprite:
    ld a, (m_player_direccion)
    cp #PLAYER_DIR_LEFT
    jr nz, no_left_sprite
        ld hl, #_spr_playerdisco_11
        call man_anim_change_sprite
        jr end_if_direc
    no_left_sprite:
	ld a, (m_player_direccion)
	cp #PLAYER_DIR_RIGHT 
	jr nz, no_right_sprite
		ld hl, #_spr_playerdisco_15
		call man_anim_change_sprite
		jr end_if_direc
    no_right_sprite:
	ld a, (m_player_direccion)
	cp #PLAYER_DIR_DOWN 
	jr nz, end_if_direc
		ld hl, #_spr_playerdisco_03
		call man_anim_change_sprite

    end_if_direc:
ret