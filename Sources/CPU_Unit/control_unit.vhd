library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity control_unit is
    port(
            --inputs
            clk             : in std_logic;
            rst             : in std_logic;
            IR              : in std_logic_vector(7 downto 0); 
            CCR_result      : in std_logic_vector(3 downto 0);
            
            --outputs
            IR_Load         : out std_logic;
            MAR_Load         : out std_logic;
            PC_Load         : out std_logic;
            PC_Inc          : out std_logic;
            A_Load          : out std_logic;
            B_Load          : out std_logic;
            ALU_Sel         : out std_logic_vector(2 downto 0);
            CCR_Load        : out std_logic;
            BUS2_Sel        : out std_logic_vector(1 downto 0);
            BUS1_Sel        : out std_logic_vector(1 downto 0);
            write_en        : out std_logic
    
    );
end entity;

architecture arch of control_unit is

type state_type is( S_FETCH_0, S_FETCH_1, S_FETCH_2, S_DECODE_3,
                    S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6, 
                    S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
                    S_LDB_IMM_4, S_LDB_IMM_5, S_LDB_IMM_6, 
                    S_LDB_DIR_4, S_LDB_DIR_5, S_LDB_DIR_6, S_LDB_DIR_7, S_LDB_DIR_8,
                    S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7, 
                    S_ADD_AB_4,
                    S_BRA_4, S_BRA_5, S_BRA_6,
                    S_BEQ_4, S_BEQ_5, S_BEQ_6, S_BEQ_7

                    );

signal current_state, next_state : state_type;


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

begin

--current state logic
process(clk, rst)is
begin
    if(rst = '1') then
        current_state <= S_FETCH_0;
    elsif(rising_edge(clk)) then
        current_state <= next_state; 
        
    end if;     
end process;

--next state logic, bu kýsýmda yalnýzca bir sonraki state atamalarýný yapmamýz gerekiyor. 
process(current_state, IR, CCR_Result)
begin
    case current_state is
        when S_FETCH_0 =>
            next_state <= S_FETCH_1;
        when S_FETCH_1 =>
            next_state <= S_FETCH_2;
        when S_FETCH_2 =>
            next_state <= S_DECODE_3;
        when S_DECODE_3 => 
            if(IR = LDA_IMM) then
                next_state <= S_LDA_IMM_4;
            elsif(IR = LDA_DIR) then
                next_state <= S_LDA_DIR_4;
            elsif(IR = LDB_IMM) then
                next_state <= S_LDB_IMM_4;
            elsif(IR = LDB_DIR) then
                next_state <= S_LDB_DIR_4;
            elsif(IR = STA_DIR) then
                next_state <= S_STA_DIR_4;
            elsif(IR = ADD_AB) then
                next_state <= S_ADD_AB_4;
            elsif(IR = BRA) then
                next_state <= S_BRA_4;
            elsif(IR = BEQ) then
                if(CCR_result(2) = '1') then --NZVC
                    next_state <= S_BEQ_4;
                else -- z= 0
                    next_state <= S_BEQ_7;
                end if;
            else 
                next_state <= S_FETCH_0;
            end if; 
        -----------------------
        when S_LDA_IMM_4 =>
            next_state <= S_LDA_IMM_5;
        when S_LDA_IMM_5 => 
            next_state <= S_LDA_IMM_6;
        when S_LDA_IMM_6 => 
            next_state <= S_FETCH_0;
        ------------------------
        when S_LDA_DIR_4 =>
            next_state <= S_LDA_DIR_5;
        when S_LDA_DIR_5 =>
            next_state <= S_LDA_DIR_6;
        when S_LDA_DIR_6 =>
            next_state <= S_LDA_DIR_7;
        when S_LDA_DIR_7 =>
            next_state <= S_LDA_DIR_8;
        when S_LDA_DIR_8 =>
            next_state <= S_FETCH_0;
        --------------------------
        when S_LDB_IMM_4 =>
            next_state <= S_LDB_IMM_5;
        when S_LDB_IMM_5 =>
            next_state <= S_LDB_IMM_6;
        when S_LDB_IMM_6 =>
            next_state <= S_FETCH_0;
        --------------------------
        when S_LDB_DIR_4 =>
            next_state <= S_LDB_DIR_5;
        when S_LDB_DIR_5 =>
            next_state <= S_LDB_DIR_6;
        when S_LDB_DIR_6 =>
            next_state <= S_LDB_DIR_7;
        when S_LDB_DIR_7 =>
            next_state <= S_LDB_DIR_8;
        when S_LDB_DIR_8 =>
            next_state <= S_FETCH_0;
        ------------------------
        when S_STA_DIR_4 =>
            next_state <= S_STA_DIR_5;
        when S_STA_DIR_5 =>
            next_state <= S_STA_DIR_6;
        when S_STA_DIR_6 =>
            next_state <= S_STA_DIR_7;
        when S_STA_DIR_7 =>
            next_state <= S_FETCH_0;
        -------------------------
        when S_ADD_AB_4 =>
            next_state <= S_FETCH_0;
        -------------------------
        when S_BRA_4 =>
            next_state <= S_BRA_5;
        when S_BRA_5 =>
            next_state <= S_BRA_6;
        when S_BRA_6 => 
            next_state <= S_FETCH_0;
        -------------------------
        when S_BEQ_4 =>
            next_state <= S_BEQ_5;
        when S_BEQ_5 =>
            next_state <= S_BEQ_6;
        when S_BEQ_6 =>
            next_state <= S_FETCH_0;
        when S_BEQ_7 =>
            next_state <= S_FETCH_0;
        --------------------------
        when others =>
            next_state <= S_FETCH_0;
    end case;
end process;

-- output logic process
process(current_state)
begin
    IR_Load <= '0';
    MAR_Load <= '0';
    PC_Load <= '0';
    PC_Inc <= '0';
    A_Load <= '0';
    B_Load <= '0';
    ALU_Sel <= (others => '0');
    CCR_Load <= '0';
    BUS2_Sel <= (others => '0');
    BUS1_Sel <= (others => '0');
    write_en <= '0';
    
    case current_state is
        when S_FETCH_0 =>
            BUS1_Sel <= "00"; --pc
            BUS2_Sel <= "01"; --bus1
            MAR_Load <= '1';
        when S_FETCH_1 =>
            PC_Inc <= '1';
        when S_FETCH_2 =>
            BUS2_Sel <= "10"; --from memory
            IR_Load <= '1';
        when S_DECODE_3 =>
            --next state güncel ve ilgili dallanma saðlandý.
        ---------------------
        when S_LDA_IMM_4 =>
            BUS1_Sel <= "00"; --pc
            BUS2_Sel <= "01"; --bus1
            MAR_Load <= '1'; --bus2'deki program sayacý deðeri 1'e alýndý.           
        when S_LDA_IMM_5 => 
            PC_Inc <= '1';
        when S_LDA_IMM_6 =>
            BUS2_Sel <= "10"; --from memory
            A_Load <= '1';
        --------------------- 
        when S_LDA_DIR_4 =>
            BUS1_Sel <= "00"; --pc
            BUS2_Sel <= "01"; --bus1
            MAR_Load <= '1'; --bus2'deki program sayacý deðeri MAR'a. 
        when S_LDA_DIR_5 =>
            PC_Inc <= '1';
        when S_LDA_DIR_6 =>
            BUS2_Sel <= "10"; --from memory
            MAR_Load <= '1'; --bus2'deki program sayacý deðeri MAR'a. 
        when S_LDA_DIR_7 =>
            --BOS: bellekten okuma  yapýlacak. 
        when S_LDA_DIR_8 =>
            BUS2_Sel <= "10"; --from memory
            A_Load <= '1';
        ----------------------
        when S_LDB_IMM_4 =>
            BUS1_Sel <= "00"; --pc
            BUS2_Sel <= "01"; --bus1
            MAR_Load <= '1'; --bus2'deki program sayacý deðeri MAR'a. 
        when S_LDB_IMM_5 =>
            PC_Inc <= '1';
        when S_LDB_IMM_6 =>
            BUS2_Sel <= "10"; --from memory
            B_Load <= '1';
        ---------------------
        when S_LDB_DIR_4 =>
            BUS1_Sel <= "00"; --pc
            BUS2_Sel <= "01"; --bus1
            MAR_Load <= '1'; --bus2'deki program sayacý deðeri MAR'a. 
        when S_LDB_DIR_5 =>
            PC_Inc <= '1';
        when S_LDB_DIR_6 =>
            BUS2_Sel <= "10"; --from memory
            MAR_Load <= '1'; --bus2'deki program sayacý deðeri MAR'a. 
        when S_LDB_DIR_7 =>
            --BOS: bellekten okuma yapýlacak. 
        when S_LDB_DIR_8 =>
            BUS2_Sel <= "10"; --from memory
            B_Load <= '1';
        --------------------
        when S_STA_DIR_4 =>
            BUS1_Sel <= "00"; --pc
            BUS2_Sel <= "01"; --bus1
            MAR_Load <= '1'; --bus2'deki program sayacý deðeri MAR'a. 
        when S_STA_DIR_5 =>
            PC_Inc <= '1';
        when S_STA_DIR_6 =>
            BUS2_Sel <= "10"; --from memory
            MAR_Load <= '1'; --bus2'deki program sayacý deðeri MAR'a. 
        when S_STA_DIR_7 =>
            BUS1_Sel <= "01"; --A_reg
            write_en <= '1';
        --------------------
        when S_ADD_AB_4 => 
            BUS1_Sel <= "01"; --A_reg
            BUS2_Sel <= "00"; --ALU result
            ALU_Sel <= "000"; --ALU'daki toplama kodu 
            A_Load <= '1';
            CCR_Load <= '1';
        --------------------
        when S_BRA_4 =>
            BUS1_Sel <= "00"; --pc
            BUS2_Sel <= "01"; --bus1
            MAR_Load <= '1';  --bus2'deki program sayacý deðeri MAR'a.
        when S_BRA_5 =>
            --BOS
        when S_BRA_6 =>
            BUS2_Sel <= "10"; --from memory
            PC_Load <= '1'; --program sayacý register'ýna bus2 verisini al. 
        --------------------
        when S_BEQ_4 =>
            BUS1_Sel <= "00"; --pc
            BUS2_Sel <= "01"; --bus1
            MAR_Load <= '1'; --bus2'deki program sayacý deðeri MAR'a. 
        when S_BEQ_5 =>
            --bos
        when S_BEQ_6 =>
            BUS2_Sel <= "10"; --from memory
            PC_Load <= '1'; --program sayacý register'ýna bus2 verisini al. 
        when S_BEQ_7 =>
            PC_Inc <= '1';
        --------------------
        when others  =>
            IR_Load <= '0';
            MAR_Load <= '0';
            PC_Load <= '0';
            A_Load <= '0';
            B_Load <= '0';
            ALU_Sel <= (others => '0');
            CCR_Load <= '0';
            BUS1_Sel <= (others => '0');
            BUS2_Sel <= (others => '0');
            write_en <= '0';              
    end case;
end process;

end architecture;
