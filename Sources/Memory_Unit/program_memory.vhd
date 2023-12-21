library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity program_memory is
    port(
        --inputs
        clk :           in std_logic;
        address :       in std_logic_vector(7 downto 0);
        --outputs
        data_out :      out std_logic_vector(7 downto 0)   
    );
end entity;

architecture arch of program_memory is

--TUM KOMUTLAR:rom array içerisinde yazmak istediğimiz software programı için her seferinde gerekli 
--komutların kodunu aramaktansa bunları constant değişken olrak tanımlıyoruz ve kullanımını kolaylaştrıyoruz.


--loads and stores
constant LDA_IMM : std_logic_vector(7 downto 0) := x"86"; --load register A using immediate addressing
constant LDA_DIR : std_logic_vector(7 downto 0) := x"87"; --load register A using direct addressing
constant LDB_IMM : std_logic_vector(7 downto 0) := x"88"; --load register B using immediate addressing
constant LDB_DIR : std_logic_vector(7 downto 0) := x"89"; -- load register B using direct addressing
constant STA_DIR : std_logic_vector(7 downto 0) := x"96"; --store register A to memory using direct addressing
constant STB_DIR : std_logic_vector(7 downto 0) := x"97"; -- store register B to memory using direct addressing

--data manipulations
constant ADD_AB : std_logic_vector(7 downto 0) := x"42"; --A = A+B
constant SUB_AB : std_logic_vector(7 downto 0) := x"43"; --A = A-B
constant AND_AB : std_logic_vector(7 downto 0) := x"44"; --A = A . B (and)
constant OR_AB  : std_logic_vector(7 downto 0) := x"45"; --A = A + B (or)
constant INCA   : std_logic_vector(7 downto 0) := x"46"; --A = A + 1
constant INCB   : std_logic_vector(7 downto 0) := x"47"; --B = B + 1
constant DECA   : std_logic_vector(7 downto 0) := x"48"; --A = A - 1
constant DECB   : std_logic_vector(7 downto 0) := x"49"; --B = B - 1

--branches
constant BRA : std_logic_vector(7 downto 0) := x"20"; --branch always to address provided, ATLA
constant BMI : std_logic_vector(7 downto 0) := x"21"; --branch to address provided if N=1, ATLA NEGATIFSE
constant BPL : std_logic_vector(7 downto 0) := x"22"; --brach to address provided if N=0    ATLA POZITIFSE
constant BEQ : std_logic_vector(7 downto 0) := x"23"; --brach to address provided if Z=1    ATLA ESITSE SIFIR
constant BNE : std_logic_vector(7 downto 0) := x"24"; --branch to address provided if Z= 0  ATLA DEGILSE SIFIR
constant BVS : std_logic_vector(7 downto 0) := x"25"; --branch to address provided if V=1   ATLA OVERFLOW  VARSA
constant BVC : std_logic_vector(7 downto 0) := x"26"; --branch to address provided if V=0   ATLA OVERFLOW YOKSA
constant BCS : std_logic_vector(7 downto 0) := x"27"; --branch to address provided if C=1   ATLA ELDE VARSA
constant BCC : std_logic_vector(7 downto 0) := x"28"; --branch to address provided if C=0   ATLA ELDE YOKSA


-- software düzeyde bir program, örnek komutları tanımlamak istersek bu array indexlerine atayacağız komutları
type rom_type is array (0 to 127) of std_logic_vector(7 downto 0);
constant ROM : rom_type := (
                                0 => LDA_IMM,
                                1 => x"0F",
                                2 => STA_DIR,
                                3 => x"80",
                                4 => BRA,
                                5 => x"00",
                                others => x"00"
                            );

--adres aralığı kontrolü                            
signal enable : std_logic;

begin

process(address)
begin
    if(address >=  x"00" and address <= x"7F") then
        enable <= '1';
    else
        enable <= '0';
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(enable = '1')then
            data_out <= ROM(to_integer(unsigned (address)));
        end if;
    end if;
end process;
end arch;
