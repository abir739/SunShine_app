import 'package:flutter/material.dart';
import 'package:zenify_app/modele/traveller/TravellerModel.dart';
import 'package:flutter_svg/svg.dart';

class TravelerProfileScreen extends StatelessWidget {
  final Traveller traveler;

  const TravelerProfileScreen({super.key, required this.traveler});

  @override
  Widget build(BuildContext context) {
    double widthC = MediaQuery.of(context).size.width * 100;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 253, 254),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 207, 219),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/Frame.svg',
              fit: BoxFit.cover,
              height: 36.0,
            ),
            const SizedBox(width: 40),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFF3A3557),
                    Color(0xFFCBA36E),
                    Color(0xFFEB5F52),
                  ],
                ).createShader(bounds);
              },
              child: const Text(
                'Traveller Profil',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors
                      .white, // You can adjust the font size and color here
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildMainInfo(context, widthC),
            const SizedBox(height: 10.0),
            _buildInfo(context, widthC),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://img.freepik.com/free-vector/travel-time-typography-design_1308-90406.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.black38,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 140),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                color: Colors.grey.shade500,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white,
                      width: 6.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        traveler.user!.picture ??
                            'https://img.freepik.com/free-vector/travel-time-typography-design_1308-99359.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais',
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  // Continue with _buildMainInfo and _buildInfo methods...
  Widget _buildMainInfo(BuildContext context, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(10),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: <Widget>[
          Text(
            '${traveler.user!.firstName} ${traveler.user!.lastName}',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 94, 36, 228),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            traveler.user!.username ??
                'Unknown Username', // Fallback value if null
            style: TextStyle(
              color: Color.fromARGB(255, 10, 10, 10),
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context, double width) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Colors.black,
              width: 1.0), // Set the border color and width
          borderRadius:
              BorderRadius.circular(10.0), // Set border radius as needed
        ),
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.email,
                  color: Color(0xFFEB5F52),
                ),
                title: const Text("E-Mail"),
                subtitle: Text(traveler.user!.email ?? 'N/A'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.phone,
                  color: Color(0xFFEB5F52),
                ),
                title: const Text("Phone Number"),
                subtitle: Text(traveler.user!.phone ?? 'N/A'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.cake,
                  color: Color(0xFFEB5F52),
                ),
                title: const Text("Birth Date"),
                subtitle: Text(
                  traveler.user!.birthDate?.toString() ?? 'N/A',
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: const Icon(
                  Icons.my_location,
                  color: Color(0xFFEB5F52),
                ),
                title: const Text("Location"),
                subtitle: Text(traveler.user!.address ?? 'N/A'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
