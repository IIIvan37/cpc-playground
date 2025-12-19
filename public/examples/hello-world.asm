; Hello World for Amstrad CPC
; Displays a message on screen

    org &4000

start:
    ld hl, message      ; Point to message
    call print_string   ; Print it
    ret

print_string:
    ld a, (hl)          ; Get character
    or a                ; Is it zero?
    ret z               ; Yes, done
    call &bb5a          ; TXT OUTPUT - print character
    inc hl              ; Next character
    jr print_string     ; Loop

message:
    db "Hello, CPC World!", 0
