#include "verilated.h"

/**
 * \def TEST_HEADER
 * \brief Verilator header file to be included
 *
 * \def TEST_CLASS
 * \brief Verilator model class
 */

#if defined(TEST_HEADER) && defined(TEST_CLASS)

#include TEST_HEADER

#include <memory>

int main(int argc, char** argv, char**) {
    // Setup context, defaults, and parse command line
    Verilated::debug(0);
    const std::unique_ptr<VerilatedContext> context{new VerilatedContext};
    context->traceEverOn(true);
    context->commandArgs(argc, argv);

    // Construct the Verilated model, from TEST_HEADER generated from Verilating
    const std::unique_ptr<TEST_CLASS> top{new TEST_CLASS{context.get()}};

    // Simulate until $finish
    while (!context->gotFinish()) {
        // Evaluate model
        top->eval();
        // Advance time
        if (!top->eventsPending()) break;
        context->time(top->nextTimeSlot());
    }

    if (!context->gotFinish()) {
        VL_DEBUG_IF(VL_PRINTF("+ Exiting without $finish; no events left\n"););
    }

    // Final model cleanup
    top->final();
    return 0;
}

#else

int main(int argc, char** argv, char**) {
    VL_DEBUG_IF(VL_PRINTF("+ Undefined TEST_HEADER and TEST_CLASS\n"););
	return -1;
}

#endif
