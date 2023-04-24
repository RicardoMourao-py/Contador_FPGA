library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  --Soma (esta biblioteca =ieee)

entity decodificador3x8 is
    port
    (
        entrada: in  STD_LOGIC_VECTOR(2 downto 0);
        saida:   out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture comportamento of decodificador3x8 is
    begin
        saida <= x"01" when (entrada = "000") else
					  x"02" when (entrada = "001") else
					  x"04" when (entrada = "010") else
					  x"08" when (entrada = "011") else
					  x"10" when (entrada = "100") else
					  x"20" when (entrada = "101") else
					  x"40" when (entrada = "110") else
					  x"80" when (entrada = "111") else
					  x"01";
end architecture;