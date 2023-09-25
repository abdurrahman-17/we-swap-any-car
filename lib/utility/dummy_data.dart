//Sample data
import 'package:intl/intl.dart';

import '../model/car_model/value_section_input.dart';
import '../model/history/history_model.dart';
import 'date_time_utils.dart';
import 'strings.dart';

var now = getCurrentDateTime();
var formatter = DateFormat('dd MMMM yyyy');
String carDate = formatter.format(now);

List<String> userTypesList = [
  'Trade',
  'Private',
  'Both',
];

List<ValuesSectionInput> testSelectableList = [
  ValuesSectionInput(
    id: "Test1",
    name: "Test 1",
  ),
  ValuesSectionInput(
    id: "Test2",
    name: "Test 2",
  ),
];

List<ValuesSectionInput> offersTypesSelctableList = [
  ValuesSectionInput(
    id: "0",
    name: allHistory,
  ),
  ValuesSectionInput(
    id: "1",
    name: swapHistory,
  ),
  ValuesSectionInput(
    id: "2",
    name: cashHistory,
  ),
  ValuesSectionInput(
    id: "3",
    name: swapPlusCashHistory,
  ),
];

List<ValuesSectionInput> priceRangeList = [
  ValuesSectionInput(
    id: "100-1000",
    name: priceRange0,
  ),
  ValuesSectionInput(
    id: "1000-10000",
    name: priceRange1,
  ),
  ValuesSectionInput(
    id: "10000-100000",
    name: priceRange2,
  ),
  ValuesSectionInput(
    id: "100000-1000000",
    name: priceRange3,
  ),
];
//History Dummy List
HistoryModel historyModelData = HistoryModel(data: [
  HistoryData(
    carName: "2023 Mercedes-Benz",
    carModel: "Q5",
    transactionMethod: "Swap",
    userName: "john",
    carPicture:
        "https://gumlet.assettype.com/evoindia%2F2023-04%2F27bc35e2-1c26-48fb-8bec-e4dc04d4e87f%2FIMG_5680.JPG?auto=format%2Ccompress&format=webp&w=400&dpr=2.6",
    carValue: "£50,000",
    traderName: "AllCarTraders",
    userPicture: "https://img.freepik.com/free-icon/user_318-159711.jpg",
  ),
  HistoryData(
    carName: "2022 Audi",
    carModel: "E-Class",
    transactionMethod: "Cash",
    userName: "john",
    carPicture:
        "https://stimg.cardekho.com/images/carexteriorimages/930x620/Audi/Q5/7890/1637668688255/front-left-side-47.jpg",
    carValue: "£44,060",
    traderName: "CarTrading",
    userPicture: "https://img.freepik.com/free-icon/user_318-159711.jpg",
  ),
  HistoryData(
    carName: "2023 BMW",
    carModel: "3 Series",
    transactionMethod: "Swap + Cash",
    userName: "john",
    carPicture:
        "https://gaadiwaadi.com/wp-content/uploads/2022/05/2023-BMW-3-Series-1-1280x640.jpg",
    carValue: "£58,925",
    traderName: "TradeCar",
    userPicture: "https://img.freepik.com/free-icon/user_318-159711.jpg",
  ),
]);
