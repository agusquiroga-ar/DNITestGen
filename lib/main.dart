import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'services/data_generator_service.dart';
import 'models/identity.dart';
import 'generators/old_dni_generator.dart';
import 'generators/new_dni_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataService = DataGeneratorService();
  await dataService.loadDictionaries();

  runApp(DniGeneratorApp(dataService: dataService));
}

enum DniType { oldVersion, newVersion, random }

class AppState extends ChangeNotifier {
  final DataGeneratorService _dataService;
  
  int _minDni = 10000000;
  int _maxDni = 50000000;
  DniType _selectedType = DniType.random;
  String? _errorMessage;

  Identity? _currentIdentity;
  Widget? _currentGeneratedWidget;
  DniType? _lastGeneratedType;

  AppState(this._dataService);

  int get minDni => _minDni;
  int get maxDni => _maxDni;
  DniType get selectedType => _selectedType;
  String? get errorMessage => _errorMessage;
  
  Identity? get currentIdentity => _currentIdentity;
  Widget? get currentGeneratedWidget => _currentGeneratedWidget;
  DniType? get lastGeneratedType => _lastGeneratedType;

  void setMinDni(int value) {
    _minDni = value;
    _validateRange();
    notifyListeners();
  }

  void setMaxDni(int value) {
    _maxDni = value;
    _validateRange();
    notifyListeners();
  }

  void setSelectedType(DniType type) {
    _selectedType = type;
    notifyListeners();
  }

  void _validateRange() {
    if (_minDni > _maxDni) {
      _errorMessage = 'El DNI Mínimo no puede ser mayor al Máximo.';
    } else {
      _errorMessage = null;
    }
  }

  void generate() {
    if (_errorMessage != null) return;

    try {
      _currentIdentity = _dataService.generateIdentity(minDni: _minDni, maxDni: _maxDni);

      var typeToGenerate = _selectedType;
      if (typeToGenerate == DniType.random) {
        typeToGenerate = Random().nextBool() ? DniType.oldVersion : DniType.newVersion;
      }

      if (typeToGenerate == DniType.oldVersion) {
        final data = OldDniGenerator.generateString(_currentIdentity!);
        _currentGeneratedWidget = OldDniGenerator.buildBarcodeWidget(data);
      } else {
        final data = NewDniGenerator.generateUrl(_currentIdentity!);
        _currentGeneratedWidget = NewDniGenerator.buildQrWidget(data);
      }
      
      _lastGeneratedType = typeToGenerate;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error al generar identidad: $e";
      notifyListeners();
    }
  }
}

class DniGeneratorApp extends StatelessWidget {
  final DataGeneratorService dataService;
  
  const DniGeneratorApp({super.key, required this.dataService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState(dataService)),
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
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generador de DNI'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tipo de DNI
            DropdownButtonFormField<DniType>(
              value: state.selectedType,
              decoration: const InputDecoration(labelText: 'Tipo de Documento'),
              items: const [
                DropdownMenuItem(value: DniType.oldVersion, child: Text('Versión Vieja (PDF417)')),
                DropdownMenuItem(value: DniType.newVersion, child: Text('Versión Nueva (QR)')),
                DropdownMenuItem(value: DniType.random, child: Text('Aleatorio')),
              ],
              onChanged: (DniType? newValue) {
                if (newValue != null) {
                  context.read<AppState>().setSelectedType(newValue);
                }
              },
            ),
            const SizedBox(height: 16),
            // Rango de DNI
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: state.minDni.toString(),
                    decoration: const InputDecoration(labelText: 'DNI Mínimo'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      final parsed = int.tryParse(value) ?? 0;
                      context.read<AppState>().setMinDni(parsed);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: state.maxDni.toString(),
                    decoration: const InputDecoration(labelText: 'DNI Máximo'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      final parsed = int.tryParse(value) ?? 0;
                      context.read<AppState>().setMaxDni(parsed);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Mensaje de Error
            if (state.errorMessage != null)
              Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 24),
            // Boton de generar
            ElevatedButton(
              onPressed: state.errorMessage == null
                  ? () {
                      context.read<AppState>().generate();
                    }
                  : null,
              child: const Text('Generar'),
            ),
            const SizedBox(height: 24),
            // Área visual
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: state.currentGeneratedWidget == null
                    ? const Center(
                        child: Text(
                          'Aquí se mostrará el código generado',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.lastGeneratedType == DniType.oldVersion
                                  ? 'Formato: DNI Viejo (PDF417)'
                                  : 'Formato: Nuevo eDNI (QR)',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            state.currentGeneratedWidget!,
                            const SizedBox(height: 24),
                            if (state.currentIdentity != null) ...[
                              Text('DNI: ${state.currentIdentity!.dni}'),
                              Text('Trámite: ${state.currentIdentity!.tramiteId}'),
                              Text('Nombre: ${state.currentIdentity!.apellido}, ${state.currentIdentity!.nombre}'),
                              Text('Sexo: ${state.currentIdentity!.sexo} | Ejemplar: ${state.currentIdentity!.ejemplar}'),
                            ]
                          ],
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
