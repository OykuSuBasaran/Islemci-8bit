library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity ALU is
port(
        --inputs
        A               : in std_logic_vector(7 downto 0);
        B               : in std_logic_vector(7 downto 0);
        ALU_sel         : in std_logic_vector(2 downto 0);
        --outputs
        ALU_result      : out std_logic_vector(7 downto 0);
        NZVC            : out std_logic_vector(3 downto 0)
);
end entity;

architecture arch of ALU is

signal  alu_signal : std_logic_vector(7 downto 0);
signal sum_unsigned : std_logic_vector(8 downto 0);
signal toplama_overflow : std_logic;
signal cikarma_overflow: std_logic;

begin
--ALU'nun result k�sm� 
process(A, B, ALU_sel)
begin
    sum_unsigned <= (others => '0');

    case ALU_sel is
        when "000" => --Toplama
            alu_signal <= A + B;
            sum_unsigned <= ('0' & A) + ('0' & B);
        when "001" => --��karma
            alu_signal <= A - B;
            sum_unsigned <= ('0' & A) - ('0' & B);
        when "010" => --and
            alu_signal <= A and B;
        when "011" => --or
            alu_signal <= A or B;
        when "100" => --inc
            alu_signal <= A + x"01";
        when "101" => --dec
            alu_signal <= A - x"01";
        when others =>
            alu_signal <= (others => '0');
            sum_unsigned <= (others => '0'); 
    end case;  
end process;

ALU_result <= alu_signal;

--NZVC k�sm� (negatif mi, s�f�r m�, overflow, carry)

--N:
NZVC(3) <= alu_signal(7);

--Z:
NZVC(2) <= '1' when (alu_signal = x"00") else '0';

--V:
toplama_overflow <= (not(A(7)) and not(B(7)) and alu_signal(7)) or (A(7) and B(7) and not (alu_signal(7)));
cikarma_overflow <= (not(A(7) and B(7) and alu_signal(7))) or (A(7) and not(B(7)) and not(alu_signal(7)));

NZVC(1) <= toplama_overflow when (ALU_sel = "000") else 
           cikarma_overflow when (ALU_sel = "001") else '0';

--C:
NZVC(0) <= sum_unsigned(8) when (ALU_sel = "000") else 
            sum_unsigned(8) when (ALU_sel = "001") else '0';


end architecture;