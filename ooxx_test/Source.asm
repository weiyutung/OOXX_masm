; Program Description: A = 
; Author: Slider
; Creation Date: 2023/11/2
; Revisions: 
; Date:              Modified by:

INCLUDE Irvine32.inc
.data
    BOARD_SIZE equ 3
    players db "Player 1", 0  ; 玩家1的名稱
            db "Player 2", 0  ; 玩家2的名稱
    playerName1 db 'Player 1', 0
    playerName2 db 'Player 2', 0
    circle BYTE "O", 0dh, 0ah, 0
    forks BYTE "X", 0dh, 0ah, 0

    ; display_board
    row0 BYTE "   0   1   2 ", 0dh, 0ah, 0
    row20 BYTE "0  ", 0
    row| BYTE " | ", 0 
    rowLine BYTE "  ---+---+---", 0dh, 0ah, 0
    col1 BYTE "1  ", 0
    col2 BYTE "2  ", 0
    blank BYTE " ", 0
    circle BYTE "O", 0
    cross BYTE "X", 0

    ;輸出字串
    enter1 BYTE "Enter Player 1's name: ", 0
	enter2 BYTE "Enter Player 2's name: ", 0

    ;輸入name
	name1 BYTE 100 DUP(0) 
	name2 BYTE 100 DUP(0) 

    ;輸出字串
	pgofirst BYTE " goes first!", 0ah, 0dh, 0
    whos BYTE "It's ", 0
    turn BYTE " turn", 0ah, 0dh, 0
    plzrow BYTE "Please enter row : ", 0
    plzcol BYTE "Please enter col : ", 0

    ;輸入row col
	row SDWORD ? 
	col SDWORD ? 

    ; reset_board
    board BYTE 100 DUP (0)

    ; whos_turn , make_move
    currentPlayer dd ?
    line DWORD 0

    arr DWORD 9 DUP (0)


.code
main PROC
    mov edx, OFFSET enter1        ; "Enter Player 1's name: "
	call WriteString

	mov edx,OFFSET name1          ; 輸入 name1
	mov ecx,SIZEOF name1
	call ReadString 

	mov edx, OFFSET enter2        ; "Enter Player 2's name: "
	call WriteString

	mov edx,OFFSET name2          ; 輸入 name2
	mov ecx,SIZEOF name2 
	call ReadString 

	call Crlf                     ; 印空白行

    call reset_board              ; 重置 board  //待確認是否正確

    call random_player            ; 輸出 誰 go first
    cmp eax, 1
    je L1
    mov edx, OFFSET name2
    call WriteString 
    jmp L2
    L1:
        mov edx, OFFSET name1
        call WriteString
    L2:
    mov edx, OFFSET pgofirst
    call WriteString
    mov currentPlayer, eax

    call display_board           ; 輸出 一個board  (顯示當前狀態)
	
	call Crlf                    ; 印空白行

    mov edx, OFFSET whos         ; "It's "
	call WriteString

    call make_move               ; (who's turn) 輸出 name1 or name2 + " turn , Please enter (row, col): "
    call Crlf                    ; 印空白行

    ; 更新棋盤
    ;
    ;
    ;

    ; check win


    ; check 平手

    ; check drawnextplayer


    ;displayOverallResults() 


    call Crlf                    ; 印空白行
              

    
main ENDP

reset_board PROC
    ; 將存儲棋盤的內存清零
    lea eax, board       ; 載入存儲棋盤的內存地址
    mov ecx, 9           ; 設定迴圈計數器為 9（3x3 棋盤的大小）
    xor edx, edx         ; 將 edx 設為 0，作為清零的值

clear_loop:
    mov [eax], dl
    inc eax
    loop clear_loop

    ret
reset_board ENDP


random_player PROC
    call Randomize
    call Random32
    ; call WriteDec 
    ; call Crlf
    ; 用來看亂數本人
    mov ecx, 2
    mov edx, 0
    div ecx
    cmp edx, 0                       ; 餘數在edx
    jne one
    mov eax, 0
    jmp quit

    one:
        mov eax, 1
    quit:

    ret
random_player ENDP

whos_turn PROC
    not currentPlayer

    ret
whos_turn ENDP


display_board PROC
    mov ecx, 0
L3:
    cmp esi, 0
    je space
    jmp OX

space:
    mov edx, OFFSET row1
    call WriteString

    mov edx, OFFSET row20
    call WriteString
    mov edx, OFFSET row21
    call WriteString
    mov edx, OFFSET row22
    call WriteString


    mov edx, OFFSET rowLine
    call WriteString

    mov edx, OFFSET row40
    call WriteString
    mov edx, OFFSET row41
    call WriteString
    mov edx, OFFSET row42
    call WriteString
    mov edx, OFFSET row43
    call WriteString 

    mov edx, OFFSET rowLine
    call WriteString

    mov edx, OFFSET row50
    call WriteString
    mov edx, OFFSET row51
    call WriteString
    mov edx, OFFSET row52
    call WriteString
    mov edx, OFFSET row53
    call WriteString 
    ret
display_board ENDP


make_move PROC
    push eax                               ; 輪流輸出玩家名稱~
    mov eax, line
    cmp eax, 0
    je CmpPlayer
    not currentPlayer

    CmpPlayer:
        inc line
        pop eax                             
    
        push eax                           
        mov eax, currentPlayer
        cmp eax, 0
        je L1
        mov edx, OFFSET name1
        jmp L2
    L1:
        mov edx, OFFSET name2
    L2:
        call WriteString
        pop eax                           ; ~輪流輸出玩家名稱

    mov edx, OFFSET turn                  ; " turn ,"
	call WriteString
    
    call get_player_input

    mov esi, OFFSET arr
    mov eax, row
    shl eax, 4
    add esi, eax
    mov eax, col
    shl eax, 2
    add esi, eax
    mov [esi], 1

    mov eax, 0
    Li:
        mov ecx, 0
        cmp 
    Lj:
        ;輸出
        call display_board

        inc ecx
        cmp ecx, 3
        jbe  Lj
        inc eax
        jmp L1







make_move ENDP


get_player_input PROC

        mov edx, OFFSET plzrow       ; "Please enter row : "
        call WriteString

        ; 讀取輸入
        call ReadDec                 ; 輸入 row
        mov row,eax

        mov edx, OFFSET plzcol       ; "Please enter col : "
        call WriteString

        ; 讀取第二個數字
        call ReadDec                 ; 輸入 col
        mov col,eax


        ret

get_player_input ENDP




END main