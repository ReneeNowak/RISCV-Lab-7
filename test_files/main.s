.import ../read_vector.s
.import ../dot.s
.import ../utils.s

.data
error_msg   : .asciiz "\nProgram expects two arguments. \n Usage:    main.s <M0_PATH> <M1_PATH> \n"
m0_str     : .asciiz "\nMatrix 0\n"
m1_str     : .asciiz "\nMatrix 1\n"
output_step1: .asciiz "\n**Step 1: Read matrices\n"
output_step2: .asciiz "\n**Step 2: Dot product \n"

.data
len      : .word 9
m0_stride: .word 1
m1_stride: .word 1



.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> 

    # Exit if incorrect number of command line args
    li s2, 3 # Expect 3 arguments
    mv s3, a0 # (argc)
    blt a0, s2, error # if argc < 3 jump to exit
    
    # argv[1]
    mv s4, a1 # (char** argv). s4 char* argv[] 
    addi s4,s4,4 # Dereferencing the first string (Why is this required ? )
    
    lw a0, 0 (s4)   # s4[0]. (pointer to string containing M0's path)
    jal read_vector #     

    # allocate space on stack for storing M0's parameters
    addi sp, sp, -8
    sw a0, 0 (sp) # Base address of read matrix
    sw a1, 4 (sp) # rows

    # Stack.
    # ----------
    # Row*
    # M0*
    # ----------- SP
    # argv[2]
    lw a0, 4 (s4) # s4[1] (pointer to string containing M1's path)
    jal read_vector #   

    # allocate space on stack for storing M1's parameters
    addi sp, sp, -8
    sw a0, 0 (sp) # Base address of read matrix
    sw a1, 4 (sp) # rows
    
    # -------------
    # Row*
    # M0*
    # Row*
    # M1*
    # <-----------SP
# 
#--------------------------------------------

# Load M1 
    mv t4, sp
    lw s2, 0 (t4)
    lw s3, 4 (t4)
    lw s3, 0 (s3)
 
# Print matrix M1
    la a1, m0_str
    jal print_str
    mv a0, s2
    mv a1, s3
    li a2 1
    jal print_int_array

# Load M0
    addi t4,t4,8
    lw s7, 0 (t4)
    lw s8, 4 (t4)
    lw s8, 0 (s8)
 
# Print matrix M0
    la a1, m1_str
    jal print_str
    mv a0, s7
    mv a1, s8
    li a2 1
    jal print_int_array

# Registers
# s2 - m1*    s3 - rows  
# s7 - m0*    s8 - rows 

# Allocate output (m0:rows s3 * input:cols s11)
    mv t2, s3  # (t2 number of elements)
    slli t2,t2,2 (# of bytes to allocate)
    mv a0,t2
    jal malloc
    mv s4, a0

# Registers
# s2 - m0*    s3 - rows  
# s7 - input* s8 - rows 
# s4 - output*

# # =====================================
# # RUN DOT

# # result = dot(m0, m1)
# # Set up arguments
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
#   a0 is the dot product of v0 and v1
# Returns:
    mv a0,s2
    mv a1,s7
    lw a2, len
    lw a3, m0_stride
    lw a4, m1_stride
    jal dot
    
# Temporarily save the result. Ask yourself why ?
    mv s5, a0

# Print the result
    la a1, output_step2
    jal print_str

    mv a1, s5
    jal print_int


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char
    jal exit

error: 
    la a1, error_msg
    jal print_str
    li a1, 1
    jal exit2