  class TemperatureModel {
    final String Day;
    final int index;
    final double temperature;
    final String time;

    TemperatureModel(
        {this.Day = '', this.index = 0, this.temperature = 0, this.time = ''});

    factory TemperatureModel.formJson(Map<dynamic, dynamic> json) {
      if (json == null) {
        return new TemperatureModel();
      }

      return TemperatureModel(
          Day: json['Day'],
          index: json['index'],
          temperature: json['temperature'].toDouble(),
          time: json['time']);
    }
  }
