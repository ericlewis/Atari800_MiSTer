#
# user core constraints
#
# put your clock groups in here as well as any net assignments
#

derive_pll_clocks
derive_clock_uncertainty

set_clock_groups -asynchronous \
    -group [get_clocks {bridge_spiclk}] \
    -group [get_clocks {clk_74a}] \
    -group [get_clocks {clk_74b}] \
    -group [get_clocks {\
        ic|pll_core|pll_inst|general[0].gpll~PLL_OUTPUT_COUNTER|divclk \
        ic|pll_core|pll_inst|general[1].gpll~PLL_OUTPUT_COUNTER|divclk \
        ic|pll_core|pll_inst|general[2].gpll~PLL_OUTPUT_COUNTER|divclk\
    }] \
    -group [get_clocks {\
        ic|pll_vid|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk \
        ic|pll_vid|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk\
    }]
