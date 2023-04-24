instrucoes = ["NOP", "LDA", "SOMA", "SUB", "LDI", "STA", "JMP", "JEQ", "CEQ", "JSR", "RET"]

# abre o arquivo "exemplo.txt" para leitura
arquivo = open("C:/DESCOMP/CONTADOR/instrucoes.txt", "r")

# lê todas as linhas do arquivo
linhas = arquivo.readlines()

# Converte decimal para hexadecimal
def dec_to_hex(num):
    hex_num = hex(num)[2:].upper() # converte para hexadecimal e remove o prefixo "0x"
    hex_num = hex_num.zfill(3) # preenche com zeros à esquerda até ter três dígitos
    return hex_num

# limpa instruções do arquivo e guarda
lista_arq_instru = []
cont=0
for i in linhas:
    # Se não tem instrução na linha comenta a linha
    if ('@' not in i) and ('$' not in i) :
        print(i.replace('\n', ''))
    # Tem instrução na linha
    else:
        # Cria uma lista de 2 itens ['nome_instru', 'End_Valor']
        if '@' in i:
            limpa_instru = i.replace('\n', '').split('@')
            limpa_instru[1] = limpa_instru[1].split('-')[0]
        elif '$' in i:
            limpa_instru = i.replace('\n', '').split('$')
            limpa_instru[1] = limpa_instru[1].split('-')[0]
        try:
            comentario =  i.replace('\n', '').split('-')[1]  
        except:
            comentario = ''
        # Coverte decimal para hexadecimal 
        end_ou_valor = dec_to_hex(int(limpa_instru[1]))
        
        # Gera os resultados com ou sem comentarios
        if end_ou_valor[0] == '1':
            if comentario != '':
                print(f"tmp({cont}) := {limpa_instru[0]} & '{end_ou_valor[0]}' & x\"{end_ou_valor[1:]}\";    -- {comentario}")
            else:
                print(f"tmp({cont}) := {limpa_instru[0]} & '{end_ou_valor[0]}' & x\"{end_ou_valor[1:]}\";")
        else:
            if comentario != '':
                print(f"tmp({cont}) := {limpa_instru[0]} & '0' & x\"{end_ou_valor[1:]}\";    -- {comentario}")
            else:
                print(f"tmp({cont}) := {limpa_instru[0]} & '0' & x\"{end_ou_valor[1:]}\";")
        cont+=1

#print(dec_to_hex(15))

# fecha o arquivo
arquivo.close()