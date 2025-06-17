struct Instruction
{
  size_t size = 1;
  size_t address = 0x0000;

  EInstruction ins = EInstruction.UNK;
  EInstructionType type = EInstructionType.UNK;

  union
  {
    ushort val16 = 0;
    ubyte val8;
  }
}

Instruction get_instruction(EInstructionRaw raw, ubyte[] mem, size_t addr)
{
  Instruction o_ins = {};

  o_ins.ins = raw_to_ins_map[raw];
  o_ins.type = raw_to_type_map[raw];
  o_ins.size = type_to_size_map[o_ins.type];
  o_ins.address = addr;

  if (   o_ins.type != EInstructionType.IMMEDIATE
      && o_ins.type != EInstructionType.ACCUMULATOR)
  {
    switch(o_ins.size)
    {
      case 2: o_ins.val8 = mem[addr + 1]; break;
      case 3: o_ins.val16 = mem[addr + 1] | (mem[addr + 2] << 8); break;
      default: break;
    }
  }

  return o_ins;
}

enum EInstruction
{
  UNK,

  ADC,
  AND,
  ASL,
  BCC, BCS, BEQ,
  BIT,
  BMI, BNE, BPL,
  BRK,
  BVC, BVS,
  CLC, CLD, CLI, CLV,
  CMP, CPX, CPY,
  DEC, DEX, DEY,
  EOR,
  INC, INX, INY,
  JMP, JSR,
  LDA, LDX, LDY,
  LSR,
  NOP,
  ORA,
  PHA, PHP,
  PLA, PLP,
  ROL, ROR,
  RTI, RTS,
  SBC,
  SEC, SED, SEI,
  STA, STX, STY,
  TAX, TAY,
  TSX,
  TXA, TXS,
  TYA,
}

enum EInstructionType
{
  UNK,

  IMPLICIT,
  ACCUMULATOR,
  IMMEDIATE,
  ZERO_PAGE,
  ZERO_PAGE_X,
  ZERO_PAGE_Y,
  RELATIVE,
  ABSOLUTE,
  ABSOLUTE_X,
  ABSOLUTE_Y,
  INDIRECT,
  INDIRECT_X,
  INDIRECT_Y,
}

enum EInstructionRaw
{
  ADC_IMM = 0x69,
  ADC_ZP = 0x65,
  ADC_ZPX = 0x75,
  ADC_ABS = 0x6D,
  ADC_ABSX = 0x7D,
  ADC_ABSY = 0x79,
  ADC_INDX = 0x61,
  ADC_INDY = 0x71,

  AND_IMM = 0x29,
  AND_ZP = 0x25,
  AND_ZPX = 0x35,
  AND_ABS = 0x2D,
  AND_ABSX = 0x3D,
  AND_ABSY = 0x39,
  AND_INDX = 0x21,
  AND_INDY = 0x31,

  ASL_ACC = 0x0A,
  ASL_ZP = 0x06,
  ASL_ZPX = 0x16,
  ASL_ABS = 0x0E,
  ASL_ABSX = 0x1E,

  BCC_REL = 0x90,

  BCS_REL = 0xB0,

  BEQ_REL = 0xF0,

  BIT_ZP = 0x24,
  BIT_ABS = 0x2C,

  BMI_REL = 0x30,

  BNE_REL = 0xD0,

  BPL_REL = 0x10,

  BRK_IMPL = 0x00,

  BVC_REL = 0x50,

  BVS_REL = 0x70,

  CLC_IMPL = 0x18,

  CLD_IMPL = 0xD8,

  CLI_IMPL = 0x58,

  CLV_IMPL = 0xB8,

  CMP_IMM = 0xC9,
  CMP_ZP = 0xC5,
  CMP_ZPX = 0xD5,
  CMP_ABS = 0xCD,
  CMP_ABSX = 0xDD,
  CMP_ABSY = 0xD9,
  CMP_INDX = 0xC1,
  CMP_INDY = 0xD1,

  CPX_IMM = 0xE0,
  CPX_ZP = 0xE4,
  CPX_ABS = 0xEC,

  CPY_IMM = 0xC0,
  CPY_ZP = 0xC4,
  CPY_ABS = 0xCC,

  DEC_ZP = 0xC6,
  DEC_ZPX = 0xD6,
  DEC_ABS = 0xCE,
  DEC_ABSX = 0xDE,

  DEX_IMPL = 0xCA,

  DEY_IMPL = 0x88,

  EOR_IMM = 0x49,
  EOR_ZP = 0x45,
  EOR_ZPX = 0x55,
  EOR_ABS = 0x4D,
  EOR_ABSX = 0x5D,
  EOR_ABSY = 0x59,
  EOR_INDX = 0x41,
  EOR_INDY = 0x51,

  INC_ZP = 0xE6,
  INC_ZPX = 0xF6,
  INC_ABS = 0xEE,
  INC_ABSX = 0xFE,

  INX_IMPL = 0xE8,

  INY_IMPL = 0xC8,

  JMP_ABS = 0x4C,
  JMP_IND = 0x6C,

  JSR_ABS = 0x20,

  LDA_IMM = 0xA9,
  LDA_ZP = 0xA5,
  LDA_ZPX = 0xB5,
  LDA_ABS = 0xAD,
  LDA_ABSX = 0xBD,
  LDA_ABSY = 0xB9,
  LDA_INDX = 0xA1,
  LDA_INDY = 0xB1,

  LDX_IMM = 0xA2,
  LDX_ZP = 0xA6,
  LDX_ZPY = 0xB6,
  LDX_ABS = 0xAE,
  LDX_ABSY = 0xBE,

  LDY_IMM = 0xA0,
  LDY_ZP = 0xA4,
  LDY_ZPX = 0xB4,
  LDY_ABS = 0xAC,
  LDY_ABSX = 0xBC,

  LSR_ACC = 0x4A,
  LSR_ZP = 0x46,
  LSR_ZPX = 0x56,
  LSR_ABS = 0x4E,
  LSR_ABSX = 0x5E,

  NOP_IMPL = 0xEA,

  ORA_IMM = 0x09,
  ORA_ZP = 0x05,
  ORA_ZPX = 0x15,
  ORA_ABS = 0x0D,
  ORA_ABSX = 0x1D,
  ORA_ABSY = 0x19,
  ORA_INDX = 0x01,
  ORA_INDY = 0x11,

  PHA_IMPL = 0x48,

  PHP_IMPL = 0x08,

  PLA_IMPL = 0x68,

  PLP_IMPL = 0x28,

  ROL_ACC = 0x2A,
  ROL_ZP = 0x26,
  ROL_ZPX = 0x36,
  ROL_ABS = 0x2E,
  ROL_ABSX = 0x3E,

  ROR_ACC = 0x6A,
  ROR_ZP = 0x66,
  ROR_ZPX = 0x76,
  ROR_ABS = 0x6E,
  ROR_ABSX = 0x7E,

  RTI_IMPL = 0x40,

  RTS_IMPL = 0x60,

  SBC_IMM = 0xE9,
  SBC_ZP = 0xE5,
  SBC_ZPX = 0xF5,
  SBC_ABS = 0xED,
  SBC_ABSX = 0xFD,
  SBC_ABSY = 0xF9,
  SBC_INDX = 0xE1,
  SBC_INDY = 0xF1,

  SEC_IMPL = 0x38,

  SED_IMPL = 0xF8,

  SEI_IMPL = 0x78,

  STA_ZP = 0x85,
  STA_ZPX = 0x95,
  STA_ABS = 0x8D,
  STA_ABSX = 0x9D,
  STA_ABSY = 0x99,
  STA_INDX = 0x81,
  STA_INDY = 0x91,

  STX_ZP = 0x86,
  STX_ZPY = 0x96,
  STX_ABS = 0x8E,

  STY_ZP = 0x84,
  STY_ZPX = 0x94,
  STY_ABS = 0x8C,

  TAX_IMPL = 0xAA,

  TAY_IMPL = 0xA8,

  TSX_IMPL = 0xBA,

  TXA_IMPL = 0x8A,

  TXS_IMPL = 0x9A,

  TYA_IMPL = 0x98,
}

static const EInstruction[EInstructionRaw] raw_to_ins_map = [
  EInstructionRaw.ADC_IMM: EInstruction.ADC,
  EInstructionRaw.ADC_ZP: EInstruction.ADC,
  EInstructionRaw.ADC_ZPX: EInstruction.ADC,
  EInstructionRaw.ADC_ABS: EInstruction.ADC,
  EInstructionRaw.ADC_ABSX: EInstruction.ADC,
  EInstructionRaw.ADC_ABSY: EInstruction.ADC,
  EInstructionRaw.ADC_INDX: EInstruction.ADC,
  EInstructionRaw.ADC_INDY: EInstruction.ADC,

  EInstructionRaw.AND_IMM: EInstruction.AND,
  EInstructionRaw.AND_ZP: EInstruction.AND,
  EInstructionRaw.AND_ZPX: EInstruction.AND,
  EInstructionRaw.AND_ABS: EInstruction.AND,
  EInstructionRaw.AND_ABSX: EInstruction.AND,
  EInstructionRaw.AND_ABSY: EInstruction.AND,
  EInstructionRaw.AND_INDX: EInstruction.AND,
  EInstructionRaw.AND_INDY: EInstruction.AND,

  EInstructionRaw.ASL_ACC: EInstruction.ASL,
  EInstructionRaw.ASL_ZP: EInstruction.ASL,
  EInstructionRaw.ASL_ZPX: EInstruction.ASL,
  EInstructionRaw.ASL_ABS: EInstruction.ASL,
  EInstructionRaw.ASL_ABSX: EInstruction.ASL,

  EInstructionRaw.BCC_REL: EInstruction.BCC,

  EInstructionRaw.BCS_REL: EInstruction.BCS,

  EInstructionRaw.BEQ_REL: EInstruction.BEQ,

  EInstructionRaw.BIT_ZP: EInstruction.BIT,
  EInstructionRaw.BIT_ABS: EInstruction.BIT,

  EInstructionRaw.BMI_REL: EInstruction.BMI,

  EInstructionRaw.BNE_REL: EInstruction.BNE,

  EInstructionRaw.BPL_REL: EInstruction.BPL,

  EInstructionRaw.BRK_IMPL: EInstruction.BRK,

  EInstructionRaw.BVC_REL: EInstruction.BVC,

  EInstructionRaw.BVS_REL: EInstruction.BVS,

  EInstructionRaw.CLC_IMPL: EInstruction.CLC,

  EInstructionRaw.CLD_IMPL: EInstruction.CLD,

  EInstructionRaw.CLI_IMPL: EInstruction.CLI,

  EInstructionRaw.CLV_IMPL: EInstruction.CLV,

  EInstructionRaw.CMP_IMM: EInstruction.CMP,
  EInstructionRaw.CMP_ZP: EInstruction.CMP,
  EInstructionRaw.CMP_ZPX: EInstruction.CMP,
  EInstructionRaw.CMP_ABS: EInstruction.CMP,
  EInstructionRaw.CMP_ABSX: EInstruction.CMP,
  EInstructionRaw.CMP_ABSY: EInstruction.CMP,
  EInstructionRaw.CMP_INDX: EInstruction.CMP,
  EInstructionRaw.CMP_INDY: EInstruction.CMP,

  EInstructionRaw.CPX_IMM: EInstruction.CPX,
  EInstructionRaw.CPX_ZP: EInstruction.CPX,
  EInstructionRaw.CPX_ABS: EInstruction.CPX,

  EInstructionRaw.CPY_IMM: EInstruction.CPY,
  EInstructionRaw.CPY_ZP: EInstruction.CPY,
  EInstructionRaw.CPY_ABS: EInstruction.CPY,

  EInstructionRaw.DEC_ZP: EInstruction.DEC,
  EInstructionRaw.DEC_ZPX: EInstruction.DEC,
  EInstructionRaw.DEC_ABS: EInstruction.DEC,
  EInstructionRaw.DEC_ABSX: EInstruction.DEC,

  EInstructionRaw.DEX_IMPL: EInstruction.DEX,

  EInstructionRaw.DEY_IMPL: EInstruction.DEY,

  EInstructionRaw.EOR_IMM: EInstruction.EOR,
  EInstructionRaw.EOR_ZP: EInstruction.EOR,
  EInstructionRaw.EOR_ZPX: EInstruction.EOR,
  EInstructionRaw.EOR_ABS: EInstruction.EOR,
  EInstructionRaw.EOR_ABSX: EInstruction.EOR,
  EInstructionRaw.EOR_ABSY: EInstruction.EOR,
  EInstructionRaw.EOR_INDX: EInstruction.EOR,
  EInstructionRaw.EOR_INDY: EInstruction.EOR,

  EInstructionRaw.INC_ZP: EInstruction.INC,
  EInstructionRaw.INC_ZPX: EInstruction.INC,
  EInstructionRaw.INC_ABS: EInstruction.INC,
  EInstructionRaw.INC_ABSX: EInstruction.INC,

  EInstructionRaw.INX_IMPL: EInstruction.INX,

  EInstructionRaw.INY_IMPL: EInstruction.INY,

  EInstructionRaw.JMP_ABS: EInstruction.JMP,
  EInstructionRaw.JMP_IND: EInstruction.JMP,

  EInstructionRaw.JSR_ABS: EInstruction.JSR,

  EInstructionRaw.LDA_IMM: EInstruction.LDA,
  EInstructionRaw.LDA_ZP: EInstruction.LDA,
  EInstructionRaw.LDA_ZPX: EInstruction.LDA,
  EInstructionRaw.LDA_ABS: EInstruction.LDA,
  EInstructionRaw.LDA_ABSX: EInstruction.LDA,
  EInstructionRaw.LDA_ABSY: EInstruction.LDA,
  EInstructionRaw.LDA_INDX: EInstruction.LDA,
  EInstructionRaw.LDA_INDY: EInstruction.LDA,

  EInstructionRaw.LDX_IMM: EInstruction.LDX,
  EInstructionRaw.LDX_ZP: EInstruction.LDX,
  EInstructionRaw.LDX_ZPY: EInstruction.LDX,
  EInstructionRaw.LDX_ABS: EInstruction.LDX,
  EInstructionRaw.LDX_ABSY: EInstruction.LDX,

  EInstructionRaw.LDY_IMM: EInstruction.LDY,
  EInstructionRaw.LDY_ZP: EInstruction.LDY,
  EInstructionRaw.LDY_ZPX: EInstruction.LDY,
  EInstructionRaw.LDY_ABS: EInstruction.LDY,
  EInstructionRaw.LDY_ABSX: EInstruction.LDY,

  EInstructionRaw.LSR_ACC: EInstruction.LSR,
  EInstructionRaw.LSR_ZP: EInstruction.LSR,
  EInstructionRaw.LSR_ZPX: EInstruction.LSR,
  EInstructionRaw.LSR_ABS: EInstruction.LSR,
  EInstructionRaw.LSR_ABSX: EInstruction.LSR,

  EInstructionRaw.NOP_IMPL: EInstruction.NOP,

  EInstructionRaw.ORA_IMM: EInstruction.ORA,
  EInstructionRaw.ORA_ZP: EInstruction.ORA,
  EInstructionRaw.ORA_ZPX: EInstruction.ORA,
  EInstructionRaw.ORA_ABS: EInstruction.ORA,
  EInstructionRaw.ORA_ABSX: EInstruction.ORA,
  EInstructionRaw.ORA_ABSY: EInstruction.ORA,
  EInstructionRaw.ORA_INDX: EInstruction.ORA,
  EInstructionRaw.ORA_INDY: EInstruction.ORA,

  EInstructionRaw.PHA_IMPL: EInstruction.PHA,

  EInstructionRaw.PHP_IMPL: EInstruction.PHP,

  EInstructionRaw.PLA_IMPL: EInstruction.PLA,

  EInstructionRaw.PLP_IMPL: EInstruction.PLP,

  EInstructionRaw.ROL_ACC: EInstruction.ROL,
  EInstructionRaw.ROL_ZP: EInstruction.ROL,
  EInstructionRaw.ROL_ZPX: EInstruction.ROL,
  EInstructionRaw.ROL_ABS: EInstruction.ROL,
  EInstructionRaw.ROL_ABSX: EInstruction.ROL,

  EInstructionRaw.ROR_ACC: EInstruction.ROR,
  EInstructionRaw.ROR_ZP: EInstruction.ROR,
  EInstructionRaw.ROR_ZPX: EInstruction.ROR,
  EInstructionRaw.ROR_ABS: EInstruction.ROR,
  EInstructionRaw.ROR_ABSX: EInstruction.ROR,

  EInstructionRaw.RTI_IMPL: EInstruction.RTI,

  EInstructionRaw.RTS_IMPL: EInstruction.RTS,

  EInstructionRaw.SBC_IMM: EInstruction.SBC,
  EInstructionRaw.SBC_ZP: EInstruction.SBC,
  EInstructionRaw.SBC_ZPX: EInstruction.SBC,
  EInstructionRaw.SBC_ABS: EInstruction.SBC,
  EInstructionRaw.SBC_ABSX: EInstruction.SBC,
  EInstructionRaw.SBC_ABSY: EInstruction.SBC,
  EInstructionRaw.SBC_INDX: EInstruction.SBC,
  EInstructionRaw.SBC_INDY: EInstruction.SBC,

  EInstructionRaw.SEC_IMPL: EInstruction.SEC,

  EInstructionRaw.SED_IMPL: EInstruction.SED,

  EInstructionRaw.SEI_IMPL: EInstruction.SEI,

  EInstructionRaw.STA_ZP: EInstruction.STA,
  EInstructionRaw.STA_ZPX: EInstruction.STA,
  EInstructionRaw.STA_ABS: EInstruction.STA,
  EInstructionRaw.STA_ABSX: EInstruction.STA,
  EInstructionRaw.STA_ABSY: EInstruction.STA,
  EInstructionRaw.STA_INDX: EInstruction.STA,
  EInstructionRaw.STA_INDY: EInstruction.STA,

  EInstructionRaw.STX_ZP: EInstruction.STX,
  EInstructionRaw.STX_ZPY: EInstruction.STX,
  EInstructionRaw.STX_ABS: EInstruction.STX,

  EInstructionRaw.STY_ZP: EInstruction.STY,
  EInstructionRaw.STY_ZPX: EInstruction.STY,
  EInstructionRaw.STY_ABS: EInstruction.STY,

  EInstructionRaw.TAX_IMPL: EInstruction.TAX,

  EInstructionRaw.TAY_IMPL: EInstruction.TAY,

  EInstructionRaw.TSX_IMPL: EInstruction.TSX,

  EInstructionRaw.TXA_IMPL: EInstruction.TXA,

  EInstructionRaw.TXS_IMPL: EInstruction.TXS,

  EInstructionRaw.TYA_IMPL: EInstruction.TYA,
];

static const EInstructionType[EInstructionRaw] raw_to_type_map = [
  EInstructionRaw.ADC_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.ADC_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.ADC_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.ADC_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.ADC_ABSX: EInstructionType.ABSOLUTE_X,
  EInstructionRaw.ADC_ABSY: EInstructionType.ABSOLUTE_Y,
  EInstructionRaw.ADC_INDX: EInstructionType.INDIRECT_X,
  EInstructionRaw.ADC_INDY: EInstructionType.INDIRECT_Y,

  EInstructionRaw.AND_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.AND_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.AND_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.AND_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.AND_ABSX: EInstructionType.ABSOLUTE_X,
  EInstructionRaw.AND_ABSY: EInstructionType.ABSOLUTE_Y,
  EInstructionRaw.AND_INDX: EInstructionType.INDIRECT_X,
  EInstructionRaw.AND_INDY: EInstructionType.INDIRECT_Y,

  EInstructionRaw.ASL_ACC: EInstructionType.ACCUMULATOR,
  EInstructionRaw.ASL_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.ASL_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.ASL_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.ASL_ABSX: EInstructionType.ABSOLUTE_X,

  EInstructionRaw.BCC_REL: EInstructionType.RELATIVE,

  EInstructionRaw.BCS_REL: EInstructionType.RELATIVE,

  EInstructionRaw.BEQ_REL: EInstructionType.RELATIVE,

  EInstructionRaw.BIT_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.BIT_ABS: EInstructionType.ABSOLUTE,

  EInstructionRaw.BMI_REL: EInstructionType.RELATIVE,

  EInstructionRaw.BNE_REL: EInstructionType.RELATIVE,

  EInstructionRaw.BPL_REL: EInstructionType.RELATIVE,

  EInstructionRaw.BRK_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.BVC_REL: EInstructionType.RELATIVE,

  EInstructionRaw.BVS_REL: EInstructionType.RELATIVE,

  EInstructionRaw.CLC_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.CLD_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.CLI_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.CLV_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.CMP_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.CMP_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.CMP_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.CMP_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.CMP_ABSX: EInstructionType.ABSOLUTE_X,
  EInstructionRaw.CMP_ABSY: EInstructionType.ABSOLUTE_Y,
  EInstructionRaw.CMP_INDX: EInstructionType.INDIRECT_X,
  EInstructionRaw.CMP_INDY: EInstructionType.INDIRECT_Y,

  EInstructionRaw.CPX_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.CPX_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.CPX_ABS: EInstructionType.ABSOLUTE,

  EInstructionRaw.CPY_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.CPY_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.CPY_ABS: EInstructionType.ABSOLUTE,

  EInstructionRaw.DEC_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.DEC_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.DEC_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.DEC_ABSX: EInstructionType.ABSOLUTE_X,

  EInstructionRaw.DEX_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.DEY_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.EOR_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.EOR_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.EOR_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.EOR_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.EOR_ABSX: EInstructionType.ABSOLUTE_X,
  EInstructionRaw.EOR_ABSY: EInstructionType.ABSOLUTE_Y,
  EInstructionRaw.EOR_INDX: EInstructionType.INDIRECT_X,
  EInstructionRaw.EOR_INDY: EInstructionType.INDIRECT_Y,

  EInstructionRaw.INC_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.INC_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.INC_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.INC_ABSX: EInstructionType.ABSOLUTE_X,

  EInstructionRaw.INX_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.INY_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.JMP_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.JMP_IND: EInstructionType.INDIRECT,

  EInstructionRaw.JSR_ABS: EInstructionType.ABSOLUTE,

  EInstructionRaw.LDA_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.LDA_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.LDA_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.LDA_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.LDA_ABSX: EInstructionType.ABSOLUTE_X,
  EInstructionRaw.LDA_ABSY: EInstructionType.ABSOLUTE_Y,
  EInstructionRaw.LDA_INDX: EInstructionType.INDIRECT_X,
  EInstructionRaw.LDA_INDY: EInstructionType.INDIRECT_Y,

  EInstructionRaw.LDX_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.LDX_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.LDX_ZPY: EInstructionType.ZERO_PAGE_Y,
  EInstructionRaw.LDX_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.LDX_ABSY: EInstructionType.ABSOLUTE_Y,

  EInstructionRaw.LDY_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.LDY_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.LDY_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.LDY_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.LDY_ABSX: EInstructionType.ABSOLUTE_X,

  EInstructionRaw.LSR_ACC: EInstructionType.ACCUMULATOR,
  EInstructionRaw.LSR_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.LSR_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.LSR_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.LSR_ABSX: EInstructionType.ABSOLUTE_X,

  EInstructionRaw.NOP_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.ORA_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.ORA_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.ORA_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.ORA_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.ORA_ABSX: EInstructionType.ABSOLUTE_X,
  EInstructionRaw.ORA_ABSY: EInstructionType.ABSOLUTE_Y,
  EInstructionRaw.ORA_INDX: EInstructionType.INDIRECT_X,
  EInstructionRaw.ORA_INDY: EInstructionType.INDIRECT_Y,

  EInstructionRaw.PHA_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.PHP_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.PLA_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.PLP_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.ROL_ACC: EInstructionType.ACCUMULATOR,
  EInstructionRaw.ROL_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.ROL_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.ROL_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.ROL_ABSX: EInstructionType.ABSOLUTE_X,

  EInstructionRaw.ROR_ACC: EInstructionType.ACCUMULATOR,
  EInstructionRaw.ROR_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.ROR_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.ROR_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.ROR_ABSX: EInstructionType.ABSOLUTE_X,

  EInstructionRaw.RTI_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.RTS_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.SBC_IMM: EInstructionType.IMMEDIATE,
  EInstructionRaw.SBC_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.SBC_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.SBC_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.SBC_ABSX: EInstructionType.ABSOLUTE_X,
  EInstructionRaw.SBC_ABSY: EInstructionType.ABSOLUTE_Y,
  EInstructionRaw.SBC_INDX: EInstructionType.INDIRECT_X,
  EInstructionRaw.SBC_INDY: EInstructionType.INDIRECT_Y,

  EInstructionRaw.SEC_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.SED_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.SEI_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.STA_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.STA_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.STA_ABS: EInstructionType.ABSOLUTE,
  EInstructionRaw.STA_ABSX: EInstructionType.ABSOLUTE_X,
  EInstructionRaw.STA_ABSY: EInstructionType.ABSOLUTE_Y,
  EInstructionRaw.STA_INDX: EInstructionType.INDIRECT_X,
  EInstructionRaw.STA_INDY: EInstructionType.INDIRECT_Y,

  EInstructionRaw.STX_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.STX_ZPY: EInstructionType.ZERO_PAGE_Y,
  EInstructionRaw.STX_ABS: EInstructionType.ABSOLUTE,

  EInstructionRaw.STY_ZP: EInstructionType.ZERO_PAGE,
  EInstructionRaw.STY_ZPX: EInstructionType.ZERO_PAGE_X,
  EInstructionRaw.STY_ABS: EInstructionType.ABSOLUTE,

  EInstructionRaw.TAX_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.TAY_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.TSX_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.TXA_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.TXS_IMPL: EInstructionType.IMPLICIT,

  EInstructionRaw.TYA_IMPL: EInstructionType.IMPLICIT,
];

static const size_t[EInstructionType] type_to_size_map = [
  EInstructionType.IMPLICIT: 1,
  EInstructionType.ACCUMULATOR: 1,
  EInstructionType.IMMEDIATE: 2,
  EInstructionType.ZERO_PAGE: 2,
  EInstructionType.ZERO_PAGE_X: 2,
  EInstructionType.ZERO_PAGE_Y: 2,
  EInstructionType.RELATIVE: 2,
  EInstructionType.ABSOLUTE: 3,
  EInstructionType.ABSOLUTE_X: 3,
  EInstructionType.ABSOLUTE_Y: 3,
  EInstructionType.INDIRECT: 3,
  EInstructionType.INDIRECT_X: 2,
  EInstructionType.INDIRECT_Y: 2,
];
