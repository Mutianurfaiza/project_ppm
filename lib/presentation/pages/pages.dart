import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kulbal/app/common/app_styles.dart';
import 'package:kulbal/app/routes/app_pages.dart';
import 'package:kulbal/domain/model/cart_item_model.dart';
import 'package:kulbal/presentation/components/card_item.dart';
import 'package:kulbal/presentation/controllers/auth/auth_controller.dart';
import 'package:kulbal/presentation/controllers/cart/cart_controller.dart';
import 'package:kulbal/presentation/controllers/home/home_controller.dart';

import '../../app/core/app_preferences.dart';

part './home/home_view.dart';
part './auth/register_view.dart';
part './home/detail_menu.dart';
part './splashscreen/splash_screen.dart';
part './auth/login_view.dart';

part 'cart/order/order_screen.dart';
part 'cart/order/order_item.dart';
part 'cart/order/total_amount.dart';
part 'cart/payment/payment_confirm.dart';
part 'cart/payment/payment_success.dart';
