import 'package:flutter/material.dart';

class ScrollableSheetPage extends StatefulWidget {
  const ScrollableSheetPage({Key? key}) : super(key: key);

  @override
  State<ScrollableSheetPage> createState() => _ScrollableSheetPageState();
}

class _ScrollableSheetPageState extends State<ScrollableSheetPage> {
  final controller = DraggableScrollableController();

  Duration kDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opps'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.lightGreen.shade200,
          ),
          _scrollableSheet(),
        ],
      ),
    );
  }

  Widget _scrollableSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      snapAnimationDuration: kDuration,
      controller: controller,
      snapSizes: const [0.5, 1],
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return AnimatedContainer(
          duration: kDuration,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: controller.isExpandedToSize(1) ? Radius.zero : const Radius.circular(24),
              topRight: controller.isExpandedToSize(1) ? Radius.zero : const Radius.circular(24),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) => Card(
                    elevation: 0,
                    color: Colors.grey.shade200,
                    surfaceTintColor: Colors.transparent,
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: controller.isExpandedToSize(1) ? -72 : 0,
                height: 72,
                duration: kDuration,
                child: Container(
                  color: Colors.white,
                  height: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => const CircleAvatar(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension DraggableScrollableControllerExt on DraggableScrollableController {
  bool isExpandedToSize(double size) => isAttached && size == this.size;
}
