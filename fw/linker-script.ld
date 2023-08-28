ENTRY(main)

PHDRS
{
    text PT_LOAD;
}

SECTIONS
{
  . = 0x00000;
  .text : { *(.text) } :text
}
