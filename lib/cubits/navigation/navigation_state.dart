part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final int? index;
  const NavigationState({this.index = 0});

  NavigationState copyWith({int? index}) {
    return NavigationState(index: index);
  }

  @override
  List<Object> get props => [index!];
}

class NavigationInitial extends NavigationState {
  NavigationInitial({int? index}) : super(index: index);
}
