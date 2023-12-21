library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity memory is
    port(
        --inputs
        clk             : in std_logic;
        rst             : in std_logic;
        address         : in std_logic_vector(7 downto 0);
        data_in         : in std_logic_vector(7 downto 0);
        write_en        : in std_logic;
        port_in_00      : in std_logic_vector(7 downto 0);
        port_in_01      : in std_logic_vector(7 downto 0);
        port_in_02      : in std_logic_vector(7 downto 0);
        port_in_03      : in std_logic_vector(7 downto 0);
        port_in_04      : in std_logic_vector(7 downto 0);
        port_in_05      : in std_logic_vector(7 downto 0);
        port_in_06      : in std_logic_vector(7 downto 0);
        port_in_07      : in std_logic_vector(7 downto 0);
        port_in_08      : in std_logic_vector(7 downto 0);
        port_in_09      : in std_logic_vector(7 downto 0);
        port_in_10      : in std_logic_vector(7 downto 0);
        port_in_11      : in std_logic_vector(7 downto 0);
        port_in_12      : in std_logic_vector(7 downto 0);
        port_in_13      : in std_logic_vector(7 downto 0);
        port_in_14      : in std_logic_vector(7 downto 0);
        port_in_15      : in std_logic_vector(7 downto 0);
        
        --outputs
        data_out        : out std_logic_vector(7 downto 0);
        port_out_00     : out std_logic_vector(7 downto 0);
        port_out_01     : out std_logic_vector(7 downto 0);
        port_out_02     : out std_logic_vector(7 downto 0);
        port_out_03     : out std_logic_vector(7 downto 0);
        port_out_04     : out std_logic_vector(7 downto 0);
        port_out_05     : out std_logic_vector(7 downto 0);
        port_out_06     : out std_logic_vector(7 downto 0);
        port_out_07     : out std_logic_vector(7 downto 0);
        port_out_08     : out std_logic_vector(7 downto 0);
        port_out_09     : out std_logic_vector(7 downto 0);
        port_out_10     : out std_logic_vector(7 downto 0);
        port_out_11     : out std_logic_vector(7 downto 0);
        port_out_12     : out std_logic_vector(7 downto 0);
        port_out_13     : out std_logic_vector(7 downto 0);
        port_out_14     : out std_logic_vector(7 downto 0);
        port_out_15     : out std_logic_vector(7 downto 0)
         
    );
end entity;

architecture arch of memory is

--program memory component
component program_memory is
    port(
        --inputs
        clk :           in std_logic;
        address :       in std_logic_vector(7 downto 0);
        --outputs
        data_out :      out std_logic_vector(7 downto 0)   
    );
end component;

--data memory component
component data_memory is 
    port(
        clk:        in std_logic;
        address:    in std_logic_vector(7 downto 0);
        data_in:    in std_logic_vector(7 downto 0);
        write_en:   in std_logic; --CPU tarafından gönderilen kontrol sinyali, yaz emri      
        --outputs
        data_out:   out std_logic_vector(7 downto 0)       
    );
end component;


--output ports component
component output_ports is
    port(
            --inputs
            clk:            in std_logic;
            rst :           in std_logic;
            address:        in std_logic_vector(7 downto 0);
            data_in:        in std_logic_vector(7 downto 0);
            write_en:       in std_logic;
            --outputs
            port_out_00 :   out std_logic_vector(7 downto 0);
            port_out_01 :   out std_logic_vector(7 downto 0);
            port_out_02 :   out std_logic_vector(7 downto 0);
            port_out_03 :   out std_logic_vector(7 downto 0);
            port_out_04 :   out std_logic_vector(7 downto 0);
            port_out_05 :   out std_logic_vector(7 downto 0);
            port_out_06 :   out std_logic_vector(7 downto 0);
            port_out_07 :   out std_logic_vector(7 downto 0);
            port_out_08 :   out std_logic_vector(7 downto 0);
            port_out_09 :   out std_logic_vector(7 downto 0);
            port_out_10 :   out std_logic_vector(7 downto 0);
            port_out_11 :   out std_logic_vector(7 downto 0);
            port_out_12 :   out std_logic_vector(7 downto 0);
            port_out_13 :   out std_logic_vector(7 downto 0);
            port_out_14 :   out std_logic_vector(7 downto 0);
            port_out_15 :   out std_logic_vector(7 downto 0)

    
    );
end component;

--MUX sinyalleri
signal rom_out : std_logic_vector(7 downto 0);
signal ram_out : std_logic_vector(7  downto 0);

begin

--program memory (ROM) port map
ROM_U : program_memory port map(
        clk => clk, 
        address => address,
        data_out => rom_out
);

-- data memeory(RAM) port map
RAM_U : data_memory port map(
        clk => clk,
        address => address, 
        data_in => data_in,
        write_en => write_en,
        data_out => ram_out
);

--output ports port map
OUT_U : output_ports port map(
        clk => clk, 
        rst => rst, 
        address => address, 
        data_in => data_in, 
        write_en => write_en,
        port_out_00 => port_out_00,
        port_out_01 => port_out_01,
        port_out_02 => port_out_02,
        port_out_03 => port_out_03,
        port_out_04 => port_out_04,
        port_out_05 => port_out_05,
        port_out_06 => port_out_06,
        port_out_07 => port_out_07,
        port_out_08 => port_out_08,
        port_out_09 => port_out_09,
        port_out_10 => port_out_10,
        port_out_11 => port_out_11,
        port_out_12 => port_out_12,
        port_out_13 => port_out_13,
        port_out_14 => port_out_14,
        port_out_15 => port_out_15
);

process(address, rom_out, ram_out, port_in_00, port_in_01, port_in_02, port_in_03, port_in_04, port_in_05,  
                          port_in_06, port_in_07, port_in_08, port_in_09, port_in_10, port_in_11, 
                          port_in_12, port_in_13, port_in_14, port_in_15)
begin
    if(address >=  x"00" and address <= x"7F") then
        data_out <= rom_out;
    elsif(address >= x"80" and address <= x"DF") then
        data_out <= ram_out;
    elsif(address = x"F0")then
        data_out <= port_in_00;
    elsif(address = x"F1")then
        data_out <= port_in_01;
    elsif(address = x"F2")then
        data_out <= port_in_02;
    elsif(address = x"F3")then
        data_out <= port_in_03;
    elsif(address = x"F4")then
        data_out <= port_in_04;
    elsif(address = x"F5")then
        data_out <= port_in_05;
    elsif(address = x"F6")then
        data_out <= port_in_06;
    elsif(address = x"F7")then
        data_out <= port_in_07;
    elsif(address = x"F8")then
        data_out <= port_in_08;
    elsif(address = x"F9")then
        data_out <= port_in_09;
    elsif(address = x"FA")then
        data_out <= port_in_10;
    elsif(address = x"FB")then
        data_out <= port_in_11;
    elsif(address = x"FC")then
        data_out <= port_in_12;
    elsif(address = x"FD")then
        data_out <= port_in_13;
    elsif(address = x"FE")then
        data_out <= port_in_14;
    elsif(address = x"FF")then
        data_out <= port_in_15;
    else
        data_out <= x"00";
    end if;
    
end process;

end architecture;