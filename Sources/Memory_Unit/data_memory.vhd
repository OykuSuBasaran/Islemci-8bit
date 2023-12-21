library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity data_memory is 
    port(
        clk:        in std_logic;
        address:    in std_logic_vector(7 downto 0);
        data_in:    in std_logic_vector(7 downto 0);
        write_en:   in std_logic; --CPU tarafından gönderilen kontrol sinyali, yaz emri      
        --outputs
        data_out:   out std_logic_vector(7 downto 0)       
    );
end entity;

architecture arch of data_memory is

type ram_type is array(128 to 223) of std_logic_vector(7 downto 0);
signal RAM : ram_type := (others => x"00");

signal enable : std_logic;

begin

process(address)
begin
    if(address <= x"DF" and address >= x"80") then
        enable <= '1';
    else
        enable <= '0';
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(enable = '1' and write_en = '1') then 
            RAM(to_integer(unsigned(address))) <= data_in;
        elsif(enable = '1' and write_en = '0') then
            data_out <= RAM(to_integer(unsigned(address)));
        end if;
    end if;
end process;
end arch;