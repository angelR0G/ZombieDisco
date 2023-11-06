
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;TYPE OF ENTITIES
;;
e_type_invalid              = 0x00
e_type_player               = 0x01 
e_type_enemigo              = 0x02
e_type_shot                 = 0x04
e_type_shot_enemy           = 0x08
e_type_dead                 = 0x80
e_type_default              = e_type_enemigo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Entity components
;;
e_cmp_render        = 0x01
e_cmp_movable       = 0x02
e_cmp_input         = 0x04
e_cmp_ai            = 0x08
e_cmp_animated      = 0x10
e_cmp_border        = 0x20
e_cmp_collider      = 0x40
e_cmp_dead          = 0x80
e_cmp_default       = 0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;VARIABLES
;;
m_num_entities_max  = 20
sizeof_e            = 28

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Entity
;;
e_type          = 0
e_cmp           = 1
e_x             = 2
e_y             = 3
e_w             = 4
e_h             = 5
e_vx            = 6
e_vy            = 7
e_sprite        = 8
e_ai_funct      = 10
e_aiCounter     = 12
e_animFrame     = 13
e_animCounter   = 15
e_nextFrame     = 16
e_updateAnim    = 18
e_border        = 19
e_collides      = 21
e_health        = 22
e_damage        = 23
e_cooldown_coll = 24
e_hit           = 25
e_original_s    = 26    ;dos

.globl _m_entities
.globl _m_next_free_entity
.globl _m_zero_type_at_the_end
.globl _m_num_entities


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Functions
;;
.globl man_entity_init
.globl man_entity_create
.globl man_entity_destroy
.globl man_entity_set4destruction
.globl man_entity_update
.globl man_entity_freeSpace
.globl man_entity_forall_matching
.globl man_entity_forall_matching_type
.globl man_entity_forall_pairs_matching
.globl man_entity_clone
.globl man_entity_get
.globl man_entity_clear_all_entities
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Cpct functions
.globl cpct_memset_asm
.globl cpct_memcpy_asm