import 'package:http/http.dart';

class Network{
  static String errorMessage = 'Failed To Call Api';

  static getRequest(String endpoint)async{
    try{
      Response response = await get(Uri.parse(endpoint));

      print('StatusCode: ${response.statusCode}');
      print('StatusBody: ${response.body}');

      return response;
    }catch(e){
      throw errorMessage;
    }
  }
}