; 安装一个int 7ch中断例程，通过逻辑扇区号对软盘进行读写
; 参数, 1. ah传递功能号, 0读1写; 2. dx传递扇区逻辑扇区号
; 参数, 3. es:bx指向需要读出/写入的内存区

assume cs:code

code segment

start:

    mov ax, cs
    mov ds, ax
    mov si, offset int7cstart

    mov ax, 0
    mov es, ax
    mov di, 200h

    mov cx, offset int7cend - offset int7cstart
    cld
    rep movsb

    mov word ptr es:[4*7ch], 200h
    mov word ptr es:[4*7ch+2], 0

    mov ax, 4c00h
    int 21h

int7cstart:

    cmp ah, 1
    ja none

    push ax
    push bx
    push cx
    push dx

    push ax

    mov ax, dx
    mov dx, 0
    mov cx, 1440
    div cx
    push ax
    mov cx, 18
    mov ax, dx
    mov dx, 0
    div cx
    push ax
    inc dx
    push dx

    pop ax
    mov cl, al
    pop ax
    mov ch, al
    pop ax
    mov dh, al
    mov dl, 0

    pop ax
    mov al, 1
    cmp ah,  0
    je read
    cmp ah,  1
    je write

read:

    mov ah, 2
    jmp short ok

write:

    mov ah, 3
    jmp short ok

ok:

    int 13h
    pop dx
    pop cx
    pop bx
    pop ax

none:

    iret

int7cend:

    nop

code ends

end start
