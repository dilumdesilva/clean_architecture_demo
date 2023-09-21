import 'package:clean_architecture_demo/app/di.dart';
import 'package:clean_architecture_demo/domain/model/todo_model.dart';
import 'package:clean_architecture_demo/domain/repository/todo_repository.dart';
import 'package:clean_architecture_demo/presentation/resources/assets_manager.dart';
import 'package:clean_architecture_demo/presentation/resources/todo_cards/todo_cards_state.dart';
import 'package:clean_architecture_demo/presentation/resources/todo_cards/todo_crads_cubit.dart';
import 'package:clean_architecture_demo/presentation/resources/values_manager.dart';
import 'package:clean_architecture_demo/presentation/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoCardsSecreen extends StatefulWidget {
  const TodoCardsSecreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodoCardsSecreenState();
}

class _TodoCardsSecreenState extends State<TodoCardsSecreen> {
  late TodoCardsCubit _todoCardsCubit;

  @override
  void initState() {
    super.initState();
    initialise();
  }

  Future<void> initialise() async {
    if (mounted) {
      _todoCardsCubit =
          TodoCardsCubit(todoRepository: getItInstance.get<TodoRepository>());

      _todoCardsCubit.getTodoCards();
    }
  }

  @override
  void didChangeDependencies() {
    //TODO: Initialize the localisation here
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //TODO: add from localisation
          title: const Text('My TODOs'),
          actions: [
            _buildCalendarAppBarButton(),
          ],
        ),
        body: BlocProvider(
            create: (context) => _todoCardsCubit,
            child: BlocBuilder<TodoCardsCubit, TodoCardsState>(
                builder: (context, state) {
              switch (state.runtimeType) {
                case GetTodoCardsInProgress:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case GetTodoCardsSuccess:
                  final todoCards = (state as GetTodoCardsSuccess).todoCards;
                  return _buildBody(todoCards ?? []);
                case GetTodoCardsFailure:
                  return const Center(
                    child: Column(
                      children: [
                        Icon(Icons.error, size: 50, color: Colors.red),
                        //TODO: add from localisation
                        Text('Failed to fetch todo cards'),
                      ],
                    ),
                  );
              }

              return Container();
            })),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //TODO: build the navigation to next screen
            },
            child: const Icon(Icons.add)));
  }

  Widget _buildCalendarAppBarButton() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p20),
      child: InkWell(
        onTap: () => {
          //TODO: navigate to calendar screen
          print('Calendar button tapped'),
        },
        child: const Icon(
          Icons.calendar_month,
        ),
      ),
    );
  }

  Widget _buildBody(List<TodoModel> todoCards) {
    return LayoutBuilder(builder: (context, dimens) {
      return ListView.builder(
        itemCount: todoCards.length,
        itemBuilder: (context, index) {
          return _buildCard(todoCards[index]);
        },
      );
    });
  }

  Widget _buildCard(TodoModel todoCard) {
    double todoCardTextAreaWidth = getScreenWidth(context) * 0.7;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
      child: Dismissible(
        key: const Key('card'),
        //direction: DismissDirection.endToStart,
        secondaryBackground: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child:
                          Text('Delete', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            )),
        background: Container(
            color: Colors.green,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageIcon(
                      AssetImage(AssetsManager.icons.pinIcon),
                      color: Colors.white,
                      //TODO: change the colour based on pinned or not
                      size: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text('Pin to top',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            )), //TODO: replace with snapshot id
        child: Card(
            elevation: 2,
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 20.0, right: 20.0),
                  child: SizedBox(
                    height: 100,
                    width: todoCardTextAreaWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todoCard.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(todoCard.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 24),

                        //TODO: get like todoCard.createdDate using timestamp
                        Text(getTodoCardDisplayDate(DateTime.now()),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8, top: 8),
                  child: InkWell(
                    onLongPress: () => {
                      //TODO: show toast
                      //Pin the card to top
                    },
                    child: ImageIcon(
                      AssetImage(AssetsManager.icons.pinIcon),
                      color: Colors
                          .red, //TODO: change the colour based on pinned or not
                      size: 20,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
