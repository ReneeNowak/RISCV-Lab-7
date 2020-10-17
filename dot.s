.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
    # Prologue
    addi sp sp -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
	sw s7, 32(sp)
    
    # Save arguments
    mv s0 a0
    mv s1 a1
    mv s2 a2
    li a0,0 # Set accumulation to 0

    # Set strides
    mv s3, a3
    slli s3, s3, 2
    mv s4, a4
    slli s4, s4, 2

    # Set loop index
    li s5, 0


loop_start:
    # Check outer loop condition
    beq s5 s2 loop_end

loop_body:
    ## Fill in code here
    # Check inner loop condition
    # 1. Load pointer s0
    # 2. Move by s0 by stride factor s3.
    # 3. Load pointer s1. (2nd vector)
    # 4. Incremenent by stride factor s4.
    # 5. Multiply and Add. Accumulate into a0 
    # 6. Increment loop index.
    # 7. Jump to beginning of loop

loop_end:

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    addi sp sp 36

    ret
