library verilog;
use verilog.vl_types.all;
entity ALU_F10 is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        ALUFun          : in     vl_logic_vector(1 downto 0);
        Z               : out    vl_logic_vector(31 downto 0)
    );
end ALU_F10;
