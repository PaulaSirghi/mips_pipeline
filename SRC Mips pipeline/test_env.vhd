----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.02.2021 16:24:03
-- Design Name: 
-- Module Name: saqwdf - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity saqwdf is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end saqwdf;

architecture Behavioral of saqwdf is
signal nr : STD_LOGIC_VECTOR(15 downto 0):="0000000000000000";
signal enb : STD_LOGIC;
--iesire numarator
signal num: std_logic_vector(1 downto 0):="00";
--iesire mux
signal mux: std_logic_vector(15 downto 0):="0000000000000000";
--iesiri zero ext
signal z1: std_logic_vector(15 downto 0):="0000000000000000";
signal z2: std_logic_vector(15 downto 0):="0000000000000000";
signal z3: std_logic_vector(15 downto 0):="0000000000000000";
--intrari mux
signal A: std_logic_vector(15 downto 0):="0000000000000000";  
signal B: std_logic_vector(15 downto 0):="0000000000000000";
signal C: std_logic_vector(15 downto 0):="0000000000000000";
signal D: std_logic_vector(15 downto 0):="0000000000000000";
--luam in semnale 2 perechi ce 4 biti din sw si una de cate 8 confosrm schemei din laborator
signal x: std_logic_vector(3 downto 0):="0000";  
signal y: std_logic_vector(3 downto 0):="0000";
signal z: std_logic_vector(7 downto 0):="00000000";
--semnal pentru enable si reset
signal en:std_logic:='0';
signal reset: std_logic:='0';
--lab 3
--semnal pt numarator
signal nr3: std_logic_vector(7 downto 0):="00000000";
signal DO: std_logic_vector(15 downto 0):="0000000000000000";

--semnale pt numaratorul pe 4 biti
signal nr4: std_logic_vector(3 downto 0):="0000";
--semnale pt bloc de memorie
signal RD1 : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";
signal RD2 : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";
signal WD : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";
--semnal pt al doilea MPG
signal en2: std_logic:='0';
--iesiri instrF
signal Instruction : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";
signal PC : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";

signal BA : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";
signal JA : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";
--semnale pentru ID
signal Ext_Imm   :  STD_LOGIC_VECTOR (15 downto 0):="0000000000000000";
signal func   :   STD_LOGIC_VECTOR (2 downto 0):="000";
signal sa   : STD_LOGIC:='0'; 
--semnale UC
signal RegDst :  STD_LOGIC:='0';
signal ExtOp :   STD_LOGIC:='0';
signal   RegWrite  :   STD_LOGIC:='0';
signal   ALUSrc   :  STD_LOGIC:='0';
signal  ALUOp :  STD_LOGIC_VECTOR(1 DOWNTO 0):="00";
signal MemWrite:  std_logic:='0';
signal MemtoReg: std_logic:='0';
signal Branch1  :  STD_LOGIC:='0';
signal Branch2  :  STD_LOGIC:='0';
signal Branch3  :  STD_LOGIC:='0';
signal Jump   :  STD_LOGIC:='0';
signal zero   :  STD_LOGIC:='0';
signal ALURes   :  STD_LOGIC_VECTOR(15 DOWNTO 0):=x"0000";
signal ALURes2   :  STD_LOGIC_VECTOR(15 DOWNTO 0):=x"0000";
signal PCSrc   :  STD_LOGIC:='0';
signal b1   :  STD_LOGIC:='0';
signal b2   :  STD_LOGIC:='0';
signal b3   :  STD_LOGIC:='0';
signal nzero: std_logic:='0';
signal sign: std_logic:='0';


--MIPS PIPELINE
--lab 9
signal IF_ID :std_logic_vector(31 downto 0):=X"00000000";
signal ID_EX :std_logic_vector(83 downto 0):="000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
signal EX_MEM :std_logic_vector(58 downto 0):="00000000000000000000000000000000000000000000000000000000000";
signal MEM_WB :std_logic_vector(36 downto 0):="0000000000000000000000000000000000000";


component MPG is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);   
end component MPG;

component SSD is
Port ( clk : in STD_LOGIC;
        sw : in STD_LOGIC_VECTOR (15 downto 0);
        an : out STD_LOGIC_VECTOR (3 downto 0);
        cat : out STD_LOGIC_VECTOR (6 downto 0));
end component SSD;

component blocReg is
  Port ( clk : in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (3 downto 0);
           RA2 : in STD_LOGIC_VECTOR (3 downto 0);
           WA : in STD_LOGIC_VECTOR (3 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RegWn: in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end component blocReg;

component RAMwf is
Port ( clk : in STD_LOGIC;
           RA1 : in STD_LOGIC_VECTOR (3 downto 0);
           WA : in STD_LOGIC_VECTOR (3 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RegWn: in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0));
end component RAMwf;

component InstrF is
    Port ( Jump : in  STD_LOGIC;
           PCSrc : in  STD_LOGIC;
           JA   : in  STD_LOGIC_VECTOR (15 downto 0);
           BA   : in  STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           en: std_logic:='0';
           reset: std_logic:='0';
           i   : out  STD_LOGIC_VECTOR (15 downto 0);
           PC_o   : out STD_LOGIC_VECTOR (15 downto 0));
end component InstrF;

component UC is
    Port ( Instr : in  STD_LOGIC_VECTOR(2 downto 0);
           RegDst : out  STD_LOGIC;
           ExtOp : out  STD_LOGIC;
           RegWrite  : out  STD_LOGIC;
           ALUSrc   : out  STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR(1 DOWNTO 0);
           MemWrite: out std_logic;
           MemtoReg: out std_logic;
           Branch1  : out  STD_LOGIC;
           Branch2  : out  STD_LOGIC;
           Branch3  : out  STD_LOGIC;
           Jump   : out STD_LOGIC);
end component UC;

component EX is
    Port ( RD1 : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUSrc   : in  STD_LOGIC;
           RD2   : in  STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
           PC: in STD_LOGIC_VECTOR(15 downto 0);
           zero : out STD_LOGIC;
           BA: out STD_LOGIC_VECTOR(15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           sign: out STD_LOGIC);
end component;

component MEM Port ( clk : in STD_LOGIC;
           WA : in STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite: in STD_LOGIC;
           en: in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes: out STD_LOGIC_VECTOR(15 downto 0));
end component MEM;

signal instr: std_logic_vector(15 downto 0):="0000000000000000";
signal MemData: std_logic_vector(15 downto 0):="0000000000000000";


component ID_c is
    Port ( RegWrite : in  STD_LOGIC;
           Instr   : in  STD_LOGIC_VECTOR (15 downto 0);
           RegDst : in  STD_LOGIC;
           ExtOp   : in  STD_LOGIC;
           clk : in STD_LOGIC;
           WD   : in STD_LOGIC_VECTOR (15 downto 0);
           Enable: in STD_LOGIC;
           RD1   : out  STD_LOGIC_VECTOR (15 downto 0);
           RD2   : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm   : out STD_LOGIC_VECTOR (15 downto 0);
           func   : out  STD_LOGIC_VECTOR (2 downto 0);
           sa   : out STD_LOGIC);            
end component ID_c;


begin
--c1 : MPG port map(clk,sw(1),enb);
--c2 : lab2_1 port map(clk,sw,an,cat);

--led<=sw;  --leaga swich de leduri
--an<=btn(3 downto 0);  --anozii activi de la SSD
--cat<=(others=>'0');  --catozii de la SSD activi

--process(clk,enb,sw(0))  --am realizat modificarile mentionate
--begin
 --  if rising_edge(clk) then
 --     if enb='1' then
  --       if sw(0)='1' then
  --          nr<=nr+1;
   --      else
     --       nr<=nr-1;
    --     end if;
     -- end if;
  -- end if;
--end process;

--ALU
--componentaL1: MPG port map(clk,btn(0),en);  --componenta MPG
--process (clk,en) --numarator
--begin
    --if rising_edge(clk) then
       --if en='1' then
      --  num<=num+1;
    --   end if;
  --   end if;
--end process;

--process(sw)  --extindere cu 0
--begin
    --x<=sw(3 downto 0);y<=sw(7 downto 4);z<=sw(7 downto 0);
    --z1(3 downto 0)<=x;
    --z1(15 downto 4)<="000000000000";
    --z2(3 downto 0)<=y;
    --z2(15 downto 4)<="000000000000";
    --z3(7 downto 0)<=z;
  --  z3(15 downto 8)<="00000000";
--end process;

--process (z1,z2)  --sumatorul
--begin
  --  A<=z1+z2;
--end process;

--process(z1,z2) --scazatorul
--begin
--   B<=z1-z2;
--end process;

--process(z3)--deplasare la stg cu 2 pozitii
--begin
 --   C<=z3; 
 --   C(15 downto 2)<=sw(13 downto 0);
 --   C(1 downto 0)<="00";
--end process;

--process(z3) --deplasare la dr cu 2 pozitii
--begin
 --  D<=z3;
 --  D(13 downto 0)<=sw(15 downto 2);
 --  D(15 downto 14)<="00";
--end process;

--process (clk,num)--mux
--begin
   -- case num is
  --  when "00"=> mux<=A;
  --  when "01"=> mux<=B;
  --  when "10"=> mux<=C;
 --   when others=> mux<=D; 
 --   end case;
--end process;


 -- led(7)<='1' when mux=0 else '0';
---end process;
--componenta: SSD port map(clk,mux,an,cat);  --componenta cu afiorul (ssd)

-- lab 3

-- pb 1
-- rom 256 x 16; numarator pe 8 biti pt adresa de pe rom
-- continutul se afiseaza pe ssd; ROM asincron

--cl1_3: MPG port map(clk,btn(0),en);  --componenta MPG
--process (clk,en) --numarator
--begin
  --  if rising_edge(clk) then
    --  if en='1' then
      -- nr3<=nr3+1;
      -- end if;
     --end if;
--end process;

--process(nr3)
--begin --ROM
  --  DO<=mem(conv_integer(nr3));
--end process;
--cSSD: lab2_1 port map(clk,DO,an,cat);  --componenta cu afiorul (ssd)

-- pb 2
--bloc de registre
--cl1_3: MPG port map(clk,btn(0),en);
--cl1_31: MPG port map(clk,btn(2),reset);
--process (clk,en,reset) --numarator
--begin
 --  if rising_edge(clk) then
   --    if reset='1' then 
   --         nr4<="0000";
    --   elsif en='1' then
    --            nr4<=nr4+1;
   --    end if;
  -- end if;
--end process;

--cMPG: MPG port map(clk,btn(1),en2);
--cl3_RegFILE: blocReg port map(clk,nr4,nr4,nr4,WD,en2,RD1,RD2);
--process (RD1,RD2)  --bloc reg
--begin
--    WD<=RD1+RD2;
--end process;
--ssd: SSD port map(clk,WD,an,cat);


--pb3
--cl1_3: MPG port map(clk,btn(0),en);
--cl1_31: MPG port map(clk,btn(2),reset);
--process (clk,en,reset) --numarator
--begin
--  if rising_edge(clk) then
--       if reset='1' then 
--            nr4<="0000";
--      elsif en='1' then
--           nr4<=nr4+1;
--      end if;
--  end if;
--end process;

--cMPG: MPG port map(clk,btn(1),en2);
--cl3_RAM: RAMwf port map(clk,nr4,nr4,WD,en2,RD1);
--process (RD1,RD2)  --bloc reg
--begin
--    WD<=RD1(13 downto 0)&"00";
--end process;

--ssd_comp: SSD port map(clk,WD,an,cat);
--MPGComponent: MPG port map(clk,btn(0),en);  --componenta MPG
--process (clk,en,reset) --numarator
--begin
--   if rising_edge(clk) then
--     if en='1' then
--       nr3<=nr3+1;
--       end if;
--     end if;
--end process;

--process(nr3,clk)
--begin --ROM
--    DO<=mem(conv_integer(nr3));
--end process;
--cSSD: SSD port map(clk,DO,an,cat);  --componenta cu afiorul (ssd)

  
   
    MPGc: MPG port map(clk,btn(1),en);
    MPGc2: MPG port map(clk,btn(2),reset);
    IF_c: InstrF port map(Jump,PCSrc,JA,EX_MEM(50 downto 35),clk,en,reset,Instruction,PC);
    UC_c: UC port map(IF_ID(15 downto 13),RegDst,ExtOp,RegWrite, ALUSrc, ALUOp, MemWrite,MemtoReg,Branch1,Branch2,Branch3,Jump);
    ID: ID_c port map(RegWrite,IF_ID(15 downto 0),RegDst,ExtOp,clk,WD,en,RD1,RD2,Ext_Imm,func,sa);
   process(sw)
   begin
    case sw(7 downto 5) is 
    when "000" => DO <= IF_ID(15 downto 0);  --instruction
    when "001" => DO <= IF_ID(31 downto 16);  --pc
    when "010" => DO <= ID_EX(57 downto 42); --rd1
    when "011" => DO <= EX_MEM(18 downto 3); --rd2
    when "100" => DO <= ID_EX(25 downto 10); --ext_imm
    when "101" =>DO<=EX_MEM(36 downto 21); --ALURes
    when "110" =>DO<=MEM_WB(34 downto 19);  --MEMData
    when "111"=>DO<= WD; --WD
    end case;
    end process;
    cSSD: SSD port map(clk,DO,an,cat);  --componenta cu afiorul (ssd)
   -- process(Instruction(15 downto 13))
    --begin
    --led(0)<=RegDst;
    --led(1)<=ExtOp;
   -- led(2)<=RegWrite;
    --led(3)<=ALUSrc;
    --led(4)<=ALUOp(0);
    --led(5)<=ALUOp(1);
    --led(6)<=MemWrite;
    --led(7)<=MemtoReg;
    --led(8)<=Branch1;
    --led(9)<=Branch2;
    --led(10)<=Branch3;
    --led(11)<=Jump;
    --end process;
    
     cEX: EX port map(ID_EX(57 downto 42),ID_EX(75),ID_EX(41 downto 26),ID_EX(25 downto 10),ID_EX(3),ID_EX(2 downto 0),ID_EX(77 downto 76),ID_EX(73 downto 58),zero,BA,ALURes,sign);  
     cMEM: MEM port map(clk,EX_MEM(34 downto 19),EX_MEM(18 downto 3),EX_MEM(56),en,MemData,ALURes2);
    process(MemtoReg)
    begin
    if MemtoReg='0' then WD<=MEM_WB(18 downto 3);  --ALURes
    else
    WD<=MEM_WB(34 downto 19); --MemData
    end if;
    end process;
    
    
    --mips pipeline
    --lab 9
    --proces registru if_id
    process(en,clk,PC,Instruction)
    begin
    if rising_edge(clk) then
        IF_ID(31 downto 16)<=PC;
        IF_ID(15 downto 0)<=Instruction;
    end if;
    end process;
    
    --proces registru id_ex
    process(en,clk,IF_ID,MemtoReg,RegWrite,MemWrite,Branch1,Branch2,Branch3,ALUOp,ALUSrc,RegDst,RD1,RD2,Ext_Imm,sa,func)
    begin
    if rising_edge(clk) then
        ID_EX(83)<=MemtoReg;
        ID_EX(82)<=RegWrite;
        ID_EX(81)<=MemWrite;
        ID_EX(80)<=Branch1;
        ID_EX(79)<=Branch2;
        ID_EX(78)<=Branch3;
        ID_EX(77 downto 76)<=ALUOp;
        ID_EX(75)<=ALUSrc;
        ID_EX(74)<=RegDst;
        ID_EX(73 downto 58)<=IF_ID(31 downto 16);
        ID_EX(57 downto 42)<=RD1;
        ID_EX(41 downto 26)<=RD2;
        ID_EX(25 downto 10)<=Ext_imm;
        ID_EX(9 downto 7)<=IF_ID(9 downto 7);
        ID_EX(6 downto 4)<=IF_ID(6 downto 4);
        ID_EX(3)<=sa;
        ID_EX(2 downto 0)<=func;
        JA<="000"& IF_ID(12 downto 0);
        
    end if;
    end process;
    
     --proces registru ex/mem
    process(en,clk,BA,ID_EX,RegDst,zero,ALURes2,sign)
    begin
    if rising_edge(clk) then
         EX_MEM(58)<=ID_EX(83);
         EX_MEM(57)<=ID_EX(82);
         EX_MEM(56)<=ID_EX(81);
         EX_MEM(55)<=ID_EX(80); --
         EX_MEM(54)<=ID_EX(79);--
         EX_MEM(53)<=ID_EX(78);--
         EX_MEM(52 downto 37)<=BA;
         EX_MEM(36)<=Zero;
         EX_MEM(35)<=sign;
         EX_MEM(34 downto 19)<=ALURes2;
         EX_MEM(18 downto 3)<=ID_EX(41 downto 26);
         if RegDst='0' then 
            EX_MEM(2 downto 0)<=ID_EX(9 downto 7);
         else
          EX_MEM(2 downto 0)<=ID_EX(6 downto 4);
         end if;
         
    end if;
    end process;
    
    --proces registru mem/wb
    process(en,clk,MemData,EX_MEM)
    begin
         b1<=(EX_MEM(55) and EX_MEM(36));
         nzero<=not(EX_MEM(36));
         b2<=EX_MEM(54) and nzero;
         b3<=EX_MEM(53) and EX_MEM(35);
         PCSrc<= b1 or b2 or b3;
    if rising_edge(clk) then
        MEM_WB(36)<=EX_MEM(58); --memtoReg
        MEM_WB(35)<=EX_MEM(57); --RegWrite
        MEM_WB(34 downto 19)<=MemData;
        MEM_WB(18 downto 3)<=EX_MEM(34 downto 19); --alu res
        MEM_WB(2 downto 0)<=EX_MEM(2 downto 0); --mux rez
    end if;
    end process;
    
end Behavioral;
