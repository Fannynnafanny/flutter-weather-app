import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/weather_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _bloc = WeatherBloc;
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Widget buildInitialInput() {
    return Center(
      child: Text('Search for your location'),
    );
  }

  Widget buildLoading() {
    return Center(
      child: Text('Loading weather'),
    );
  }

  Widget buildColumnWithData(weather) {
    return Center(
      child: Text(
          'There is weather! Location: ${weather.location}, temperature: ${weather.temperature}, condition: ${weather.condition},'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Search'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BlocConsumer<WeatherBloc, WeatherState>(
                  listener: (context, state) {
                if (state is WeatherError) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              }, builder: (context, state) {
                if (state is WeatherInitial) {
                  return buildInitialInput();
                } else if (state is WeatherLoading) {
                  return buildLoading();
                } else if (state is WeatherLoaded) {
                  return buildColumnWithData(state.weather);
                } else {
                  // (state is WeatherError)
                  return buildInitialInput();
                }
              }),
              Text(
                'Here you can search:',
              ),
              TextField(
                controller: myController,
              ),
              FloatingActionButton(
                onPressed: () => _bloc.add(GetWeather(myController.text)),
                tooltip: 'Submit',
                child: Icon(Icons.search),
              ),
            ]),
      ),
    );
  }
}
