; 7ch号中断的测试程序
assume cs:code

data segment

    db "Welcome to masm!", 0

data ends

code segment

start:

    mov dh, 10
    mov dl, 10
    mov cl, 0a0h
    mov ax, data
    mov ds, ax
    mov si, 0

    int 7ch
    mov ax, 4c00h
    int 21h

code ends

end start
