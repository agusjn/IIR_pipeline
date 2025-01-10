library verilog;
use verilog.vl_types.all;
entity PIPFF is
    port(
        \in\            : in     vl_logic_vector(23 downto 0);
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        \out\           : out    vl_logic_vector(23 downto 0)
    );
end PIPFF;
