part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  final PostModel post;
  const CreatePostState({this.post});

  @override
  List<Object> get props => [post];
}

class CreatePostLoading extends CreatePostState {}

class CreatePostLoaded extends CreatePostState {}

class CreatePostComplete extends CreatePostState {}

class CreatePostError extends CreatePostState {
  String message;
  CreatePostError({this.message});
}
