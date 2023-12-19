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
    row1 BYTE "   0   1   2 ", 0dh, 0ah, 0
    row20 BYTE "0  ", 0
    row21 BYTE "  | ", 0 
    row22 BYTE "  | ", 0
    row23 BYTE "  ", 0dh, 0ah, 0
    rowLine BYTE "  ---+---+---", 0dh, 0ah, 0
    row40 BYTE "1  ", 0
    row41 BYTE "  | ", 0 
    row42 BYTE "  | ", 0
    row43 BYTE "  ", 0dh, 0ah, 0
    row50 BYTE "2  ", 0
    row51 BYTE "  | ", 0 
    row52 BYTE "  | ", 0
    row53 BYTE "  ", 0dh, 0ah, 0

    ;輸出字串
    enter1 BYTE "Enter Player 1's name: ", 0
	enter2 BYTE "Enter Player 2's name: ", 0

    ;輸入name
	name1 BYTE 100 DUP(0) 
	name2 BYTE 100 DUP(0) 

    ;輸出字串
	pgofirst BYTE " goes first!", 0ah, 0dh, 0
    whos BYTE "It's ", 0
    plzenter BYTE " turn , Please enter (row, col): ", 0

    ;輸入row col
	row DWORD ? 
	col DWORD ? 
    rowcol db 3 dup (?) 

    ; reset_board
    board BYTE 100 DUP (0)

    ; whos_turn , make_move
    currentPlayer dd ?
    line DWORD 0


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
    mov edx, OFFSET row1
    call WriteString
    mov edx, OFFSET row20
    call WriteString
    mov edx, OFFSET row21
    call WriteString
    mov edx, OFFSET row22
    call WriteString
    mov edx, OFFSET row23
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
    
    call get_player_input

    ; 從input_buffer中提取行和列
    ;mov esi, [rowcol]      ; 行
    ;mov eax,esi
    ;call WriteDec
    ;call Crlf                    ; 印空白行
    ;mov edi, [rowcol + 2]      ; 列
    ;mov eax, edi
    ;call WriteDec


    ; 讀取輸入
    mov eax, OFFSET rowcol
    call ReadString

    ; 將字符轉換為整數
    mov al, rowcol
    sub al, '0'
    mov ah, 0
    movzx eax, ax
    mov ebx, eax

    ; 跳過空格
    inc edx

    ; 讀取第二個數字
    mov eax, OFFSET rowcol + 2
    call ReadString

    ; 將字符轉換為整數
    mov al, rowcol + 2
    sub al, '0'
    mov ah, 0
    movzx eax, ax

    ; 加上第一個數字
    add eax, ebx

    ; 顯示結果
    call WriteDec
    call Crlf


    ; 檢查行和列是否在有效範圍內
    cmp esi, 0
    jl  invalid_move
    cmp esi, BOARD_SIZE
    jge invalid_move

    cmp edi, 0
    jl  invalid_move
    cmp edi, BOARD_SIZE
    jge invalid_move

    ; 計算在一維數組中的索引
    mov eax, esi            ; eax = row
    imul eax, BOARD_SIZE    ; eax = row * BOARD_SIZE
    add eax, edi            ; eax = row * BOARD_SIZE + col

    ; 檢查該位置是否為空（Player::NONE）
    mov edx, [ecx + eax]    ; edx = current cell
    cmp edx, 0
    jne invalid_move        ; 非空，無效移動

    ; 更新棋盤
    mov [ecx + eax], ebx    ; 將 currentPlayer 放入指定位置

    jmp make_move_done


invalid_move:
    ; 無效移動的處理

make_move_done:
    ret

make_move ENDP


get_player_input PROC

        mov edx, OFFSET plzenter       ; "Please enter (row, col): "
        call WriteString

        ; Read user input
        ;mov edx, OFFSET rowcol
        ;mov ecx, SIZEOF rowcol
        ;call ReadString

        ret

get_player_input ENDP




END main