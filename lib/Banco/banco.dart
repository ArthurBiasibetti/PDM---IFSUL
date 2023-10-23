import 'package:postgres/postgres.dart';

class Banco {
  PostgreSQLConnection? _conexao;

  List<Map<String, Map<String, dynamic>>>? _result;
  int? _numRegistro;

  Banco(Function callbackError,
      {String url = '200.19.1.18',
      int porta = 5432,
      String banco = 'arthurbiasibettifarias',
      String usuario = 'arthurbiasibettifarias',
      String senha = '123456'}) {
    try {
      _conexao = PostgreSQLConnection(url, porta, banco,
          username: usuario, password: senha);
      print('Conexão bem sucedida!');
    } catch (e) {
      callbackError(e.toString());
    }
  }

  fecha() {
    _conexao!.close();
  }

  Future query(String comando, Function callbackSuccess, callbackError) async {
    try {
      await _conexao!.open();
      _result = null;
      List<Map<String, Map<String, dynamic>>>? result =
          await _conexao!.mappedResultsQuery(comando);
      _result = result;
      _numRegistro = result.length;
      callbackSuccess(_numRegistro, _result);
    } catch (e) {
      callbackError(e.toString());
    } finally {
      _conexao!.close();
    }
  }
}
