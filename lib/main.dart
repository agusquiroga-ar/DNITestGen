import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'services/data_generator_service.dart';
import 'models/identity.dart';
import 'models/dni_type.dart';
import 'models/generated_code_record.dart';
import 'generators/old_dni_generator.dart';
import 'generators/new_dni_generator.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataService = DataGeneratorService();
  await dataService.loadDictionaries();

  runApp(DniGeneratorApp(dataService: dataService));
}

class AppState extends ChangeNotifier {
  final DataGeneratorService _dataService;

  int _minDni = 10000000;
  int _maxDni = 50000000;
  DniType _selectedType = DniType.random;
  String? _errorMessage;

  Identity? _currentIdentity;
  Widget? _currentGeneratedWidget;
  DniType? _lastGeneratedType;

  final List<GeneratedCodeRecord> _history = [];
  List<GeneratedCodeRecord> get history => _history;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }

  List<GeneratedCodeRecord> get filteredHistory {
    if (_searchQuery.trim().isEmpty) {
      return _history;
    }
    return _history.where((record) => record.matchesSearch(_searchQuery)).toList();
  }

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
      _currentIdentity = _dataService.generateIdentity(
        minDni: _minDni,
        maxDni: _maxDni,
      );

      var typeToGenerate = _selectedType;
      if (typeToGenerate == DniType.random) {
        typeToGenerate = Random().nextBool()
            ? DniType.oldVersion
            : DniType.newVersion;
      }

      if (typeToGenerate == DniType.oldVersion) {
        final data = OldDniGenerator.generateString(_currentIdentity!);
        _currentGeneratedWidget = OldDniGenerator.buildBarcodeWidget(data);
      } else {
        final data = NewDniGenerator.generateString(_currentIdentity!);
        _currentGeneratedWidget = NewDniGenerator.buildQrWidget(data);
      }

      _lastGeneratedType = typeToGenerate;

      final record = GeneratedCodeRecord(
        identity: _currentIdentity!,
        type: typeToGenerate,
        generatedAt: DateTime.now(),
      );
      _history.add(record);

      notifyListeners();
    } catch (e) {
      _errorMessage = "Error al generar identidad: $e";
      notifyListeners();
    }
  }

  void loadRecordFromHistory(GeneratedCodeRecord record) {
    _currentIdentity = record.identity;
    _lastGeneratedType = record.type;

    if (record.type == DniType.oldVersion) {
      final data = OldDniGenerator.generateString(record.identity);
      _currentGeneratedWidget = OldDniGenerator.buildBarcodeWidget(data);
    } else {
      final data = NewDniGenerator.generateString(record.identity);
      _currentGeneratedWidget = NewDniGenerator.buildQrWidget(data);
    }

    notifyListeners();
  }

  Future<void> saveSession() async {
    try {
      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Guardar sesión de códigos generados',
        fileName: 'dni_session.json',
        allowedExtensions: ['json'],
        type: FileType.custom,
      );

      if (outputFile == null) {
        return; // User canceled
      }

      final jsonList = _history.map((e) => e.toJson()).toList();
      final jsonString = json.encode(jsonList);

      final file = File(outputFile);
      await file.writeAsString(jsonString);
    } catch (e) {
      _errorMessage = "Error al guardar sesión: $e";
      notifyListeners();
    }
  }

  void importRecords(List<GeneratedCodeRecord> records, {bool replace = false}) {
    if (replace) {
      _history.clear();
    }
    _history.addAll(records);
    notifyListeners();
  }

  Future<List<GeneratedCodeRecord>?> pickAndParseSessionFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        dialogTitle: 'Cargar sesión de códigos generados',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);

        return jsonList
            .map((e) => GeneratedCodeRecord.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return null;
    } catch (e) {
      _errorMessage = "Error al cargar sesión: $e";
      notifyListeners();
      return null;
    }
  }

  Future<void> loadSession({bool replace = false}) async {
    final loadedHistory = await pickAndParseSessionFile();
    if (loadedHistory != null && loadedHistory.isNotEmpty) {
      importRecords(loadedHistory, replace: replace);
    }
  }
}

class DniGeneratorApp extends StatelessWidget {
  final DataGeneratorService dataService;

  const DniGeneratorApp({super.key, required this.dataService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppState(dataService))],
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
      body: Row(
        children: [
          const HistorySidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Tipo de DNI
                  DropdownButtonFormField<DniType>(
                    initialValue: state.selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Documento',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: DniType.oldVersion,
                        child: Text('Versión Vieja (PDF417)'),
                      ),
                      DropdownMenuItem(
                        value: DniType.newVersion,
                        child: Text('Versión Nueva (QR)'),
                      ),
                      DropdownMenuItem(
                        value: DniType.random,
                        child: Text('Aleatorio'),
                      ),
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
                          initialValue: state.minDni
                              .toString()
                              .replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]}.',
                              ),
                          decoration: const InputDecoration(
                            labelText: 'DNI Mínimo',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            ThousandsSeparatorInputFormatter(),
                          ],
                          onChanged: (value) {
                            final parsed =
                                int.tryParse(value.replaceAll('.', '')) ?? 0;
                            context.read<AppState>().setMinDni(parsed);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: state.maxDni
                              .toString()
                              .replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]}.',
                              ),
                          decoration: const InputDecoration(
                            labelText: 'DNI Máximo',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            ThousandsSeparatorInputFormatter(),
                          ],
                          onChanged: (value) {
                            final parsed =
                                int.tryParse(value.replaceAll('.', '')) ?? 0;
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
                                    state.lastGeneratedType ==
                                            DniType.oldVersion
                                        ? 'Formato: DNI Viejo (PDF417)'
                                        : 'Formato: Nuevo eDNI (QR)',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  state.currentGeneratedWidget!,
                                  const SizedBox(height: 24),
                                  if (state.currentIdentity != null) ...[
                                    Text('DNI: ${state.currentIdentity!.dni}'),
                                    Text(
                                      'Trámite: ${state.currentIdentity!.tramiteId}',
                                    ),
                                    Text(
                                      'Nombre: ${state.currentIdentity!.apellido}, ${state.currentIdentity!.nombre}',
                                    ),
                                    Text(
                                      'Sexo: ${state.currentIdentity!.sexo} | Ejemplar: ${state.currentIdentity!.ejemplar}',
                                    ),
                                  ],
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;

    String newValueText = newValue.text.replaceAll('.', '');
    if (int.tryParse(newValueText) == null && newValueText.isNotEmpty) {
      return oldValue;
    }

    String formattedText = newValueText.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    int newSelectionOffset = formattedText.length - selectionIndexFromTheRight;
    if (newSelectionOffset < 0) {
      newSelectionOffset = 0;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newSelectionOffset),
    );
  }
}

class HistorySidebar extends StatefulWidget {
  const HistorySidebar({super.key});

  @override
  State<HistorySidebar> createState() => _HistorySidebarState();
}

class _HistorySidebarState extends State<HistorySidebar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleLoadSession(BuildContext context) async {
    final appState = context.read<AppState>();
    final loadedRecords = await appState.pickAndParseSessionFile();
    if (loadedRecords == null || loadedRecords.isEmpty) {
      return;
    }

    if (!context.mounted) return;

    if (appState.history.isEmpty) {
      appState.importRecords(loadedRecords, replace: false);
      return;
    }

    final choice = await showDialog<_LoadSessionAction>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cargar Sesión'),
        content: Text(
          'El historial actual contiene ${appState.history.length} registro(s).\n\n'
          '¿Deseas reemplazar el historial existente o agregar los ${loadedRecords.length} nuevos registro(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(_LoadSessionAction.cancel),
            child: const Text('Cancelar'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(_LoadSessionAction.replace),
            child: const Text('Reemplazar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(_LoadSessionAction.append),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (choice == _LoadSessionAction.replace) {
      appState.importRecords(loadedRecords, replace: true);
    } else if (choice == _LoadSessionAction.append) {
      appState.importRecords(loadedRecords, replace: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final filteredHistory = state.filteredHistory;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
        color: Colors.grey.shade50,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Historial de Sesión',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                if (state.history.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      state.searchQuery.isNotEmpty
                          ? '${filteredHistory.length}/${state.history.length}'
                          : '${state.history.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar en historial...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: state.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        splashRadius: 16,
                        tooltip: 'Limpiar búsqueda',
                        onPressed: () {
                          _searchController.clear();
                          context.read<AppState>().setSearchQuery('');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              onChanged: (value) {
                context.read<AppState>().setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: state.history.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No hay registros en el historial',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : filteredHistory.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 36, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              Text(
                                'Sin resultados para\n"${state.searchQuery}"',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredHistory.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade200,
                        ),
                        itemBuilder: (context, index) {
                          final record = filteredHistory[index];
                          final isSelected = state.currentIdentity?.tramiteId ==
                                  record.identity.tramiteId &&
                              state.currentIdentity?.dni == record.identity.dni;

                          return ListTile(
                            selected: isSelected,
                            selectedTileColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.35),
                            dense: true,
                            title: Text(
                              'DNI: ${record.identity.dni}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${record.identity.apellido}, ${record.identity.nombre}\n${record.type == DniType.oldVersion ? "Viejo (PDF417)" : "Nuevo (QR)"}',
                            ),
                            isThreeLine: true,
                            onTap: () {
                              context.read<AppState>().loadRecordFromHistory(
                                record,
                              );
                            },
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AppState>().saveSession();
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar Sesión'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    _handleLoadSession(context);
                  },
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Cargar Sesión'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _LoadSessionAction { cancel, replace, append }


