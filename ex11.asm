assume cs:code, ds: data

data segment

    db "Beginner's All-purpose Symbolic Instruction Code.",0

data ends

code segment

begin:

    mov ax, data
    mov ds, ax
    mov si, 0
    mov es, ax

    mov ax, 4      ; 显示老字符串
    mov dh, al
    mov dl, 3
    mov cl, 04ah
    call far ptr show_str

    call letterc

    mov ax, 8      ; 显示新字符串
    mov dh, al
    mov dl, 3
    mov cl, 04ah
    call far ptr show_str

    mov ax,4c00h
    int 21h

letterc:

    push si
    push cx
    pushf

start:

    mov ch, 0
    mov cl, ds:[si]
    jcxz exit
    cmp cl, 61h
    jb next
    cmp cl, 7ah
    ja next
    sub cl, 20h
    mov ds:[si], cl
    jmp short next


exit:

    popf
    pop cx
    pop si
    ret

next:

    inc si
    jmp short start

show_str:

    push ax
    push bx
    push cx
    push dx
    push di
    push ds

    mov al, 0a0h
    dec dh
    mul dh
    mov bx, ax
    mov ax, 2
    mul dl
    sub ax, 2
    add bx, ax
    mov ax, 0B800h
    mov ds, ax

    mov di, 0
    mov dl, cl
    mov ch, 0

s5: mov cl, es:[di]
    jcxz ok
    mov ds:[bx], cl
    mov ds:[bx+1], dl
    inc di
    add bx, 2
    jmp short s5

ok:

    pop ds
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    retf

code ends

end begin
