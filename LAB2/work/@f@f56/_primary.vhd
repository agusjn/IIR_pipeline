library verilog;
use verilog.vl_types.all;
entity FF56 is
    port(
        \in\            : in     vl_logic_vector(55 downto 0);
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        \out\           : out    vl_logic_vector(55 downto 0)
    );
end FF56;
