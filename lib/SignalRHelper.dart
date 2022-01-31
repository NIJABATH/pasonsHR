
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import 'Models/Message.dart';

class SignalRHelper {
  // final url = 'http://10.1.1.123:81/chatHub';
  final url = 'http://10.1.1.220:5001/chatHub';
  late HubConnection hubConnection;
  var messageList = <Message>[];
  String textMessage='';

  void connect(receiveMessageHandler) {
    hubConnection = HubConnectionBuilder().withUrl(url).build();
    // hubConnection.onclose((error) {
    //   log('Connection Close');
    // });
    hubConnection.on('ReceiveMessage', receiveMessageHandler);
    hubConnection.start();
  }

  void sendMessage(String name, String message, String myGroupName, String messageId,bool messageStatus) {
    hubConnection.invoke('SendMessage', args: [name, message,myGroupName,messageId,messageStatus]);
    // messageList.add(Message(
    //     name: name,
    //     message: message,
    //     isMine: true));
    textMessage='';
  }

  void disconnect() {
    hubConnection.stop();
  }


}
