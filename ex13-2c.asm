; 7ch号中断例程的测试程序

assume cs:code

code segment

start:

    mov ax, 0b800h
    mov es, ax
    mov di, 160*12
    mov bx, offset s - offset se
    mov cx, 80

s:  mov byte ptr es:[di], '!'
    mov byte ptr es:[di+1], 0a0h
    add di, 2
    int 7ch

se: nop

    mov ax, 4c00h
    int 21h

code ends

end start
