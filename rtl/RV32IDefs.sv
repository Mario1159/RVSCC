package rv32i_defs;

    typedef enum logic[2:0]{
        SUM = 'b000,
        SUB = 'b001,
        OR = 'b011,
        AND = 'b010,
        SLT = 'b101
    } alu_opcode;

    typedef enum logic[6:0]{
        STALL = 'b0000000,
        REG_OPERATION = 'b0110011,
        IMM_OPERATION = 'b0010011,
        LOAD = 'b0000011,
        STORE = 'b0100011,
        BRANCH = 'b1100011,
        JAL = 'b1101111,
        JALR = 'b1100111,
        LUI = 'b0110111,
        AUIPC = 'b0010111} opcode_fmt;
endpackage