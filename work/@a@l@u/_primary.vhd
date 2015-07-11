library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        ALUFun          : in     vl_logic_vector(5 downto 0);
        Sign            : in     vl_logic;
        Z               : out    vl_logic_vector(31 downto 0);
        Zero            : out    vl_logic;
        V               : out    vl_logic;
        N               : out    vl_logic
    );
end ALU;
