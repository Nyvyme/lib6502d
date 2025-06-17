import instructions;

Instruction[] disassemble(ubyte[] data)
{
  Instruction[] instructions;

  const size_t datalen = data.length;
  size_t i = 0;
  while (i < datalen)
  {
    EInstructionRaw raw = cast(EInstructionRaw)data[i];

    auto ins = get_instruction(raw, data, i);
    instructions ~= ins;

    i += ins.size;
  }

  return instructions;
}
