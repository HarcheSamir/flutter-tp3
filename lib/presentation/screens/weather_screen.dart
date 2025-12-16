import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with SingleTickerProviderStateMixin {
  final WeatherRepository _repository = WeatherRepository();
  final TextEditingController _cityController = TextEditingController();
  
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    // FIX: Wait for the frame to build before using context/fetching data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeather("Montpellier");
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _fetchWeather(String city) async {
    if (city.isEmpty) return;
    
    // This line caused the crash in initState, but now it's safe because of addPostFrameCallback
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    _animController.reset();

    try {
      final result = await _repository.getWeather(city);
      setState(() {
        _weather = result;
        _isLoading = false;
      });
      _animController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll("Exception: ", "");
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6B4FF8), Color(0xFF262628)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : _errorMessage != null
                        ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.white, fontSize: 18)))
                        : _weather != null
                            ? _buildWeatherContent()
                            : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: _cityController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          hintText: "Entrez une ville (ex: Paris)",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () => _fetchWeather(_cityController.text),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) => _fetchWeather(value),
      ),
    );
  }

  Widget _buildWeatherContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            _weather!.cityName,
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            DateFormat.yMMMMEEEEd('fr').format(_weather!.date),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          
          const SizedBox(height: 30),

          Image.network(
            "https://openweathermap.org/img/wn/${_weather!.iconCode}@4x.png",
            width: 180,
            height: 180,
          ),
          Text(
            "${_weather!.temperature.round()}°",
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w200, color: Colors.white),
          ),
          Text(
            _weather!.description.toUpperCase(),
            style: const TextStyle(fontSize: 20, color: Colors.white70, letterSpacing: 1.2),
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDetailItem(FontAwesomeIcons.wind, "${_weather!.windSpeed} km/h", "Vent"),
              _buildDetailItem(FontAwesomeIcons.droplet, "${_weather!.humidity} %", "Humidité"),
            ],
          ),

          const Spacer(),

          Container(
            height: 180,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 10),
                  child: Text("Prévisions 5 Jours", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _weather!.forecast.length,
                    itemBuilder: (context, index) {
                      final day = _weather!.forecast[index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.E('fr').format(day.date), 
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                            Image.network(
                              "https://openweathermap.org/img/wn/${day.iconCode}.png",
                              width: 50,
                            ),
                            Text(
                              "${day.temperature.round()}°",
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}