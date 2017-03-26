.data
  promptLine1: .asciiz "\nPlease Enter 1 - 3:\n1) Encode\n2) Decode\n3) Exit\n"
  promptLine2: .asciiz "Please enter the key:\n"
  promptLine3: .asciiz "Please enter the string to be encoded/decode:\n"
  promptLine4: .asciiz "Unexpected value. Please try again.\n"
  choice: .word 1 0       # 1 bit string for choice, init to 0
  input: .space 32        # 32 bit string for input, init to 0
  key: .word 2 0          # 2 bit string for containing adjust value, init to 0

.text
  exit:
    li $v0, 10            # Loads value 10 into register $v0 for system call
    syscall               # Execute system call denoted by $v0
  result:
    la $a0, input         # Sets $a0 to point to the address of input
    li $v0, 4             # Loads value 4 into register $v0 for system call
    syscall               # Execute system call denoted by $v0
    j main                # Repeat gui to simulate while(true) till exit loop
  recode:
    li $t0, 0             # $t0 will serve as iterator
    recodeIteration:
    add $s1, $s5, $t0     # $t1 = message[$t0]
    lb $s2, 0($s1)        # Load character to shift into $s2
    beq $s2, $0, result   # Goto result method
    add $s2, $s2, $s6     # Shifting the character by the key amount
    sb $s2, ($s1)         # Change character in input to the shifted input
    addi $t0, $t0, 1      # $t1++
    j recodeIteration     # Reiterate loop
  errorPrompt:
    la $a0, promptLine4   # Sets $a0 to point to the address of promptLine4
    li $v0, 4             # Loads value 4 into register $v0 for system call
    syscall               # Execute system call denoted by $v0
    j main                # Go back to main (while true loop till exit)
  main:
    la $a0, promptLine1   # Sets $a0 to point to the address of promptLine1
    li $v0, 4             # Loads value 4 into register $v0 for system call
    syscall               # Execute system call denoted by $v0

    la $a0, choice        # Sets $a0 to point to the address of choice
    li $v0, 5             # Loads value 5 into register $v0 for system call
    syscall               # Execute system call denoted by $v0

    or $s7, $v0, $0       # Set $s7 to menu choice

    bne $s7, 3, not3
      j exit              # $v0 == 3 (exit)
    not3:
      la $a0, promptLine2 # Sets $a0 to point to the address of promptLine2
      li $v0, 4           # Loads value 4 into register $v0 for system call
      syscall             # Execute system call denoted by $v0

      la $a0, key         # Sets $a0 to point to the address of key
      li $v0, 5           # Loads value 5 into register $v0 for system call
      syscall             # Execute system call denoted by $v0

      or $s6, $v0, $0     # Set $s6 to key string

      la $a0, promptLine3 # Load address of promptLine2 into $t0
      li $v0, 4           # Loads value 4 into register $v0 for system call
      syscall             # Execute system call denoted by $v0

      la $a0, input       # Sets $a0 to point to the address of key
      li $a1, 32          # Allocate byte space for input
      li $v0, 8           # Loads value 8 into register $v0 for system call
      move $t3, $a0       # Save string to temp register ($t0)
      syscall             # Execute system call denoted by $v0

      or $s5, $t3, $0     # Set $s5 to input string

      bne $s7, 2, not2
        j recode          # $a1 == 2 (recode)
      not2:
        bne $s7, 1, not1
          j recode        # $a1 == 1 (recode)
        not1:
          j errorPrompt   # $a1 does not contain valid selection
