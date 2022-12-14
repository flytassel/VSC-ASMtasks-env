;实现50-AX，结果存在AX的功能
DATA SEGMENT

    Score      DW		86,81,77,62,32,89,85,74,34,92,100,63,45,59,76,83,88,95,92,86
    Number     DW		1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
    Count      EQU		20  ;数组中元素的个数(字节)
ORG 50H
	DB 0
;***********************自己的数据写在下面*******************

;***********************自己的数据写在上面*******************
DATA ENDS
CODE SEGMENT
	ASSUME CS: CODE, DS: DATA






output proc
	push bx
	push si
	push dx
	mov bx,0DH ;一个判断是否还要继续输出的标志，除了0~9都可以
	push bx
again:
	xor dx,dx
	mov si,10
	div si ;余数放dx，商放ax
	cmp dx,0
	jne next ;余数不等于0，直接转到余数入栈操作
	cmp ax,0  ;余数等于0，看看商等不等于0
	je print ;商也等于0,开始打印输出
next:
	or dl,30h
	push dx ;变成0~9对应的ASCII入栈
	jmp again
print:
	pop dx
	cmp dx,0Dh ;如果是放入的标志，停止输出
	je over
	mov ah,2 ;不是的话就输出
	int 21h
	jmp print
over: 
	pop dx
	pop si
	pop bx
	ret
output endp


START:	MOV  AX, DATA
	MOV  DS, AX
;上面部分不要乱动
;请在下面写你自己的代码
;*************************自己的程序请写在下面********************
;NEG指令是直接取反，与原码的处理不同，即正数变负数，负数变正数
	MOV  AX, 5
	; NEG  AX;变成-AX
	; ADD AX, 50;（-AX）+50，即50-AX
    MOV  AX, Score[0];需要为双数
	
;************************自己的程序请写在上面***************
;如果想要显示结果，请用MOV指令把要显示的数据移入AX中即可，如MOV AX, 2000H
;以下不要随意修改，你现在还不具备修改水平，乱改后果自负
	; CALL  HBDISP
    
    MOV CX,Count-1      ;外层循环执行n-1次，CX是循环次数的寄存器
I10:
	XOR SI,SI     ;数组下标 
	XOR DI,DI     ;当前的循环次数

	
I20:
	MOV AX,Score[SI]
	MOV BX,Score[SI+2]


	CMP AX,BX
	
	;比较AX和BX大小:AX<BX，小于转移，跳转I30，不交换
        ;比较AX和BX大小:AX>BX，大于，不跳转I30，交换
        否则交换两数
	JL  I30
	MOV Score[SI],BX
	MOV Score[SI+2],AX     ;交换位置

    MOV AX,Number[SI]
	MOV BX,Number[SI+2]
    MOV Number[SI],BX
	MOV Number[SI+2],AX     ;交换位置
	
I30:
	ADD SI,2           ;SI加2:移动一个数字位置
    ; MOV AX,Score[0]     ;交换位置
    ; CALL  output
	INC DI             ;DI加1，当前循环次数
	CMP DI,CX           ;比较，判断是否可以退出
	
	;比较CX和DI大小:DI<CX转移,CX为外层循环总数n-1
	JB  I20             ;不能退出，继续比较
	Loop I10           ;循环调至I10,Loop循环CX执行一次减1


MOV CX,20
mov BX,0
mov DX,0
print1:
    MOV AX,CX
    CALL output

    ADD BX,2
    mov dl,32;输出2个空格
    int 21h;输出2个空格

    MOV  AX, Number[BX]
    CALL  output

    mov dl,32;输出2个空格
    int 21h;输出2个空格
    
    MOV  AX, Score[BX];需要为双数
    CALL  output

    MOV DL,0AH
    MOV AH,02H
    INT 21H

    Loop print1

	MOV  AH, 4CH
	INT    21H
CODE ENDS
END START