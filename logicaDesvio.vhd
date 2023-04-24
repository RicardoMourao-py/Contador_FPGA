library ieee;
use ieee.std_logic_1164.all;

entity logicaDesvio is
  -- Total de bits das entradas e saidas
  port (
	 JMP, RET, JSR, JEQ: in std_logic;
	 Flag: in std_logic;
    saida_Desvio : out std_logic_vector (1 downto 0)
  );
end entity;

architecture comportamento of logicaDesvio is
  begin
    saida_Desvio <= RET & ((JEQ and Flag) or JMP or JSR);
end architecture;