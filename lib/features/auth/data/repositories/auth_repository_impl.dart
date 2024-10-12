import 'package:dartz/dartz.dart';
import 'package:gss_manager_app/config/api.dart';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';
import 'package:gss_manager_app/core/error/failures.dart';
import 'package:gss_manager_app/core/models/user_model.dart';
import 'package:gss_manager_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, UserModel>> login(
      String email, String password) async {
    final url = Uri.parse(GisaApiConfig.login);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final user = UserModel.fromJson(jsonResponse['data']);

        await _savePrefs(user);

        return Right(user);
      } else {
        final jsonResponse = json.decode(response.body);
        return Left(
            ServerFailure(message: jsonResponse['message'] ?? 'Gagal Login'));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<void> _savePrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPrefsKeys.token, user.token!.toString());
    prefs.setInt(SharedPrefsKeys.userId, user.id);
    prefs.setString(SharedPrefsKeys.userName, user.name);
    prefs.setString(SharedPrefsKeys.userEmail, user.email);
    prefs.setString(SharedPrefsKeys.userRole, user.role);
    prefs.setString(
        SharedPrefsKeys.userBranches,
        json.encode(
            user.branches?.map((branch) => branch.toJson()).toList() ?? []));

    print("OKOK data user: ${user.toJson()}");
    print("OKOK Branches on user: ${user.branches}");

    print(
        "OKOK Branches on shared prefs: ${prefs.getString(SharedPrefsKeys.userBranches)}");
  }

  @override
  Future<void> logout() {
    // TODO: implement signOut
    //back to login screen
    throw UnimplementedError();
  }
}
