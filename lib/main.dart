import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoctorApp - Salud Digital Accessible',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variables para almacenar los datos del registro
  String _registeredEmail = '';
  String _registeredPassword = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DoctorApp - Salud Digital Accessible'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Registro'),
            Tab(text: 'Login'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRegisterForm(),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Registro',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _register,
            child: Text('Registrarse'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Login',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: TextEditingController(
                text: _registeredEmail), // Muestra el email registrado
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: TextEditingController(
                text: _registeredPassword), // Muestra la contraseña registrada
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            child: Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }

  void _register() {
    // Guardar los datos ingresados en el registro
    setState(() {
      _registeredEmail = _emailController.text;
      _registeredPassword = _passwordController.text;
    });

    // Lógica de registro (puedes integrar Supabase o Firebase aquí)
    print('Registrando usuario: $_registeredEmail');

    // Vaciar los campos de texto después del registro
    _emailController.clear();
    _passwordController.clear();

    // Redirigir al apartado de Login
    _tabController.animateTo(1); // Cambia a la pestaña de Login
  }

  void _login() {
    // Lógica de inicio de sesión (puedes integrar Supabase o Firebase aquí)
    print('Iniciando sesión: $_registeredEmail');

    // Redirigir a la pantalla principal después del inicio de sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DoctorApp - Salud Digital Accessible'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de Consultas Virtuales
            Text(
              'Consultas Virtuales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                const url =
                    'https://us05web.zoom.us/j/82789212171?pwd=m4wKaRwRNbVv3RwERha5wuFaZRqXw1.1';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'No se pudo abrir $url';
                }
              },
              child: Text('Iniciar Videollamada con el Doctor'),
            ),
            SizedBox(height: 40),

            // Sección de Chatbot IA
            Text(
              'Chat',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ChatBotScreen(),
            ),
            SizedBox(height: 20),

            // Botón de Cerrar Sesión
            ElevatedButton(
              onPressed: () {
                // Lógica para cerrar sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  bool _showDiseaseSelection = false;
  bool _isChatClosed = false;

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && !_isChatClosed) {
      setState(() {
        _messages.add('Tú: ${_messageController.text}');
        _messageController.clear();

        if (!_showDiseaseSelection) {
          _messages.add('Chat: Hola, ¿en qué puedo ayudarte?');
          _showDiseaseSelection = true; // Mostrar la selección de enfermedades
        }
      });
    }
  }

  void _selectDisease(String disease) {
    setState(() {
      _messages.add('Chat: Has seleccionado $disease.');
      if (disease == 'Gripe') {
        _messages.add(
            'Chat: Para la gripe, se recomienda descansar, beber muchos líquidos como caldos y tomar medicamentos como paracetamol para reducir la gripe.');
      } else if (disease == 'Tos') {
        _messages.add(
            'Chat: Para la tos, se recomienda beber té con miel, mantener la garganta hidratada y evitar irritantes como el humo.');
      } else if (disease == 'Fiebre') {
        _messages.add(
            'Chat: Para la fiebre, se recomienda descansar, hacer gargaras con agua tibia y sal que alivian la inflamación, también beber muchos líquidos como caldos y tomar medicamentos como paracetamol para reducir el dolor de garganta.');
      } else if (disease == 'Dolor de garganta') {
        _messages.add(
            'Chat: Para el dolor de garganta, se recomienda beber té, hacer gárgaras con agua tibia y sal que alivian la inflamación, tomar pastillas con lidocaína o mentol y tomar té de jengibre que ayuda a calmar la irritación.');
      } else if (disease == 'Dolor de cabeza') {
        _messages.add(
            'Chat: Para el dolor de cabeza, se recomienda tomar antihistamínicos para reducir el dolor, estar en un lugar oscuro y tranquilo y también usar toallas frías que pueden ayudar a aliviar el dolor de cabeza.');
      }
      _messages
          .add('Chat: Espero haberte ayudado con tu malestar o inquietud.');
      _isChatClosed = true; // Cerrar el chat después de la selección
    });
  }

  void _resetChat() {
    setState(() {
      _messages.clear(); // Vaciar la lista de mensajes
      _showDiseaseSelection =
          true; // Mostrar directamente las opciones de selección
      _isChatClosed = false; // Restablecer el estado del chat
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_messages[index]));
              },
            ),
          ),
          Divider(),
          if (_showDiseaseSelection && !_isChatClosed)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Selecciona una enfermedad que estés presentando:'),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      ElevatedButton(
                        onPressed: () => _selectDisease('Gripe'),
                        child: Text('Gripe'),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDisease('Tos'),
                        child: Text('Tos'),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDisease('Fiebre'),
                        child: Text('Fiebre'),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDisease('Dolor de garganta'),
                        child: Text('Dolor de garganta'),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDisease('Dolor de cabeza'),
                        child: Text('Dolor de cabeza'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu consulta...',
                      border: InputBorder.none,
                    ),
                    enabled:
                        !_isChatClosed, // Deshabilitar el campo de texto si el chat está cerrado
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isChatClosed
                      ? null
                      : _sendMessage, // Deshabilitar el botón si el chat está cerrado
                ),
              ],
            ),
          ),
          // Botón para vaciar el chat
          if (_isChatClosed)
            ElevatedButton(
              onPressed: _resetChat,
              child: Text('Hacer otra pregunta'),
            ),
        ],
      ),
    );
  }
}
