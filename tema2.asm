%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
    use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1
    img_height: resd 1

section .rodata
    wanted_str db "revient", 0
    response db "C'est un proverbe francais.", 0
    wanted_str_size dd 7
    response_size dd 28

section .text

; receives 2 letters, returns 1 if they are equal, 0 otherwise
;check_letter:
    ;push ebp
    ;mov ebp, esp
    
    ; saving the value of ebx on the stack
    ;push ebx

   ; mov ebx, DWORD[ebp + 8]
    ;xor eax, eax

   ; cmp ebx, DWORD[ebp + 12]
  ;  jne end_check_letter
    
 ;   mov eax, 1
    
;end_check_letter:
    ;pop ebx

    ;leave
    ;ret
    

bruteforce_singlebyte_xor:
    push ebp
    mov ebp, esp
    
    xor ecx, ecx
    
key_value_iterate:
    ; saving the key value on the stack
    push ecx
    mov edx, ecx

    xor ecx, ecx
    
row_iterate:
    ; saving the row number on the stack
    push ecx

    ; ebx is the offset / 4 for the first element in the current row
    mov eax, ecx
    push edx
    mul DWORD[img_width]
    pop edx
    mov ebx, eax
    
    xor ecx, ecx
    
column_iterate:
    ; saving the column number and the offset on the stack
    push ebx
    push ecx
    
    xor ecx, ecx
    
wanted_str_iterate:
    ; checking if it is the end of a column
    cmp ecx, [img_width]
    je end_column_iterate
    
    ; the pixel value is moved in eax
    mov eax, [ebp + 8]
    mov eax, [eax + 4 * ebx]
    
    ; xor with the key    
    xor eax, edx

    cmp al, BYTE[wanted_str + ecx]
    jne end_column_iterate
    
    inc ebx
    inc ecx
    
    cmp ecx, DWORD[wanted_str_size]
    jne wanted_str_iterate
    
    ; found the word here, clearing the stack off unnecessary information
    add esp, 8
    jmp found

end_column_iterate:
    ; the column number and the offset are taken off the stack
    pop ecx
    pop ebx

    inc ebx
    inc ecx

    ; continue only if this was not the last column
    cmp ecx, DWORD[img_width]
    jne column_iterate
    
    ; the current row number is taken off the stack
    pop ecx
    inc ecx
    
    ; continue only if this was not the last row
    cmp ecx, DWORD[img_height]
    jne row_iterate

    ; taking the key value off the stack
    pop ecx
    inc ecx
    
    ; max key value is 255
    cmp ecx, 0x00000100
    jne key_value_iterate
    
    
found:
    ; taking the row number and the key value off the stack
    pop ecx
    pop edx

    ; storing them in eax
    mov eax, ecx
    shl eax, 8
    mov al, dl
    
    leave
    ret

; receives the matrix address and a key value
; xors all the elements in the matrix with the key
xor_with_key:
    push ebp
    mov ebp, esp
    
    ; ecx = img_height * img_width
    mov eax, DWORD[img_height]
    mul DWORD[img_width]
    mov ecx, eax
    
    ; getting the matrix address and the key
    mov eax, [ebp + 8]
    mov edx, [ebp + 12]
    
    ; iterating through matrix like an array
matrix_iterating:
    xor DWORD[eax + 4 * (ecx - 1)], edx
    loop matrix_iterating
    
    leave
    ret

global main
main:
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 4]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    jmp done

solve_task1:
    ; finding the key and the row number
    push DWORD[img]
    call bruteforce_singlebyte_xor
    add esp, 4
    
    ; the first byte in eax is the key value
    xor edx, edx
    mov dl, al
    
    ; the rest is the row number, saving it on the stack
    shr eax, 8
    push eax
    
    ; calculating the offset / 4 and storing it in ecx
    push edx
    mul DWORD[img_width]
    mov ecx, eax
    pop edx
        
    ; moving in eax the matrix address
    mov eax, DWORD[img]

print_message:
    mov ebx, DWORD[eax + 4 * ecx]
    
    ; xor with the key
    xor ebx, edx
    
    cmp ebx, 0
    je print_key_and_row
    
    cmp ebx, 10
    je print_key_and_row
    
    PRINT_CHAR ebx
    
    inc ecx
    
    jmp print_message
    
print_key_and_row:
    NEWLINE
    PRINT_UDEC 4, edx
    
    ; taking the row number off the stack
    pop ecx
    NEWLINE
    PRINT_UDEC 4, ecx
    NEWLINE
       
    jmp done

solve_task2:
    ; finding the key and the row number
    push DWORD[img]
    call bruteforce_singlebyte_xor
    add esp, 4
    
    ; the first byte in eax is the key value, saving it on the stack
    xor edx, edx
    mov dl, al
    push edx
    
    ; the rest is the row number, saving it on the stack
    shr eax, 8
    push eax
    
    ; decrypting matrix
    push edx
    push DWORD[img]
    call xor_with_key
    add esp, 8
    
    ; ebx = the offset / 4 where the response should be inserted
    pop eax
    inc eax
    mul DWORD[img_width]
    mov ebx, eax
    
    ; adding the response
    mov eax, DWORD[img]
    xor ecx, ecx
    xor edx, edx
    
insert_response:
    mov dl, BYTE[response + ecx]
    mov DWORD[eax + 4 * ebx], edx
    
    inc ecx
    inc ebx
    
    cmp ecx, DWORD[response_size]
    jne insert_response

    ; setting the new key value
    pop eax
    mov ebx, 2
    mul ebx
    add eax, 3
    xor edx, edx
    mov ebx, 5
    div ebx
    sub eax, 4
    
    ; crypting matrix
    push eax
    push DWORD[img]
    call xor_with_key
    add esp, 8
    
    ; printing image
    push DWORD[img_height]
    push DWORD[img_width]
    push DWORD[img]
    call print_image
    add esp, 12
    
    jmp done
    
solve_task3:
    ; TODO Task3
    jmp done
solve_task4:
    ; TODO Task4
    jmp done
solve_task5:
    ; TODO Task5
    jmp done
solve_task6:
    ; TODO Task6
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4
    
    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    
