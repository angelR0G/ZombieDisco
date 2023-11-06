.module ENTITY

.include "man/entity.h.s"
.include "sys/render.h.s"

_m_entities: .ds m_num_entities_max * sizeof_e
_m_next_free_entity: .ds 2
_m_zero_type_at_the_end: .db e_type_invalid
_m_num_entities: .db 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Initialize entity
;;
man_entity_init::
    ;initialize entity array
    ; (2B DE) array	Pointer to the first byte of the array to be filled up (starting point in memory)
    ; (1B A ) value	8-bit value to be set
    ; (2B BC) size	Number of bytes to be set (>= 2)
    ld de, #_m_entities
    ld a, #0
    ld bc, #(m_num_entities_max * sizeof_e)
    call cpct_memset_asm
    ;;initialize next free entity
    ld hl, #_m_entities
    ld (_m_next_free_entity), hl
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Create an entity
;;Output:
;;  -hl: pointer to the new entity
man_entity_create::
    ld hl, (_m_next_free_entity)
    push hl
    ld bc, #sizeof_e
    add hl, bc
    ld (_m_next_free_entity), hl
    pop hl
    ld (hl), #e_type_default
    push hl
    inc hl
    ld (hl), #e_cmp_default
    ld hl, (_m_num_entities)
    ld bc,#1
    add hl,bc
    ld (_m_num_entities), hl
    pop hl
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Clone an entity
;;Input:    ix - entity to clone
;;Output:   iy - copy
;;
man_entity_clone::
    ;;Check available space
    call man_entity_freeSpace
    ld a, l
    cp #0
    ret z

    ;Create new entity
    call man_entity_create

    ; Change register
    push hl
    pop de
    ;Save new reference to the created entity
    push de
    pop iy
    push ix
    pop hl
    ld bc, #sizeof_e
    call cpct_memcpy_asm
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Entity forall matching entity type
;;Iterates through all entities, if signature matches with entity type call a function
;;  -ix: entity
;;Input:
;;  -hl: function pointer
;;  - d: signature
man_entity_forall_matching_type:
    ld ix,#_m_entities
    ld (forall_call_matches_t+1), hl
    next_entity_type:
        ;;no ultima entidad
        ld a,e_type(ix)
        or a
        jr z, end_loop
            push ix
            push de
            ;;no es la ultima entidad
            ld a, e_type(ix)
            and d
            cp d
            jr nz, no_call_t
                forall_call_matches_t:
                    call end_loop_type
            no_call_t:
            pop de
            pop ix
            ;;siguiente entidad
            ld bc, #sizeof_e
            add ix,bc
            jr next_entity_type
        end_loop_type:
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Entity forall matching
;;Iterates through all entities, if signature matches call a function
;;  -ix: entity
;;Input:
;;  -hl: function pointer
;;  - d: signature
man_entity_forall_matching:
    ld ix,#_m_entities
    ld (forall_call_matches+1), hl
    next_entity:
        ;;no ultima entidad
        ld a,e_type(ix)
        or a
        jr z, end_loop
            push ix
            push de
            ;;no es la ultima entidad
            ld a, e_cmp(ix)
            and d
            cp d
            jr nz, no_call
                forall_call_matches:
                    call end_loop
            no_call:
            pop de
            pop ix
            ;;siguiente entidad
            ld bc, #sizeof_e
            add ix,bc
            jr next_entity
        end_loop:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;HL- puntero a una funcion
;;d - mascara de bits
man_entity_forall_pairs_matching:
    ld ix,#_m_entities
    ld (forall_call_matches_p+1), hl
    next_entity_p:
        ;;no ultima entidad
        ld a,e_type(ix)
        or a
        jr z, end_loop_p
            ;;no es la ultima entidad
            ld a, e_cmp(ix)
            and d
            cp d
            jr nz, no_call_p
                push ix
                pop  iy
                ;;comprobar con siguiente entidad (e_right)
                ld bc, #sizeof_e
                add iy,bc
                next_entity2_p:
                ;;no ultima entidad
                ld a,e_type(iy)
                or a
                jr z, no_call_p
                    ;;no es la ultima entidad
                    ld a, e_cmp(iy)
                    and d
                    cp d
                    jr nz, no_call2_p
                        forall_call_matches_p:
                            call end_loop_p
                    no_call2_p:
                    ;;siguiente entidad
                    ld bc, #sizeof_e
                    add iy,bc
                    jr next_entity2_p
            no_call_p:
            ;;siguiente entidad
            ld bc, #sizeof_e
            add ix,bc
            jr next_entity_p
        end_loop_p:
ret

man_entity_update:
    ;Se guarda la direccion de la primera entidad
    ld hl,#_m_entities
    loop_update:
        ld a, (hl)
        cp #e_type_invalid
        jr z, end_loop_update
            ;Se comprueba si la entidad esta muerta
            ld a,#e_type_dead
            and (hl)
            cp #e_type_dead
            jr nz,incre
                ;Si esta muerta se borra
                call man_entity_destroy
            incre:
            ;Se pasa a la siguiente entidad
            ld bc,#sizeof_e
            add hl,bc
            jr loop_update

        end_loop_update:
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Set an entity to destroy
;;Input:
;;  - HL : entity pointer
man_entity_set4destruction:
    ;Se cambia el tipo a entidad muerta
    ld a,(ix)
    or #e_type_dead
    ld (ix),a

    ;Se eliminan los componentes de la entidad
    ld a,e_cmp(ix)
    and #e_cmp_render
    ld e_cmp(ix),#e_cmp_render
    
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Destroy an entity
;;Input:
;;  - HL : entity pointer
man_entity_destroy:
    ex de, hl
    ld hl, (_m_next_free_entity)
    ld bc, #-sizeof_e
    add hl, bc
    ld a, d
    cp h
    jr nz, no_iguales
        ld a, e
        cp l
        jr nz, no_iguales
            ex de, hl
            ld (hl), #e_type_invalid
            ex de, hl
    no_iguales:
    
    ld bc, #sizeof_e
    push hl
    call cpct_memcpy_asm
    pop hl
    ld (hl), #e_type_invalid

    ld (_m_next_free_entity), hl

    ld a, (_m_num_entities)
    dec a
    ld (_m_num_entities),a
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Entity free space
;;Output:
;;  - L : returns the available space to create entities
man_entity_freeSpace:
	ld	hl, #_m_num_entities
	ld	a, #m_num_entities_max
	sub	a, (hl)
    ld l, a
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Get an entity
;;Input: a - Position entity
;;Output: ix - entity
;;
man_entity_get::
    ld hl, #_m_entities
    ld bc, #sizeof_e
    cp #0
    jr z, end_loop_ent
        add hl, bc
        dec a
    end_loop_ent:
    push hl
    pop ix
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Clear all entities
;;
man_entity_clear_all_entities::
    ld de, #_m_entities
    xor a
    ld bc, #m_num_entities_max * sizeof_e
    call cpct_memset_asm
ret