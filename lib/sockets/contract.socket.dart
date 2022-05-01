import './init.socket.dart';
import './sockets.dart';

class ContractSocketIO {
  static final socket = InitSocketIO.socket;

  static newContract(data) async {
    socket.emit(
      SocketUtils.newContract,
      data,
    );
  }

  static newContractRequest(Function contractRequestRecieved) {
    socket.on(SocketUtils.newContractRequest, (contractData) {
      contractRequestRecieved(contractData);
    });
  }

  ///Singleton factory
  static final ContractSocketIO _instance = ContractSocketIO._internal();

  factory ContractSocketIO() {
    return _instance;
  }

  ContractSocketIO._internal();
}
