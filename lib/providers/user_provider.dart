import 'package:stocker/models/account.dart';
import 'package:stocker/models/user.dart';
import 'package:stocker/services/firebase/database/user_database_service.dart';
import 'package:stocker/services/service_handler.dart';

class UserProvider {
  static Future<User> getUser(String uid) async {
    return UserDatabaseService(uid: uid).userData;
  }

  static Future<Account> getAccount() async {
    return Account.fromMap(await ServiceHandler.getAlpaca().getAlpacaAccount());
  }
}
