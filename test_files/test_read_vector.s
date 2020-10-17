.import ../read_vector.s
.import ../utils.s
.data
file_path: .asciiz "./inputs/m0.bin"
# file_path0: .asciiz "../simple1_m0.bin"

# Registers used, Registers written.
.text
main:
    # Read matrix into memory
    la a1, file_path
#    jal print_str
    # Print out elements of vector
    la a0, file_path
    jal read_vector
    
    mv s2, a0
    mv s3, a1
    lw s5, 0 (s3)


    mv a0, s2
    mv a1, s5
    li a2,1
    jal print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall
