#if defined(TEST_HEADER) && defined(TEST_CLASS)

#include <systemc.h>
#include <verilated.h>

#include TEST_HEADER

int sc_main(int argc, char* argv[]) {
    TEST_CLASS* top = new TEST_CLASS{"top"};
    Verilated::commandArgs(argc, argv);
    sc_start(1, SC_NS);
    while (!Verilated::gotFinish())
        sc_start(1, SC_NS);
    top->final();
    return 0;
}

#else

int sc_main(int argc, char* argv[]) {
    return -1;
}

#endif
