library verilog;
use verilog.vl_types.all;
entity IIR is
    port(
        data_in         : in     vl_logic_vector(23 downto 0);
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        data_out        : out    vl_logic_vector(23 downto 0)
    );
end IIR;
