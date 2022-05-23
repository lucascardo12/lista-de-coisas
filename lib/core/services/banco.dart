import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listadecoisa/core/interfaces/service_interface.dart';
import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/home/domain/models/compartilha.dart';
import 'package:listadecoisa/modules/auth/domain/models/user.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:translator/translator.dart';
import 'package:firebase_core/firebase_core.dart';

class BancoFire extends IService {
  final translator = GoogleTranslator();
  late FirebaseFirestore db;
  late FirebaseAuth firebaseAuth;
  final Global gb;

  BancoFire(this.gb);

  @override
  Future<void> start() async {
    await Firebase.initializeApp();
    db = FirebaseFirestore.instance;
    firebaseAuth = FirebaseAuth.instance;
  }

  criaAlteraCoisas({required Coisas coisas, required UserP user}) {
    coisas.idFire ??= db.collection('user').doc(user.id).collection('coisas').doc().id;
    db.collection('user').doc(user.id).collection('coisas').doc(coisas.idFire).set(coisas.toJson());
  }

  Future<void> criaAlteraComp({required UserP user, required Compartilha coisas}) async {
    coisas.idFire ??= db.collection('user').doc(user.id).collection('compartilha').doc().id;
    db.collection('user').doc(user.id).collection('compartilha').doc(coisas.idFire).set(coisas.toJson());
  }

  Future<List> getCoisas({required UserP user}) async {
    try {
      var result = await db.collection('user').doc(user.id).collection('coisas').get();
      return result.docs;
    } catch (e) {
      dynamic error = e;
      var auxi = await translator.translate(error.message ?? '', from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return [];
    }
  }

  Future<List> getComps({required UserP user}) async {
    try {
      var result = await db.collection('user').doc(user.id).collection('compartilha').get();
      return result.docs;
    } catch (e) {
      dynamic error = e;
      var auxi = await translator.translate(error.message ?? '', from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return [];
    }
  }

  removeCoisas({required Coisas cat, required UserP user}) async {
    db.collection('user').doc(user.id).collection('coisas').doc(cat.idFire).delete();
  }

  Future<DocumentSnapshot> getComp({required String idUser, required String idLista}) async {
    DocumentSnapshot result =
        await db.collection('user').doc(idUser).collection('compartilha').doc(idLista).get();

    return result;
  }

  Future<DocumentSnapshot> getCoisa({required String idUser, required String idLista}) async {
    DocumentSnapshot result = await db.collection('user').doc(idUser).collection('coisas').doc(idLista).get();

    return result;
  }

  Future<DocumentSnapshot> getUser({required String idUser}) async {
    DocumentSnapshot result = await db.collection('user').doc(idUser).get();

    return result;
  }

  Future<String> criaUser(UserP user) async {
    try {
      var userFire = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.login ?? '', password: user.senha ?? '');

      user.id = userFire.user!.uid;
      db.collection('user').doc(userFire.user!.uid).set(user.toJson());
      return userFire.user!.uid;
    } catch (e) {
      dynamic error = e;
      var auxi = await translator.translate(error.message ?? '', from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return '';
    }
  }

  Future<UserP?> login({required String email, required String password}) async {
    try {
      var user = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      DocumentSnapshot result = await db.collection('user').doc(user.user!.uid).get();

      UserP auxi = UserP(
        login: result.get('login'),
        id: result.get('id'),
        nome: result.get('nome'),
        //senha: result.data()['senha'],
      );

      return auxi;
    } catch (e) {
      dynamic error = e;
      var auxi = await translator.translate(error.message, from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return null;
    }
  }

  Future<UserP?> criaUserAnonimo() async {
    try {
      UserP user = UserP();
      var axui = gb.box.get(
        'userAnonimo',
        defaultValue: '',
      );
      if (axui.isNotEmpty) {
        DocumentSnapshot result = await db.collection('user').doc(gb.box.get('userAnonimo')).get();

        user.id = result.get('id');
      } else {
        var value = await firebaseAuth.signInAnonymously();
        user.id = value.user!.uid;
        db.collection('user').doc(user.id).set(user.toJson());
        gb.box.put('userAnonimo', user.id ?? '');
      }

      return user;
    } catch (e) {
      e as FirebaseAuthException;
      var auxi = await translator.translate(e.message ?? '', from: 'en', to: 'pt');
      Fluttertoast.showToast(
          msg: auxi.text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0);
      return null;
    }
  }

  void resetarSenha({required UserP user}) {
    firebaseAuth.sendPasswordResetEmail(email: user.login ?? '');
  }

  Future<UserP?> criaUserGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var value = await FirebaseAuth.instance.signInWithCredential(credential);
      DocumentSnapshot result = await db.collection('user').doc(value.user!.uid).get();
      if (result.exists) {
        return UserP.fromJson(result.data());
      }
      UserP userTemp = UserP(
        id: result.id,
        login: value.user!.email,
        nome: value.user!.displayName,
        senha: '',
      );
      db.collection('user').doc(userTemp.id).set(userTemp.toJson());

      return userTemp;
    } catch (e) {
      dynamic error = e;
      var auxi = await translator.translate(
        error.message ?? '',
        from: 'en',
        to: 'pt',
      );
      Fluttertoast.showToast(
        msg: auxi.text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0,
      );
      return null;
    }
  }
}
