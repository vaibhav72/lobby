part of 'posts_cubit.dart';

class PostsState extends Equatable {
  final List<PostModel> data;
  const PostsState({this.data});

  @override
  List<Object> get props => [data];

  PostsLoaded copyWith({List<PostModel> newData}) {
    return PostsLoaded(data: newData ?? this.data);
  }
}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  PostsLoaded({List<PostModel> data}) : super(data: data);
}
