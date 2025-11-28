import 'package:chat_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:chat_app/features/auth/domain/usecase/google_sign_in_usecase.dart';
import 'package:chat_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:chat_app/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/features/home/data/datasource/chat_remote_datasource.dart';
import 'package:chat_app/features/home/data/datasource/chat_stream_service.dart';
import 'package:chat_app/features/home/data/repository/chat_repository_impl.dart';
import 'package:chat_app/features/home/data/service/chat_service.dart';
import 'package:chat_app/features/home/domain/repository/chat_repository.dart';
import 'package:chat_app/features/home/domain/usecase/get_chats_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/get_messages_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/get_user_online_status_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/get_user_typing_status_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/send_message_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/set_typing_status_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/set_user_online_status_usecase.dart';
import 'package:chat_app/features/home/domain/usecase/upload_image_usecase.dart';
import 'package:chat_app/features/home/presentation/bloc/chat_bloc.dart';
import 'package:chat_app/features/home/presentation/screen/chat_detailed_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  // ========== Auth Feature ==========
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDatasource: sl()),
  );
  sl.registerLazySingleton(
    () => LoginUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => SignInUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => GoogleSignInUsecase(authRepository: sl<AuthRepository>()),
  );

  sl.registerFactory(
    () => AuthBloc(
      userLogin: sl(),
      userSignIn: sl(),
      googleSignIn: sl(),
    ),
  );

  // ========== Home Feature ==========
  sl.registerLazySingleton<ChatRemoteDatasource>(
    () => ChatRemoteDatasourceImpl(
      firestore: sl(),
      firebaseAuth: sl(),
    ),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(chatRemoteDatasource: sl()),
  );

  sl.registerLazySingleton(
    () => ChatStreamService(chatRepository: sl<ChatRepository>()),
  );

  sl.registerLazySingleton(
    () => ChatService(
      sendMessageUseCase: sl<SendMessageUseCase>(),
      uploadImageUseCase: sl<UploadImageUseCase>(),
      setTypingStatusUseCase: sl<SetTypingStatusUseCase>(),
    ),
  );

  sl.registerLazySingleton(
    () => GetChatsUseCase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton(
    () => GetMessagesUseCase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton(
    () => SendMessageUseCase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton(
    () => UploadImageUseCase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton(
    () => GetUserOnlineStatusUseCase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton(
    () => GetUserTypingStatusUseCase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton(
    () => SetUserOnlineStatusUseCase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton(
    () => SetTypingStatusUseCase(chatRepository: sl<ChatRepository>()),
  );

  sl.registerFactory(
    () => ChatBloc(
      getChatsUseCase: sl(),
      getMessagesUseCase: sl(),
      sendMessageUseCase: sl(),
      uploadImageUseCase: sl(),
    ),
  );
}

ChatDetailedPage getChatDetailedPage({
  required String userChatName,
  required String userUid,
}) {
  return ChatDetailedPage(
    userChatName: userChatName,
    userUid: userUid,
    chatStreamService: sl<ChatStreamService>(),
    chatService: sl<ChatService>(),
    firebaseAuth: sl<FirebaseAuth>(),
  );
}
