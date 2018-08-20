; 进行不会产生溢出的除法运算，被除数为dword型
; 除数为word型，结果为dword型
; 参数, ax: dword型数据的低16位; dx: dword型数据的高16位
; 参数, cx: 除数
; 返回, ax: 结果的低16位; dx: 结果的高16位
; 返回, cx: 余数

assume cs:code,ss:stack

stack segment

    dw 8 dup(0)

stack ends

code segment

start:

    mov ax,stack
    mov ss,ax
    mov sp,10h
    mov ax,4240h
    mov dx,0fh
    mov cx,0ah
    call divdw

    mov ax,4c00h
    int 21h

divdw:

    push ax
    mov ax, dx
    mov dx, 0
    div cx
    mov bx, ax
    pop ax
    div cx
    mov cx, dx
    mov dx, bx
    ret

code ends

end start
