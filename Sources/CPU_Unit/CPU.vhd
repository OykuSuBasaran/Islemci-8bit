library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity CPU is
    port(
            --inputs
            clk                 : in std_logic;
            rst                 : in std_logic;
            from_memory         : in std_logic_vector(7 downto 0);
            --outputs
            write_en            : out std_logic;
            address             : out std_logic_vector(7 downto 0);
            to_memory           : out std_logic_vector(7 downto 0) 
        );
end entity;

architecture arch of CPU is
--COMPONENTLER
component data_path is
    port(
            --inputs
            clk                 : in std_logic;
            rst                 : in std_logic;
            IR_Load             : in std_logic;
            MAR_Load            : in std_logic;
            PC_Load             : in std_logic;
            PC_Inc              : in std_logic;
            A_Load              : in std_logic;
            B_Load              : in std_logic;
            ALU_Sel             : in std_logic_vector(2 downto 0);
            CCR_Load            : in std_logic;
            BUS2_Sel            : in std_logic_vector(1 downto 0);
            BUS1_Sel            : in std_logic_vector(1 downto 0);
            from_memory         : in std_logic_vector(7 downto 0);
            --outputs
            IR                  : out std_logic_vector(7 downto 0);
            address             : out std_logic_vector(7 downto 0);
            CCR_result          : out std_logic_vector(3 downto 0);
            to_memory           : out std_logic_vector(7 downto 0)     
    
    );
end component;

component control_unit is
    port(
            --inputs
            clk                 : in std_logic;
            rst                 : in std_logic;
            IR                  : in std_logic_vector(7 downto 0); 
            CCR_result          : in std_logic_vector(3 downto 0);
            
            --outputs
            IR_Load             : out std_logic;
            MAR_Load             : out std_logic;
            PC_Load             : out std_logic;
            PC_Inc              : out std_logic;
            A_Load              : out std_logic;
            B_Load              : out std_logic;
            ALU_Sel             : out std_logic_vector(2 downto 0);
            CCR_Load            : out std_logic;
            BUS2_Sel            : out std_logic_vector(1 downto 0);
            BUS1_Sel            : out std_logic_vector(1 downto 0);
            write_en            : out std_logic
    
    );
end component;

--BAGLANTI SINYALLERI
signal IR_Load                  : std_logic;
signal IR                       : std_logic_vector(7 downto 0);
signal MAR_Load                 : std_logic;
signal PC_Load                  : std_logic;
signal PC_Inc                   : std_logic;
signal A_Load                   : std_logic;
signal B_Load                   : std_logic;
signal ALU_Sel                  : std_logic_vector(2 downto 0);
signal CCR_result               : std_logic_vector(3 downto 0);
signal CCR_Load                  : std_logic;
signal BUS2_Sel                 : std_logic_vector(1 downto 0);
signal BUS1_Sel                 : std_logic_vector(1 downto 0);



begin
--data path port map:
data_path_module : data_path port map  (
            
            clk                 =>    clk,
            rst                 =>    rst,
            IR_Load             =>    IR_Load,
            MAR_Load            =>    MAR_Load,
            PC_Load             =>    PC_Load,
            PC_Inc              =>    PC_Inc,
            A_Load              =>    A_Load,
            B_Load              =>    B_Load,
            ALU_Sel             =>    ALU_Sel,
            CCR_Load            =>    CCR_Load,
            BUS2_Sel            =>    BUS2_Sel,
            BUS1_Sel            =>    BUS1_Sel,
            from_memory         =>    from_memory,
            IR                  =>    IR,
            address             =>    address,
            CCR_result          =>    CCR_result,
            to_memory           =>    to_memory     
);

--control unit port map: 
control_unit_module : control_unit port map (

            clk                 =>    clk,       
            rst                 =>    rst,       
            IR                  =>    IR,        
            CCR_result          =>    CCR_result,
            IR_Load             =>    IR_Load,   
            MAR_Load            =>    MAR_Load,
            PC_Load             =>    PC_Load,   
            PC_Inc              =>    PC_Inc,    
            A_Load              =>    A_Load,    
            B_Load              =>    B_Load,    
            ALU_Sel             =>    ALU_Sel,   
            CCR_Load            =>    CCR_Load,  
            BUS2_Sel            =>    BUS2_Sel,  
            BUS1_Sel            =>    BUS1_Sel,  
            write_en            =>    write_en  
);                                      
                                        

end architecture;