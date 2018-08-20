; 在屏幕中间分别显示绿色、绿底红色、白底蓝色的指定字符串

assume cs:codesg, ds:data, ss:stack

data segment

    db 'welcome to masm!'
    db 02h,01h,04h

data ends

stack segment

    dw 8 dup(0)

stack ends

codesg segment

start:

    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 10h
    mov bx, 0
    mov si, 0
    mov cx, 3
    mov ax, 0b872h

s:
    push si
    push cx
    push ax
    mov es, ax
    mov ah, ds:[si]
    mov cx, 16
    mov bx, 0
    mov si, 0

s1:
    mov al, ds:[si]
    mov es:[bx], al
    mov es:[bx+1], ah
    add bx, 2
    inc si
    loop s1

    pop ax
    pop cx
    pop si
    inc si
    add ax, 0ah

    loop s

    mov ax, 4c00h
    int 21h

codesg ends

end start
