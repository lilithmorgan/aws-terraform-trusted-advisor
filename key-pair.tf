/* 
  Cria a chave publica para o Conexao no Servidor
  Estas  chaves não devem ser compartilhadas no github
*/

resource "aws_key_pair" "Chave" {
  key_name   = "Chave"
  public_key = file("./Keys/key.pub")
}
