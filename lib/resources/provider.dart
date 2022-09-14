import 'package:flutter/widgets.dart';
import 'package:free_blog/resources/authMethod.dart';

import '../models/userModel.dart';


class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethod _authMethods = AuthMethod();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}