import instructions;

struct InstructionDisasm
{
  Instruction ins;
  size_t times = 1;
}

InstructionDisasm[] process_instructions(Instruction[] instructions)
{
  InstructionDisasm[] out_instructions;

  size_t nop_times = 0;
  size_t nop_addr = -1;
  foreach (Instruction ins; instructions)
  {
    if (ins.ins == EInstruction.NOP)
    {
      if (nop_addr != -1)
      {
        nop_addr = ins.address;
      }

      nop_times++;
      continue;
    }

    if (nop_times > 0)
    {
      InstructionDisasm nop_ins = {};
      nop_ins.ins = get_instruction(EInstructionRaw.NOP_IMPL);
      nop_ins.ins.address = nop_addr;
      nop_ins.times = nop_times;
      out_instructions ~= nop_ins;

      nop_times = 0;
      nop_addr = -1;
    }

    InstructionDisasm out_ins = {};
    out_ins.ins = ins;
    out_instructions ~= out_ins;
  }

  if (nop_times > 0)
  {
    InstructionDisasm nop_ins = {};
    nop_ins.ins = get_instruction(EInstructionRaw.NOP_IMPL);
    nop_ins.ins.address = nop_addr;
    nop_ins.times = nop_times;
    out_instructions ~= nop_ins;
  }

  return out_instructions;
}

Instruction[] disassemble(ubyte[] data)
{
  Instruction[] instructions;

  const size_t datalen = data.length;
  size_t i = 0;
  while (i < datalen)
  {
    EInstructionRaw raw = cast(EInstructionRaw) data[i];

    auto ins = get_instruction(raw, data, i);
    instructions ~= ins;

    i += ins.size;
  }

  return instructions;
}
