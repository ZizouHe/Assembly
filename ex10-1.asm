; 在指定位置，用指定颜色显示一个用0结尾的字符串
; 参数, dh: 行号(0~24); dl: 列号(0~79)
; 参数, cl: 颜色; ds:si指向字符串首地址

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
