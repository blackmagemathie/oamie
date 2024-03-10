namespace draw

a1:
    ; draws 1 tile, using absolute positioning.
    ; ----------------
    ; !oamie_buffer    <- buffer to use. ($00 to $30)
    ; !oamie_pos_x_sub <- pos x.
    ; !oamie_pos_y_sub <- pos y.
    ; !oamie_num       <- tile number.
    ; !oamie_props     <- yxppccct properties.
    ; !oamie_size9     <- tile size and x pos 9th bit.
    ; ----------------
    phx                     ;
    rep #$20                ;
    ldx !oamie_buffer       ; get buffer.
    lda $400180,x           ;
    cmp $400188,x           ; buffer full?
    bne +                   ; if yes,
    sec                     ; set carry (failure),
    bra .end                ; and end.
    +   
    rep #$10                ; get buffer index into x.
    tax                     ;
    sep #$20                ;
    lda !oamie_pos_x_sub    ; write pos x.
    sta $400000,x           ;
    lda !oamie_pos_y_sub    ; write pos y.
    sta $400001,x           ;
    lda !oamie_num          ; write tile number.
    sta $400002,x           ;
    lda !oamie_props        ; write tile props.
    sta $400003,x           ;
    dex #4                  ; decrement tile slot.
    rep #$20                ;
    txa                     ;
    sep #$10                ;
    ldx !oamie_buffer       ; update tile pointer.
    sta $400180,x           ;
    lda $400182,x           ; get size9 pointer into a.
    rep #$10                ;
    tax                     ;
    sep #$20                ;
    lda !oamie_size9        ; write size and x pos 9th bit.
    and #$03                ; (with a quick "and" for safety)
    sta $400000,x           ;
    dex                     ; decrement size9 slot.
    rep #$20                ;
    txa                     ;
    sep #$10                ;
    ldx !oamie_buffer       ; update size9 pointer.
    sta $400182,x           ;
    clc                     ; clear carry (success).
    .end:   
    sep #$30                ; end.
    plx                     ;
    rtl                     ;
    
r1:
    ; draws 1 tile, using relative positioning.
    ; ----------------
    ; !oamie_buffer    <- buffer to use. ($00 to $30)
    ; !oamie_pos_x (2) <- pos x.
    ; !oamie_pos_x_sub <- pos x offset.
    ; !oamie_pos_y (2) <- pos y.
    ; !oamie_pos_y_sub <- pos y offset.
    ; !oamie_num       <- tile number.
    ; !oamie_props     <- yxppccct properties.
    ; !oamie_size9     <- tile size and x pos 9th bit.
    ; ----------------
    ; $3100-$3105 <- (garbage)
    ; ----------------
    phx                     ;
    rep #$20                ;
    ldx !oamie_buffer       ; get buffer.
    lda $400180,x           ;
    cmp $400188,x           ; buffer full?
    bne +                   ; if yes,
    sec                     ; set carry (failure),
    jmp .end                ; and end.
    +   
    rep #$10                ; get buffer index into x.
    tax                     ;
    lda !oamie_size9        ; get tile size.
    and #$0002              ;
    bne +                   ;
    lda #$0008              ;
    bra ++                  ;
    +                       ;
    lda #$0010              ;
    ++                      ;
    sta $3104               ;
    lda !oamie_pos_x_sub    ; get sub x pos,
    and #$00ff              ;
    bit #$0080              ;
    beq +                   ;
    ora #$ff00              ;
    +                       ;
    clc                     ; add x pos,
    adc !oamie_pos_x_lo     ;
    sec                     ; substract screen x pos,
    sbc $1a                 ;
    sta $3100               ; and preserve.
    cmp #$0100              ; left point on screen?
    bcc +                   ; if no,
    clc                     ; add tile size.
    adc $3104               ;
    dec                     ;
    cmp #$0100              ; right point on screen?
    bcc +                   ; if no,
    jmp .end                ; end.
    +                       ;
    lda !oamie_pos_y_sub    ; get sub y pos,
    and #$00ff              ;
    bit #$0080              ;
    beq +                   ;
    ora #$ff00              ;
    +                       ;
    clc                     ; add y pos,
    adc !oamie_pos_y_lo     ;
    sec                     ; substract screen y pos.
    sbc $1c                 ;
    sta $3102               ; and preserve.
    cmp #$00e0              ; top point on screen?
    bcc +                   ; if no,
    clc                     ; add tile size.
    adc $3104               ;
    dec                     ;
    cmp #$00e0              ; bottom point on screen?
    bcc +                   ; if no,
    jmp .end                ; end.
    +                       ;
    lda $3100               ; final x pos negative?
    bpl +                   ; if yes,
    sep #$20                ;
    lda #$01                ; set 9th bit.
    tsb !oamie_size9        ;
    bra ++                  ;
    +                       ; else,
    sep #$20                ;
    lda #$01                ; reset it.
    trb !oamie_size9        ;
    ++                      ;
    lda $3100               ; write pos x.
    sta $400000,x           ;
    lda $3102               ; write pos y.
    sta $400001,x           ;
    lda !oamie_num          ; write tile number.
    sta $400002,x           ;
    lda !oamie_props        ; write tile props.
    sta $400003,x           ;
    dex #4                  ; decrement tile slot.
    rep #$20                ;
    txa                     ;
    sep #$10                ;
    ldx !oamie_buffer       ; update tile pointer.
    sta $400180,x           ;
    lda $400182,x           ; get size9 pointer into a.
    rep #$10                ;
    tax                     ;
    sep #$20                ;
    lda !oamie_size9        ; write size and x pos 9th bit.
    and #$03                ; (with a quick "and" for safety)
    sta $400000,x           ;
    dex                     ; decrement size9 slot.
    rep #$20                ;
    txa                     ;
    sep #$10                ;
    ldx !oamie_buffer       ; update size9 pointer.
    sta $400182,x           ;
    clc                     ; clear carry (success).
    .end:   
    sep #$30                ; end.
    plx                     ;
    rtl                     ;

namespace off