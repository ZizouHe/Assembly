assume cs:code,ds:data

data segment

    db 'Welcome to masm!',0

data ends

code segment

start:

    mov dh, 8
    mov dl, 3
    mov cl, 0cah
    mov ax, data
    mov ds, ax
    mov si, 0
    call show_str

    mov ax, 4c00h
    int 21h

show_str:

    mov al, 0a0h   ; 计算显示开始的地址
    dec dh
    mul dh
    mov bx, ax
    mov ax, 2
    mul dl
    sub ax, 2
    add bx, ax
    mov ax, 0B800h
    mov es, ax

    mov di, 0     ; bx存放显示器位置
    mov dl, cl    ; dl存放颜色
    mov ch, 0

s:  mov cl, ds:[si]
    jcxz ok
    mov es:[bx+di], cl
    mov es:[bx+di+1], dl
    inc si
    add bx, 2
    jmp short s

ok: ret

code ends

end start
