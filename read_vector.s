.globl read_vector
.import ../utils.s


.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 4 representing the size of the vector
#   Every 4 bytes afterwards is an element of the matrix in
#   the vector.
# Arguments:
#   a0 is the pointer to string representing the filename
# Returns:
#   a0 is the pointer to the matrix in memory
#   a1 is a pointer to an integer, we will set it to the size of vector
# ==============================================================================
read_vector:
    # Prologue
    addi sp, sp, -28 # some amount #not sure if this is needed
    sw ra, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)
    sw s4, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)

    # Step 2
    # S2 Open file
    mv a1,a0
    # jal print_str
    li a2,0
    jal fopen # a0 file desc, a1 filepath, a2 read permissions
    mv s2,a0 # s0 file descriptor
    mv a1, a0
    jal ferror
    bne a0,zero,eof_or_error

    # Step 1 Malloc row pointer
    li a0,4
    jal malloc
    mv s3,a0 

    # Step 3
    # s2 file descriptor s3 pointer
    # Read first 4 bytes representing size of vector.
    mv a1,s2    
    mv a2,s3
    li a3,4
    jal fread 
    

    # Step 4
    # Calculate bytes
    lw s5, 0(s3)
    slli s5,s5,2
  
    # Allocate space for matrix and read it.
    mv a0,s5
    jal malloc
    # a0 now has pointer.
    mv s6,a0  # s5 - sizeof(vector), s6 pointer, s2 file desc. Why do we have this statement?
    # Step 6
    mv a1, s2 # file descriptor
    mv a2, s6 # pointer
    mv a3, s5 # #bytes
    jal fread
    mv a0, s6


    # Return values
    mv a0,s6 # Pointer with number of elements in vector
    mv a1,s3 # Pointer to vector

    # Epilogue
    lw ra, 0(sp)
    lw s2, 4(sp)
    lw s3, 8(sp)
    lw s4, 12(sp)
    lw s5, 16(sp)
    lw s6, 20(sp)
    lw s7, 24(sp)
    addi sp, sp, 28
    

    
    ret

eof_or_error:
    li a1 1
    jal exit2
