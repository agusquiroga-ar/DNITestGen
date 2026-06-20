import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const DniGeneratorApp());
}

class AppState extends ChangeNotifier {
  // Estado base preparado para futuras características
  void generate() {
    // Placeholder para la lógica de generación
    notifyListeners();
  }
}

class DniGeneratorApp extends StatelessWidget {
  const DniGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'Generador de DNI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generador de DNI'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<AppState>().generate();
              },
              child: const Text('Generar'),
            ),
            const SizedBox(height: 24),
            // Placeholder visual
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Aquí se mostrará el código generado',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
