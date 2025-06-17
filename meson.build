project('lib6502d', 'd')

lib6502d_src = []

subdir('lib6502d')

lib6502d_inc = include_directories('lib6502d')

lib6502d_shared = shared_library(
  '6502d',
  lib6502d_src,
  include_directories: lib6502d_inc,
)

lib6502d_static = static_library(
  '6502d',
  lib6502d_src,
  include_directories: lib6502d_inc,
)

lib6502d = declare_dependency(
  link_with: lib6502d_shared,
  include_directories: lib6502d_inc,
)

lib6502ds = declare_dependency(
  link_with: lib6502d_shared,
  include_directories: lib6502d_inc,
)
