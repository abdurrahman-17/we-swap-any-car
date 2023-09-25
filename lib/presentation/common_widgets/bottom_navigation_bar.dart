import '../../core/configurations.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });
  final int selectedIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        selectedItemColor: ColorConstant.kPrimaryDarkRed,
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        items: [
          buildBottomNavigationBarItem(
            icon: const Icon(
              Icons.person_2_outlined,
            ),
            label: 'My Car',
          ),
          buildBottomNavigationBarItem(
            icon: const CustomImageView(
              svgPath: Assets.comment,
            ),
            label: 'Chat',
          ),
          buildBottomNavigationBarItem(
            icon: const Icon(
              Icons.view_carousel_outlined,
            ),
            label: 'Home',
          ),
          buildBottomNavigationBarItem(
            icon: const CustomImageView(
              svgPath: Assets.thumbsUp,
            ),
            label: 'Like',
          ),
          buildBottomNavigationBarItem(
            icon: const Icon(
              Icons.manage_search_outlined,
            ),
            label: 'Filter',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onTap);
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      {required Widget icon, required String label}) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
    );
  }
}
