import 'package:postgres/postgres.dart';

class Banco {
  PostgreSQLConnection? _conexao;

  List<Map<String, Map<String, dynamic>>>? _result;
  int? _numRegistro;
  String _db_url = '200.19.1.18';
  int _port = 5432;
  String _db = 'arthurbiasibettifarias';
  String _user = 'arthurbiasibettifarias';
  String _password = '123456';
  bool _isOpen = false;

  Banco(Function callbackError,
      {String url = '200.19.1.18',
      int porta = 5432,
      String banco = 'arthurbiasibettifarias',
      String usuario = 'arthurbiasibettifarias',
      String senha = '123456'}) {
    try {
      _db_url = url;
      _port = porta;
      _db = banco;
      _user = usuario;
      _password = senha;

      open();
    } catch (e) {
      callbackError(e.toString());
    }
  }

  open() {
    _conexao = PostgreSQLConnection(_db_url, _port, _db,
        username: _user, password: _password);
    _isOpen = true;
    print('Conexão bem sucedida!');
  }

  fecha() {
    _conexao!.close();
    _isOpen = false;
    print('Conexão fechada!');
  }

  Future query(String comando, Function callbackSuccess, callbackError) async {
    try {
      if (!_isOpen) {
        open();
      }
      await _conexao!.open();

      _result = null;
      var result = await _conexao!.mappedResultsQuery(comando);
      _result = result;
      _numRegistro = result.length;

      callbackSuccess(_numRegistro, _result);
    } catch (e) {
      callbackError('erro: $e.toString()');
    } finally {
      fecha();
    }
  }
}
