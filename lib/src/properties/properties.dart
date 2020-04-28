import 'package:equatable/equatable.dart';
import 'package:quiver/check.dart';

class Properties extends Equatable {
  final Map<String, String> _properties;

  Properties(this._properties) {
    checkNotNull(_properties);
  }

  @override
  List<Object> get props => [_properties];

  @override
  bool get stringify => true;

  String operator [](String key) => _properties[key];

  String asString() {
    final propertiesList = [];
    _properties.forEach((key, value) {
      if (value != null) {
        propertiesList.add("$key=$value");
      }
    });
    return propertiesList.join("\n");
  }
}
