part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  const CreatePostState();
  @override
  List<Object> get props => [];
}

class CreatePostLoading extends CreatePostState {}

class CreatePostLoaded extends CreatePostState {
  final PostModel post;
  const CreatePostLoaded({required this.post});
  @override
  List<Object> get props => [post];
}

class CreatePostMediaUploading extends CreatePostState {
  final double data;
  const CreatePostMediaUploading({required this.data});
  @override
  List<Object> get props => [data];
}

class CreatePostComplete extends CreatePostState {
  final PostModel post;
  const CreatePostComplete({required this.post});
  @override
  List<Object> get props => [post];
}

class CreatePostError extends CreatePostState {
  String? message;
  CreatePostError({this.message});
}
