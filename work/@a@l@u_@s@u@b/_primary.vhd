library verilog;
use verilog.vl_types.all;
entity ALU_SUB is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        Sign            : in     vl_logic;
        SUB             : out    vl_logic_vector(31 downto 0);
        Z               : out    vl_logic;
        N               : out    vl_logic;
        V               : out    vl_logic
    );
end ALU_SUB;
