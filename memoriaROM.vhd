library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 13;
          addrWidth: natural := 9
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ : std_logic_vector(3 downto 0) := "0111";
  constant CEQ : std_logic_vector(3 downto 0) := "1000";
  constant JSR : std_logic_vector(3 downto 0) := "1001";
  constant RET : std_logic_vector(3 downto 0) := "1010";
  constant ANDI : std_logic_vector(3 downto 0) := "1100";
  
  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
      ------------------------------------- SETUP -------------------------------------------------
		--- Zera os Displays de Sete Segmentos ---
		tmp(0) := LDI  & '0' & x"00";    -- Carrega o acumulador com o valor 0    
		tmp(1) := STA  & '1' & x"20";    -- Armazena o valor do acumulador em HEX0
		tmp(2) := STA  & '1' & x"21";    -- Armazena o valor do acumulador em HEX1
		tmp(3) := STA  & '1' & x"22";    -- Armazena o valor do acumulador em HEX2
		tmp(4) := STA  & '1' & x"23";    -- Armazena o valor do acumulador em HEX3
		tmp(5) := STA  & '1' & x"24";    -- Armazena o valor do acumulador em HEX4
		tmp(6) := STA  & '1' & x"25";    -- Armazena o valor do acumulador em HEX4

		--- Apagando os LEDs ---
		tmp(7) := LDI  & '0' & x"00";    -- Carrega o acumulador com o valor 0
		tmp(8) := STA  & '1' & x"00";    -- Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
		tmp(9) := STA  & '1' & x"01";    -- Armazena o valor do bit 0 do acumulador no LEDR8
		tmp(10) := STA  & '1' & x"02";    -- Armazena o valor do bit 0 do acumulador no LDR9

		--- Inicializando VariÃ¡veis ---
		tmp(11) := LDI  & '0' & x"00";    -- Carrega o acumulador com o valor 0
		tmp(12) := STA  & '0' & x"00";    -- Armazena o valor do acumulador em MEM[0]
		tmp(13) := STA  & '0' & x"0A";    -- Armazena o valor do acumulador em MEM[10] (Unidades)
		tmp(14) := STA  & '0' & x"0B";    -- Armazena o valor do acumulador em MEM[11] (Dezenas)
		tmp(15) := STA  & '0' & x"0C";    -- Armazena o valor do acumulador em MEM[12] (Centenas)
		tmp(16) := STA  & '0' & x"0D";    -- Armazena o valor do acumulador em MEM[13] (Milhar)
		tmp(17) := STA  & '0' & x"0E";    -- Armazena o valor do acumulador em MEM[14] (Dezenas de Milhar)
		tmp(18) := STA  & '0' & x"0F";    -- Armazena o valor do acumulador em MEM[15] (Centena de Milhar)

		tmp(19) := LDI  & '0' & x"01";    -- Carrega o acumulador com o valor 1
		tmp(20) := STA  & '0' & x"01";    -- Armazena o valor do acumulador em MEM[1]

		tmp(21) := LDI  & '0' & x"09";    -- Carrega o acumulador com o valor 9
		tmp(22) := STA  & '0' & x"09";    -- Armazena o valor do acumulador em MEM[9]

		--------------------------------------  INICIO -----------------------------------------------

		---  Ler o botÃ£o de incremento de contagem (KEY0) ---
		tmp(23) := LDA  & '1' & x"60";    -- Carrega o acumulador com a leitura do botÃ£o KEY0
		tmp(24) := ANDI  & '0' & x"01";    -- Carrega o acumulador com a leitura do botÃ£o KEY0
		tmp(25) := CEQ  & '0' & x"00";    -- Compara com valor armazenado em MEM[0] (Valor 0)
		tmp(26) := JEQ  & '0' & x"1C";    -- Desvia para a linha 27 se igual a 0 (botao nao pressionado)
		tmp(27) := JSR  & '0' & x"21";    -- Desvia para a subrotina da linha 32
		tmp(28) := NOP  & '0' & x"00";    -- NOP
		
		---  Ler o botÃ£o de reiniciar contagem (FPGA_RESET) ---
		tmp(29) := LDA  & '1' & x"64";    -- Carrega o acumulador com a leitura do botÃ£o FPGA_RESET
		tmp(30) := CEQ  & '0' & x"00";    -- Compara com valor armazenado em MEM[0] (Valor 0)
		tmp(31) := JEQ  & '0' & x"00";    -- Desvia para a linha 23 se igual a 0 (botao pressionado)
		tmp(32) := JMP  & '0' & x"17";    -- JMP @23

		--- Verifica as unidades
		tmp(33) := STA  & '1' & x"FF";    -- Limpa KEY0
		tmp(34) := LDA  & '0' & x"0A";    -- Carrega o acumulador com o valor de MEM[10] (unidades)

		tmp(35) := CEQ  & '0' & x"09";    -- Compara com valor armazenado em MEM[9] (Valor 9)
		tmp(36) := JEQ  & '0' & x"29";    -- Desvia para a linha 40 se igual a 0 (=9)

		tmp(37) := SOMA  & '0' & x"01";    -- Soma acumulador com valor da MEM[1] (1)
		tmp(38) := STA  & '0' & x"0A";    -- Armazena o valor do acumulador em MEM[10] (unidades)
		tmp(39) := STA  & '1' & x"20";    -- Armazena o valor do acumulador em HEX0
		tmp(40) := JMP  & '0' & x"17";    -- JMP @23

		--- Verifica as Dezenas
		tmp(41) := LDA  & '0' & x"0B";    -- Carrega o acumulador com o valor de MEM[11] (Dezenas)
		tmp(42) := CEQ  & '0' & x"09";    -- Compara com valor armazenado em MEM[9] (Valor 9)
		tmp(43) := JEQ  & '0' & x"34";    -- Desvia para a linha 40 se igual a 0 (=9)
		
		tmp(44) := LDI  & '0' & x"00";    -- Carrega o acumulador com o valor 0
		tmp(45) := STA  & '0' & x"0A";    -- Armazena o valor do acumulador em MEM[10] (unidades)
		tmp(46) := STA  & '1' & x"20";    -- Armazena o valor do acumulador em HEX0
		
		tmp(47) := LDA  & '0' & x"0B";    -- Carrega o acumulador com o valor de MEM[11] (Dezenas)
		tmp(48) := SOMA  & '0' & x"01";   -- Soma acumulador com valor da MEM[1] (1)
		tmp(49) := STA  & '0' & x"0B";    -- Armazena o valor do acumulador em MEM[11] (Dezenas)
		tmp(50) := STA  & '1' & x"21";    -- Armazena o valor do acumulador em HEX1
		tmp(51) := JMP  & '0' & x"17";    -- JMP @23

		--- Verifica as Centenas
		tmp(52) := LDA  & '0' & x"0C";    -- Carrega o acumulador com o valor MEM[12] (Centenas)
		tmp(53) := CEQ  & '0' & x"09";    -- Compara com valor armazenado em MEM[9] (Valor 9)
		tmp(54) := JEQ  & '0' & x"3F";    -- Desvia para a linha 57 se igual a 0 (=9)
		
		tmp(55) := LDI  & '0' & x"00";    -- Carrega o acumulador com o valor 0
		tmp(56) := STA  & '0' & x"0B";    -- Armazena o valor do acumulador em MEM[11] (Dezenas)
		tmp(57) := STA  & '1' & x"21";    -- Armazena o valor do acumulador em HEX1
	
		tmp(58) := LDA  & '0' & x"0C";    -- Carrega o acumulador com o valor de MEM[12] (Centenas)
		tmp(59) := SOMA  & '0' & x"01";   -- Soma acumulador com valor da MEM[1] (1)
		tmp(60) := STA  & '0' & x"0C";    -- Armazena o valor do acumulador em MEM[12] (Centenas)
		tmp(61) := STA  & '1' & x"22";    -- Armazena o valor do acumulador em HEX2
		tmp(62) := RET  & '0' & x"00";    -- RET
		---------------------------------  OVERFLOW -----------------------------------------		
		
		--- Acende os LEDs ---
		tmp(63) := LDI  & '0' & x"FF";    -- Carrega o acumulador com o valor 1
		tmp(64) := STA  & '1' & x"00";    -- Armazena o valor do bit0 do acumulador no LDR0 ~ LEDR7
		tmp(65) := LDI  & '0' & x"01";    -- Carrega o acumulador com o valor 1
		tmp(66) := STA  & '1' & x"01";    -- Armazena o valor do bit 0 do acumulador no LEDR8
		tmp(67) := STA  & '1' & x"02";    -- Armazena o valor do bit 0 do acumulador no LDR9
		
		---  Ler o botÃ£o de reiniciar contagem (FPGA_RESET) ---
		tmp(68) := LDA  & '1' & x"64";    -- Carrega o acumulador com a leitura do botÃ£o FPGA_RESET
		tmp(69) := CEQ  & '0' & x"00";    -- Compara com valor armazenado em MEM[0] (Valor 0)
		tmp(70) := JEQ  & '0' & x"17";    -- Desvia para a linha 23 se igual a 0 (botao pressionado)
		tmp(71) := JMP  & '0' & x"44";    -- JMP @42
		
		
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;