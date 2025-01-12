import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// Provider to manage current location
final currentLocationProvider = FutureProvider<LatLng>((ref) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return LatLng(position.latitude, position.longitude);
});

// Provider to manage markers
final markersProvider = StateProvider<List<Marker>>((ref) => []);

// Provider to manage map controller
final mapControllerProvider = Provider<MapController>((ref) {
  return MapController();
});

// Provider to manage the mode of the map
final mapModeProvider =
    StateProvider<bool>((ref) => false); // false = View Mode, true = Add Mode

class CustomMapPage extends ConsumerWidget {
  const CustomMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocationAsync = ref.watch(currentLocationProvider);
    final mapController = ref.watch(mapControllerProvider);
    final markers = ref.watch(markersProvider);
    final isAddMode = ref.watch(mapModeProvider);

    return Scaffold(
      backgroundColor: isAddMode ? Colors.grey[900] : Colors.white,
      body: Stack(
        children: [
          currentLocationAsync.when(
            data: (currentLocation) => FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 10.0,
                onTap: isAddMode
                    ? (tapPosition, point) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              _addEventDialog(context, ref, point),
                        );
                      }
                    : null, // Disable onTap in View Mode
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.drag |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (!isAddMode) // Only show markers in View Mode
                  MarkerLayer(
                    markers: markers,
                  ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 196, 226, 250)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.blue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Menu functionality not implemented yet.')),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 80,
            right: 20,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search location or event',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 196, 226, 250)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 196, 226, 250)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              onSubmitted: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Search functionality for "$value" not implemented yet.')),
                );
              },
            ),
          ),
          Positioned(
            bottom: 160,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                ref.read(mapModeProvider.notifier).state = !isAddMode;
                FloatingActionButton(
                  onPressed: () {
                    ref.read(mapModeProvider.notifier).state = !isAddMode;
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(
                      msg: isAddMode
                          ? 'Switched to View Mode'
                          : 'Switched to Add Mode',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  backgroundColor: Colors.blue,
                  child: Icon(
                    isAddMode ? Icons.visibility : Icons.add_location_alt,
                    color: Colors.white,
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: Icon(
                isAddMode ? Icons.visibility : Icons.add_location_alt,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                final currentLocation =
                    await ref.read(currentLocationProvider.future);
                mapController.move(currentLocation, 10.0);
              },
              backgroundColor: Colors.blue,
              child: const Icon(CupertinoIcons.location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addEventDialog(
      BuildContext context, WidgetRef ref, LatLng selectedLocation) {
    final eventNameController = TextEditingController();

    return AlertDialog(
      title: const Text('Add New Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: eventNameController,
            decoration: const InputDecoration(
              labelText: 'Event Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Location: ${selectedLocation.latitude.toStringAsFixed(4)}, ${selectedLocation.longitude.toStringAsFixed(4)}',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (eventNameController.text.isNotEmpty) {
              // Save the marker
              final marker = Marker(
                point: selectedLocation,
                width: 50,
                height: 50,
                child: Icon(Icons.location_on, color: Colors.red),
              );

              ref
                  .read(markersProvider.notifier)
                  .update((state) => [...state, marker]);

              // Auto-switch to View Mode
              ref.read(mapModeProvider.notifier).state = false;

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Event added and switched to View Mode!')),
              );
            }
          },
          child: const Text('Save Event'),
        ),
      ],
    );
  }
}
