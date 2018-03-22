TITLE Final_Project (Final_Project.asm)
INCLUDE Irvine32.inc

main          EQU start@0

.stack 4096
ExitProcess proto, dwExitCode : dword

.data
    temp DWORD 10 DUP(0)        ;存亂數的
    input dword 10 dup(0)       ;存輸入的
    Game_start BYTE "How many numbers you want to guess(non-numeric character to exit):",0dh,0ah,0
    Game_wstart BYTE "錯誤輸入",0dh,0ah
                BYTE "請輸入數字1~9",0
    Game_error_Length BYTE "錯誤輸入長度",0
    Game_error_Input BYTE "錯誤輸入",0
    Game_input BYTE "Your input is: ",0
    Game_ans BYTE "The correct answer is: ",0
    Game_win BYTE "Congratulations!!!!!",0dh,0ah
             BYTE "Do you want to play again ? ",0
    Game_bye BYTE "See you...",0dh,0ah,0
    count_a DWORD 0h            ;位置和值相同的個數
    count_b DWORD 0h            ;值相同但位置不同的個數
    exe_time DWORD 0h           ;要輸入幾個數的個數
    captionW BYTE "Warning",0   ;錯誤視窗名稱
    captionQ BYTE "Question",0  ;問題視窗名稱
    captionI BYTE "Rule",0      ;規則視窗名稱
    ;規則內容
    Game_rule BYTE "▇▇▇▇◣              ▇  ▇                                      ◢▇▇▇◣",0dh,0ah
              BYTE "▇      ▇              ▇  ▇                                    ◢◤",0dh,0ah
              BYTE "▇      ▇              ▇  ▇                  ▇◢▇▇◣        ▇",0dh,0ah
              BYTE "▇      ◤              ▇  ▇                  ▇◤    ▇        ▇",0dh,0ah
              BYTE "▇▇▇▇     ▇    ▇   ▇  ▇  ◢▇▇◣        ▇      ▇        ▇            ◢▇▇◣  ▇            ▇  ◢▇▇◣",0dh,0ah
              BYTE "▇      ◣   ▇    ▇   ▇  ▇  ▇              ▇      ▇        ▇            ▇    ▇  ▇            ▇  ▇",0dh,0ah
              BYTE "▇      ▇   ▇    ▇   ▇  ▇  ◥▇▇◣        ▇      ▇        ▇            ▇    ▇   ▇   ◢◣   ▇   ◥▇▇◣",0dh,0ah
              BYTE "▇      ▇   ▇    ▇   ▇  ▇        ▇                          ◥◣          ▇    ▇   ▇  ▇  ▇  ▇         ▇",0dh,0ah
              BYTE "▇▇▇▇◤   ◥▇▇◤   ▇  ▇  ◥▇▇◤                          ◥▇▇▇◤  ◥▇▇◤    ◥◤    ◥◤    ◥▇▇◤",0dh,0ah,0dh,0ah
              BYTE "1. 先決定要猜幾個數字，只能從1到10",0dh,0ah
              BYTE "2. 再來輸入數字",0dh,0ah
              BYTE "   輸入的數字長度要跟猜幾個數字相同",0dh,0ah
              BYTE "3. 不能輸入相同的數字",0dh,0ah
              BYTE "4. 按數字鍵以外按鍵結束遊戲",0
    ;獲勝圖樣
    win_word BYTE  " /---\                         |",0dh,0ah
             BYTE  "|                              |",0dh,0ah
             BYTE  "|                              |",0dh,0ah
             BYTE  "|   ---      /--\    /--\   /--\",0dh,0ah
             BYTE  "|     /\    |    |  |    |  |  |",0dh,0ah
             BYTE  " \---/  |    \--/    \--/   \--/",0dh,0ah,0


.code
main PROC
    mov eax, 0+(11*16)          ;設定背景及字體顏色
    call SetTextColor
Rule:                           ;跳出規則視窗
    INVOKE MessageBox, NULL, ADDR Game_rule, ADDR captionI, MB_OK+MB_ICONINFORMATION+MB_APPLMODAL+MB_SYSTEMMODAL
Initial:
    call Clrscr
    mov edx, OFFSET Game_start  ;遊戲開始的輸出
    call Writestring
    call ReadDec                ;讀取要輸入幾個數
    cmp eax, 0                  ;如果讀取的不是數字，就跳至Endding
    je Endding
    cmp eax, 10                 ;若小於等於10
    jbe L0                      ;則跳至L0
    ;若大於則跳出錯誤視窗，顯示輸入錯誤
    INVOKE MessageBox, NULL, ADDR Game_wstart, ADDR captionW, MB_OK+MB_ICONEXCLAMATION+MB_APPLMODAL+MB_SYSTEMMODAL
    jmp Initial                 ;跳回Initial重新輸入
L0:
    mov exe_time, eax
    mov ecx, exe_time
    mov esi, offset temp
L1:                             ;產生亂數
    mov eax, 10
    call RandomRange
    mov dword ptr [esi], eax
    add esi, 4
    loop L1

C1:                             ;判斷temp是否有相同的數
    mov esi, OFFSET temp
    mov ecx, exe_time
    dec ecx
C2:
    mov edi, esi
    add edi, 4
    push ecx
C3:
    mov ebx, dword ptr [esi]
    cmp ebx, dword ptr [edi]
    jz Change                   ;如果找到相同的，則跳至Change
    add edi, 4
    loop C3

    pop ecx
    add esi, 4
    loop C2
    jmp Continue                ;如果都沒有相同的，則跳至Continue

Change:                         ;改變相同的數字
    mov eax, 10
    call RandomRange
    mov dword ptr [edi], eax
    jmp C1

Continue:                       ;因為都沒有相同的，則繼續執行
    mov esi, offset temp
    mov ecx, exe_time
    mov edx, OFFSET Game_ans    ;印出temp
    call WriteString
line1:
    mov eax, dword ptr [esi]
    call writedec
    add esi, 4
    loop line1
    call crlf

Start:                          ;重新輸入一串數字
    mov count_a, 0
    mov count_b, 0
    mov ecx, exe_time           ;讀取輸入的數
    mov eax, 4
    mul ecx
    mov esi, offset input
    add esi, eax
    sub esi, 4
    mov ebx, 10
    call ReadDec
    cmp eax, 0                  ;如果讀取的不是數字，就跳至Endding
    je Endding
L2:                             ;將讀取的數依照順序存取至input
    mov edx, 0
    div ebx
    mov dword ptr [esi], edx
    sub esi, 4
    loop L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Check1:
    cmp eax, 0                  ;若輸入數字沒有超過要輸入的長度
    jz Check2                   ;則跳至Check2
Err:                            ;若超過長度則執行Err
    ;跳出警告視窗，顯示輸入長度錯誤
    INVOKE MessageBox, NULL, ADDR Game_error_Length, ADDR captionW, MB_OK+MB_ICONEXCLAMATION+MB_APPLMODAL+MB_SYSTEMMODAL
    jmp Start                   ;跳至Start重新輸入

Check2:
    cmp edx, 0                  ;若輸入數字短於要數入的長度
    jz Err                      ;跳至Err
                                ;若輸入數字長度剛好則繼續執行

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C4:                             ;判斷input是否有相同的數
    mov esi, OFFSET input
    mov ecx, exe_time
    dec ecx
C5:
    mov edi, esi
    add edi, 4
    push ecx
C6:
    mov ebx, dword ptr [esi]
    cmp ebx, dword ptr [edi]
    jz Input_error              ;如果找到相同的，則跳至Input_error
    add edi, 4
    loop C6

    pop ecx
    add esi, 4
    loop C5
    jmp Correct                 ;如果都沒有相同的，則跳至Correct

Input_error:                    ;顯示輸入錯誤
    ;跳出警告視窗，顯示輸入錯誤
    INVOKE MessageBox, NULL, ADDR Game_error_Input, ADDR captionW, MB_OK+MB_ICONEXCLAMATION+MB_APPLMODAL+MB_SYSTEMMODAL
    jmp Start                   ;跳至Start重新輸入

Correct:                        ;input沒有相同的數字
    mov esi, offset temp        ;比較A的個數
    mov edi, offset input
    mov ecx, exe_time
    mov eax, 0
L3:
    mov ebx, dword ptr [esi]
    cmp ebx, dword ptr [edi]
    jne L4
    inc count_a
L4:
    add esi, 4
    add edi, 4
    loop L3

    mov esi, offset temp        ;比較B的個數
    mov ecx, exe_time
L5:
    mov edi, offset input
    push ecx
    mov ecx, exe_time
L6:
    mov ebx, [esi]
    cmp ebx, [edi]
    jne L7
    inc count_b
L7:
    add edi, 4
    loop L6

    pop ecx
    add esi, 4
    loop L5

Print:                          ;印出結果
    mov edx, OFFSET Game_input
    call WriteString
    mov eax, count_a
    call writedec
    mov al, "A"
    call writechar
    mov eax, count_b
    sub eax, count_a
    call writedec
    mov al, "B"
    call writechar
    call crlf

Restart:                        ;判斷是否全部數字都相同
    mov ebx, count_a
    cmp ebx, exe_time
    jnz Start                   ;若沒有全部相同，則跳至Start

Win:                            ;若輸入正確，則印出win_word
    mov edx, OFFSET win_word
    call WriteString
    ;跳出詢問視窗，問是否要重新開始
    INVOKE MessageBox, NULL, ADDR Game_win, ADDR captionQ, MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON1+MB_APPLMODAL+MB_SYSTEMMODAL
    cmp eax, IDYES              ;如果按下繼續遊戲，則跳至Initial
    je Initial
Endding:                        ;如果不繼續遊戲，則印出Game_bye
    mov edx, OFFSET Game_bye
    call WriteString
    call waitmsg

    INVOKE ExitProcess,0
    exit
main ENDP
END main
