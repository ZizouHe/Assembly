assume cs:code, ds:data

data segment

   db 'yy/mm/dd hh:mm:ss',0
   db 9,8,7,4,2,0     ; 年月日时分秒在CMOS中的位置

data ends

code segment

s0:   db 'yy/mm/dd hh:mm:ss',0
s1:   db 9,8,7,4,2,0     ; 年月日时分秒在CMOS中的位置

start:

    mov ax, data
    mov ds, ax
    mov si, offset s1
    mov es, ax
    mov di, offset s0
    mov cx, 6

s2: push cx
    mov al, ds:[si]      ; 取时间数据
    out 70h, al
    in al, 71h

    mov ah, al
    mov cl, 4
    shr ah, cl
    and al, 00001111b
    add ah, 30h
    add al, 30h

    mov ds:[di], ah
    mov ds:[di+1], al

    inc si
    add di, 3
    pop cx
    loop s2

    mov ax, 4            ; 显示数据
    mov dh, al
    mov dl, 3
    mov cl, 0cah
    mov ax, 0
    mov di, offset s0
    call far ptr show_str

    mov ax, 4c00h
    int 21h

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

end start
