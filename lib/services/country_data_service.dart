import 'dart:convert';

class CountryDataService {
  static List<Map<String, dynamic>> _cachedCountries = [];
  static bool _isLoaded = false;

  static Future<List<Map<String, dynamic>>> getAllCountries() async {
    if (_isLoaded) {
      return _cachedCountries;
    }

    // Use only local data - no API calls
    _cachedCountries = _getLocalCountries();
    _isLoaded = true;
    
    return _cachedCountries;
  }

  static List<Map<String, dynamic>> _getLocalCountries() {
    return [
      {'name': 'Afghanistan', 'code': 'AF', 'flag': '🇦🇫', 'region': 'Asia', 'subregion': 'Southern Asia', 'capital': 'Kabul'},
      {'name': 'Albania', 'code': 'AL', 'flag': '🇦🇱', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Tirana'},
      {'name': 'Algeria', 'code': 'DZ', 'flag': '🇩🇿', 'region': 'Africa', 'subregion': 'Northern Africa', 'capital': 'Algiers'},
      {'name': 'Andorra', 'code': 'AD', 'flag': '🇦🇩', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Andorra la Vella'},
      {'name': 'Angola', 'code': 'AO', 'flag': '🇦🇴', 'region': 'Africa', 'subregion': 'Middle Africa', 'capital': 'Luanda'},
      {'name': 'Argentina', 'code': 'AR', 'flag': '🇦🇷', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Buenos Aires'},
      {'name': 'Armenia', 'code': 'AM', 'flag': '🇦🇲', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Yerevan'},
      {'name': 'Australia', 'code': 'AU', 'flag': '🇦🇺', 'region': 'Oceania', 'subregion': 'Australia and New Zealand', 'capital': 'Canberra'},
      {'name': 'Austria', 'code': 'AT', 'flag': '🇦🇹', 'region': 'Europe', 'subregion': 'Western Europe', 'capital': 'Vienna'},
      {'name': 'Azerbaijan', 'code': 'AZ', 'flag': '🇦🇿', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Baku'},
      {'name': 'Bahamas', 'code': 'BS', 'flag': '🇧🇸', 'region': 'Americas', 'subregion': 'Caribbean', 'capital': 'Nassau'},
      {'name': 'Bahrain', 'code': 'BH', 'flag': '🇧🇭', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Manama'},
      {'name': 'Bangladesh', 'code': 'BD', 'flag': '🇧🇩', 'region': 'Asia', 'subregion': 'Southern Asia', 'capital': 'Dhaka'},
      {'name': 'Barbados', 'code': 'BB', 'flag': '🇧🇧', 'region': 'Americas', 'subregion': 'Caribbean', 'capital': 'Bridgetown'},
      {'name': 'Belarus', 'code': 'BY', 'flag': '🇧🇾', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Minsk'},
      {'name': 'Belgium', 'code': 'BE', 'flag': '🇧🇪', 'region': 'Europe', 'subregion': 'Western Europe', 'capital': 'Brussels'},
      {'name': 'Belize', 'code': 'BZ', 'flag': '🇧🇿', 'region': 'Americas', 'subregion': 'Central America', 'capital': 'Belmopan'},
      {'name': 'Benin', 'code': 'BJ', 'flag': '🇧🇯', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Porto-Novo'},
      {'name': 'Bhutan', 'code': 'BT', 'flag': '🇧🇹', 'region': 'Asia', 'subregion': 'Southern Asia', 'capital': 'Thimphu'},
      {'name': 'Bolivia', 'code': 'BO', 'flag': '🇧🇴', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Sucre'},
      {'name': 'Bosnia and Herzegovina', 'code': 'BA', 'flag': '🇧🇦', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Sarajevo'},
      {'name': 'Botswana', 'code': 'BW', 'flag': '🇧🇼', 'region': 'Africa', 'subregion': 'Southern Africa', 'capital': 'Gaborone'},
      {'name': 'Brazil', 'code': 'BR', 'flag': '🇧🇷', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Brasília'},
      {'name': 'Brunei', 'code': 'BN', 'flag': '🇧🇳', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Bandar Seri Begawan'},
      {'name': 'Bulgaria', 'code': 'BG', 'flag': '🇧🇬', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Sofia'},
      {'name': 'Burkina Faso', 'code': 'BF', 'flag': '🇧🇫', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Ouagadougou'},
      {'name': 'Burundi', 'code': 'BI', 'flag': '🇧🇮', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Gitega'},
      {'name': 'Cambodia', 'code': 'KH', 'flag': '🇰🇭', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Phnom Penh'},
      {'name': 'Cameroon', 'code': 'CM', 'flag': '🇨🇲', 'region': 'Africa', 'subregion': 'Middle Africa', 'capital': 'Yaoundé'},
      {'name': 'Canada', 'code': 'CA', 'flag': '🇨🇦', 'region': 'Americas', 'subregion': 'North America', 'capital': 'Ottawa'},
      {'name': 'Cape Verde', 'code': 'CV', 'flag': '🇨🇻', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Praia'},
      {'name': 'Central African Republic', 'code': 'CF', 'flag': '🇨🇫', 'region': 'Africa', 'subregion': 'Middle Africa', 'capital': 'Bangui'},
      {'name': 'Chad', 'code': 'TD', 'flag': '🇹🇩', 'region': 'Africa', 'subregion': 'Middle Africa', 'capital': 'N\'Djamena'},
      {'name': 'Chile', 'code': 'CL', 'flag': '🇨🇱', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Santiago'},
      {'name': 'China', 'code': 'CN', 'flag': '🇨🇳', 'region': 'Asia', 'subregion': 'Eastern Asia', 'capital': 'Beijing'},
      {'name': 'Colombia', 'code': 'CO', 'flag': '🇨🇴', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Bogotá'},
      {'name': 'Comoros', 'code': 'KM', 'flag': '🇰🇲', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Moroni'},
      {'name': 'Congo', 'code': 'CG', 'flag': '🇨🇬', 'region': 'Africa', 'subregion': 'Middle Africa', 'capital': 'Brazzaville'},
      {'name': 'Costa Rica', 'code': 'CR', 'flag': '🇨🇷', 'region': 'Americas', 'subregion': 'Central America', 'capital': 'San José'},
      {'name': 'Croatia', 'code': 'HR', 'flag': '🇭🇷', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Zagreb'},
      {'name': 'Cuba', 'code': 'CU', 'flag': '🇨🇺', 'region': 'Americas', 'subregion': 'Caribbean', 'capital': 'Havana'},
      {'name': 'Cyprus', 'code': 'CY', 'flag': '🇨🇾', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Nicosia'},
      {'name': 'Czech Republic', 'code': 'CZ', 'flag': '🇨🇿', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Prague'},
      {'name': 'Denmark', 'code': 'DK', 'flag': '🇩🇰', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'Copenhagen'},
      {'name': 'Djibouti', 'code': 'DJ', 'flag': '🇩🇯', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Djibouti City'},
      {'name': 'Dominican Republic', 'code': 'DO', 'flag': '🇩🇴', 'region': 'Americas', 'subregion': 'Caribbean', 'capital': 'Santo Domingo'},
      {'name': 'Ecuador', 'code': 'EC', 'flag': '🇪🇨', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Quito'},
      {'name': 'Egypt', 'code': 'EG', 'flag': '🇪🇬', 'region': 'Africa', 'subregion': 'Northern Africa', 'capital': 'Cairo'},
      {'name': 'El Salvador', 'code': 'SV', 'flag': '🇸🇻', 'region': 'Americas', 'subregion': 'Central America', 'capital': 'San Salvador'},
      {'name': 'Equatorial Guinea', 'code': 'GQ', 'flag': '🇬🇶', 'region': 'Africa', 'subregion': 'Middle Africa', 'capital': 'Malabo'},
      {'name': 'Eritrea', 'code': 'ER', 'flag': '🇪🇷', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Asmara'},
      {'name': 'Estonia', 'code': 'EE', 'flag': '🇪🇪', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'Tallinn'},
      {'name': 'Eswatini', 'code': 'SZ', 'flag': '🇸🇿', 'region': 'Africa', 'subregion': 'Southern Africa', 'capital': 'Mbabane'},
      {'name': 'Ethiopia', 'code': 'ET', 'flag': '🇪🇹', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Addis Ababa'},
      {'name': 'Fiji', 'code': 'FJ', 'flag': '🇫🇯', 'region': 'Oceania', 'subregion': 'Melanesia', 'capital': 'Suva'},
      {'name': 'Finland', 'code': 'FI', 'flag': '🇫🇮', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'Helsinki'},
      {'name': 'France', 'code': 'FR', 'flag': '🇫🇷', 'region': 'Europe', 'subregion': 'Western Europe', 'capital': 'Paris'},
      {'name': 'Gabon', 'code': 'GA', 'flag': '🇬🇦', 'region': 'Africa', 'subregion': 'Middle Africa', 'capital': 'Libreville'},
      {'name': 'Gambia', 'code': 'GM', 'flag': '🇬🇲', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Banjul'},
      {'name': 'Georgia', 'code': 'GE', 'flag': '🇬🇪', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Tbilisi'},
      {'name': 'Germany', 'code': 'DE', 'flag': '🇩🇪', 'region': 'Europe', 'subregion': 'Western Europe', 'capital': 'Berlin'},
      {'name': 'Ghana', 'code': 'GH', 'flag': '🇬🇭', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Accra'},
      {'name': 'Greece', 'code': 'GR', 'flag': '🇬🇷', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Athens'},
      {'name': 'Guatemala', 'code': 'GT', 'flag': '🇬🇹', 'region': 'Americas', 'subregion': 'Central America', 'capital': 'Guatemala City'},
      {'name': 'Guinea', 'code': 'GN', 'flag': '🇬🇳', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Conakry'},
      {'name': 'Guinea-Bissau', 'code': 'GW', 'flag': '🇬🇼', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Bissau'},
      {'name': 'Guyana', 'code': 'GY', 'flag': '🇬🇾', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Georgetown'},
      {'name': 'Haiti', 'code': 'HT', 'flag': '🇭🇹', 'region': 'Americas', 'subregion': 'Caribbean', 'capital': 'Port-au-Prince'},
      {'name': 'Honduras', 'code': 'HN', 'flag': '🇭🇳', 'region': 'Americas', 'subregion': 'Central America', 'capital': 'Tegucigalpa'},
      {'name': 'Hong Kong', 'code': 'HK', 'flag': '🇭🇰', 'region': 'Asia', 'subregion': 'Eastern Asia', 'capital': 'City of Victoria'},
      {'name': 'Hungary', 'code': 'HU', 'flag': '🇭🇺', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Budapest'},
      {'name': 'Iceland', 'code': 'IS', 'flag': '🇮🇸', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'Reykjavik'},
      {'name': 'India', 'code': 'IN', 'flag': '🇮🇳', 'region': 'Asia', 'subregion': 'Southern Asia', 'capital': 'New Delhi'},
      {'name': 'Indonesia', 'code': 'ID', 'flag': '🇮🇩', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Jakarta'},
      {'name': 'Iran', 'code': 'IR', 'flag': '🇮🇷', 'region': 'Asia', 'subregion': 'Southern Asia', 'capital': 'Tehran'},
      {'name': 'Iraq', 'code': 'IQ', 'flag': '🇮🇶', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Baghdad'},
      {'name': 'Ireland', 'code': 'IE', 'flag': '🇮🇪', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'Dublin'},
      {'name': 'Israel', 'code': 'IL', 'flag': '🇮🇱', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Jerusalem'},
      {'name': 'Italy', 'code': 'IT', 'flag': '🇮🇹', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Rome'},
      {'name': 'Jamaica', 'code': 'JM', 'flag': '🇯🇲', 'region': 'Americas', 'subregion': 'Caribbean', 'capital': 'Kingston'},
      {'name': 'Japan', 'code': 'JP', 'flag': '🇯🇵', 'region': 'Asia', 'subregion': 'Eastern Asia', 'capital': 'Tokyo'},
      {'name': 'Jordan', 'code': 'JO', 'flag': '🇯🇴', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Amman'},
      {'name': 'Kazakhstan', 'code': 'KZ', 'flag': '🇰🇿', 'region': 'Asia', 'subregion': 'Central Asia', 'capital': 'Nur-Sultan'},
      {'name': 'Kenya', 'code': 'KE', 'flag': '🇰🇪', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Nairobi'},
      {'name': 'Kuwait', 'code': 'KW', 'flag': '🇰🇼', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Kuwait City'},
      {'name': 'Kyrgyzstan', 'code': 'KG', 'flag': '🇰🇬', 'region': 'Asia', 'subregion': 'Central Asia', 'capital': 'Bishkek'},
      {'name': 'Laos', 'code': 'LA', 'flag': '🇱🇦', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Vientiane'},
      {'name': 'Latvia', 'code': 'LV', 'flag': '🇱🇻', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'Riga'},
      {'name': 'Lebanon', 'code': 'LB', 'flag': '🇱🇧', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Beirut'},
      {'name': 'Lesotho', 'code': 'LS', 'flag': '🇱🇸', 'region': 'Africa', 'subregion': 'Southern Africa', 'capital': 'Maseru'},
      {'name': 'Liberia', 'code': 'LR', 'flag': '🇱🇷', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Monrovia'},
      {'name': 'Libya', 'code': 'LY', 'flag': '🇱🇾', 'region': 'Africa', 'subregion': 'Northern Africa', 'capital': 'Tripoli'},
      {'name': 'Lithuania', 'code': 'LT', 'flag': '🇱🇹', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'Vilnius'},
      {'name': 'Luxembourg', 'code': 'LU', 'flag': '🇱🇺', 'region': 'Europe', 'subregion': 'Western Europe', 'capital': 'Luxembourg City'},
      {'name': 'Madagascar', 'code': 'MG', 'flag': '🇲🇬', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Antananarivo'},
      {'name': 'Malawi', 'code': 'MW', 'flag': '🇲🇼', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Lilongwe'},
      {'name': 'Malaysia', 'code': 'MY', 'flag': '🇲🇾', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Kuala Lumpur'},
      {'name': 'Maldives', 'code': 'MV', 'flag': '🇲🇻', 'region': 'Asia', 'subregion': 'Southern Asia', 'capital': 'Malé'},
      {'name': 'Mali', 'code': 'ML', 'flag': '🇲🇱', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Bamako'},
      {'name': 'Malta', 'code': 'MT', 'flag': '🇲🇹', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Valletta'},
      {'name': 'Mauritania', 'code': 'MR', 'flag': '🇲🇷', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Nouakchott'},
      {'name': 'Mauritius', 'code': 'MU', 'flag': '🇲🇺', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Port Louis'},
      {'name': 'Mexico', 'code': 'MX', 'flag': '🇲🇽', 'region': 'Americas', 'subregion': 'North America', 'capital': 'Mexico City'},
      {'name': 'Moldova', 'code': 'MD', 'flag': '🇲🇩', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Chișinău'},
      {'name': 'Monaco', 'code': 'MC', 'flag': '🇲🇨', 'region': 'Europe', 'subregion': 'Western Europe', 'capital': 'Monaco'},
      {'name': 'Mongolia', 'code': 'MN', 'flag': '🇲🇳', 'region': 'Asia', 'subregion': 'Eastern Asia', 'capital': 'Ulaanbaatar'},
      {'name': 'Montenegro', 'code': 'ME', 'flag': '🇲🇪', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Podgorica'},
      {'name': 'Morocco', 'code': 'MA', 'flag': '🇲🇦', 'region': 'Africa', 'subregion': 'Northern Africa', 'capital': 'Rabat'},
      {'name': 'Mozambique', 'code': 'MZ', 'flag': '🇲🇿', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Maputo'},
      {'name': 'Myanmar', 'code': 'MM', 'flag': '🇲🇲', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Naypyidaw'},
      {'name': 'Namibia', 'code': 'NA', 'flag': '🇳🇦', 'region': 'Africa', 'subregion': 'Southern Africa', 'capital': 'Windhoek'},
      {'name': 'Nepal', 'code': 'NP', 'flag': '🇳🇵', 'region': 'Asia', 'subregion': 'Southern Asia', 'capital': 'Kathmandu'},
      {'name': 'Netherlands', 'code': 'NL', 'flag': '🇳🇱', 'region': 'Europe', 'subregion': 'Western Europe', 'capital': 'Amsterdam'},
      {'name': 'New Zealand', 'code': 'NZ', 'flag': '🇳🇿', 'region': 'Oceania', 'subregion': 'Australia and New Zealand', 'capital': 'Wellington'},
      {'name': 'Nicaragua', 'code': 'NI', 'flag': '🇳🇮', 'region': 'Americas', 'subregion': 'Central America', 'capital': 'Managua'},
      {'name': 'Niger', 'code': 'NE', 'flag': '🇳🇪', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Niamey'},
      {'name': 'Nigeria', 'code': 'NG', 'flag': '🇳🇬', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Abuja'},
      {'name': 'North Korea', 'code': 'KP', 'flag': '🇰🇵', 'region': 'Asia', 'subregion': 'Eastern Asia', 'capital': 'Pyongyang'},
      {'name': 'North Macedonia', 'code': 'MK', 'flag': '🇲🇰', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Skopje'},
      {'name': 'Norway', 'code': 'NO', 'flag': '🇳🇴', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'Oslo'},
      {'name': 'Oman', 'code': 'OM', 'flag': '🇴🇲', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Muscat'},
      {'name': 'Pakistan', 'code': 'PK', 'flag': '🇵🇰', 'region': 'Asia', 'subregion': 'Southern Asia', 'capital': 'Islamabad'},
      {'name': 'Panama', 'code': 'PA', 'flag': '🇵🇦', 'region': 'Americas', 'subregion': 'Central America', 'capital': 'Panama City'},
      {'name': 'Papua New Guinea', 'code': 'PG', 'flag': '🇵🇬', 'region': 'Oceania', 'subregion': 'Melanesia', 'capital': 'Port Moresby'},
      {'name': 'Paraguay', 'code': 'PY', 'flag': '🇵🇾', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Asunción'},
      {'name': 'Peru', 'code': 'PE', 'flag': '🇵🇪', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Lima'},
      {'name': 'Philippines', 'code': 'PH', 'flag': '🇵🇭', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Manila'},
      {'name': 'Poland', 'code': 'PL', 'flag': '🇵🇱', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Warsaw'},
      {'name': 'Portugal', 'code': 'PT', 'flag': '🇵🇹', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Lisbon'},
      {'name': 'Qatar', 'code': 'QA', 'flag': '🇶🇦', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Doha'},
      {'name': 'Romania', 'code': 'RO', 'flag': '🇷🇴', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Bucharest'},
      {'name': 'Russia', 'code': 'RU', 'flag': '🇷🇺', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Moscow'},
      {'name': 'Rwanda', 'code': 'RW', 'flag': '🇷🇼', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Kigali'},
      {'name': 'Saudi Arabia', 'code': 'SA', 'flag': '🇸🇦', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Riyadh'},
      {'name': 'Senegal', 'code': 'SN', 'flag': '🇸🇳', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Dakar'},
      {'name': 'Serbia', 'code': 'RS', 'flag': '🇷🇸', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Belgrade'},
      {'name': 'Seychelles', 'code': 'SC', 'flag': '🇸🇨', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Victoria'},
      {'name': 'Sierra Leone', 'code': 'SL', 'flag': '🇸🇱', 'region': 'Africa', 'subregion': 'Western Africa', 'capital': 'Freetown'},
      {'name': 'Singapore', 'code': 'SG', 'flag': '🇸🇬', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Singapore'},
      {'name': 'Slovakia', 'code': 'SK', 'flag': '🇸🇰', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Bratislava'},
      {'name': 'Slovenia', 'code': 'SI', 'flag': '🇸🇮', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Ljubljana'},
      {'name': 'Somalia', 'code': 'SO', 'flag': '🇸🇴', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Mogadishu'},
      {'name': 'South Africa', 'code': 'ZA', 'flag': '🇿🇦', 'region': 'Africa', 'subregion': 'Southern Africa', 'capital': 'Pretoria'},
      {'name': 'South Korea', 'code': 'KR', 'flag': '🇰🇷', 'region': 'Asia', 'subregion': 'Eastern Asia', 'capital': 'Seoul'},
      {'name': 'South Sudan', 'code': 'SS', 'flag': '🇸🇸', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Juba'},
      {'name': 'Spain', 'code': 'ES', 'flag': '🇪🇸', 'region': 'Europe', 'subregion': 'Southern Europe', 'capital': 'Madrid'},
      {'name': 'Sri Lanka', 'code': 'LK', 'flag': '🇱🇰', 'region': 'Asia', 'subregion': 'Southern Asia', 'capital': 'Sri Jayawardenepura Kotte'},
      {'name': 'Sudan', 'code': 'SD', 'flag': '🇸🇩', 'region': 'Africa', 'subregion': 'Northern Africa', 'capital': 'Khartoum'},
      {'name': 'Sweden', 'code': 'SE', 'flag': '🇸🇪', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'Stockholm'},
      {'name': 'Switzerland', 'code': 'CH', 'flag': '🇨🇭', 'region': 'Europe', 'subregion': 'Western Europe', 'capital': 'Bern'},
      {'name': 'Syria', 'code': 'SY', 'flag': '🇸🇾', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Damascus'},
      {'name': 'Taiwan', 'code': 'TW', 'flag': '🇹🇼', 'region': 'Asia', 'subregion': 'Eastern Asia', 'capital': 'Taipei'},
      {'name': 'Tajikistan', 'code': 'TJ', 'flag': '🇹🇯', 'region': 'Asia', 'subregion': 'Central Asia', 'capital': 'Dushanbe'},
      {'name': 'Tanzania', 'code': 'TZ', 'flag': '🇹🇿', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Dodoma'},
      {'name': 'Thailand', 'code': 'TH', 'flag': '🇹🇭', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Bangkok'},
      {'name': 'Tunisia', 'code': 'TN', 'flag': '🇹🇳', 'region': 'Africa', 'subregion': 'Northern Africa', 'capital': 'Tunis'},
      {'name': 'Turkey', 'code': 'TR', 'flag': '🇹🇷', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Ankara'},
      {'name': 'Turkmenistan', 'code': 'TM', 'flag': '🇹🇲', 'region': 'Asia', 'subregion': 'Central Asia', 'capital': 'Ashgabat'},
      {'name': 'Uganda', 'code': 'UG', 'flag': '🇺🇬', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Kampala'},
      {'name': 'Ukraine', 'code': 'UA', 'flag': '🇺🇦', 'region': 'Europe', 'subregion': 'Eastern Europe', 'capital': 'Kyiv'},
      {'name': 'United Arab Emirates', 'code': 'AE', 'flag': '🇦🇪', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Abu Dhabi'},
      {'name': 'United Kingdom', 'code': 'GB', 'flag': '🇬🇧', 'region': 'Europe', 'subregion': 'Northern Europe', 'capital': 'London'},
      {'name': 'United States', 'code': 'US', 'flag': '🇺🇸', 'region': 'Americas', 'subregion': 'North America', 'capital': 'Washington, D.C.'},
      {'name': 'Uruguay', 'code': 'UY', 'flag': '🇺🇾', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Montevideo'},
      {'name': 'Uzbekistan', 'code': 'UZ', 'flag': '🇺🇿', 'region': 'Asia', 'subregion': 'Central Asia', 'capital': 'Tashkent'},
      {'name': 'Venezuela', 'code': 'VE', 'flag': '🇻🇪', 'region': 'Americas', 'subregion': 'South America', 'capital': 'Caracas'},
      {'name': 'Vietnam', 'code': 'VN', 'flag': '🇻🇳', 'region': 'Asia', 'subregion': 'South-Eastern Asia', 'capital': 'Hanoi'},
      {'name': 'Yemen', 'code': 'YE', 'flag': '🇾🇪', 'region': 'Asia', 'subregion': 'Western Asia', 'capital': 'Sana\'a'},
      {'name': 'Zambia', 'code': 'ZM', 'flag': '🇿🇲', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Lusaka'},
      {'name': 'Zimbabwe', 'code': 'ZW', 'flag': '🇿🇼', 'region': 'Africa', 'subregion': 'Eastern Africa', 'capital': 'Harare'},
    ];
  }

  static Map<String, List<String>> getRegionCategories() {
    return {
      'Europe': ['Western Europe', 'Eastern Europe', 'Northern Europe', 'Southern Europe'],
      'Asia': ['Eastern Asia', 'Southern Asia', 'Southeast Asia', 'Central Asia', 'Western Asia'],
      'Americas': ['North America', 'South America', 'Central America', 'Caribbean'],
      'Africa': ['Northern Africa', 'Sub-Saharan Africa', 'Eastern Africa', 'Western Africa', 'Central Africa', 'Southern Africa'],
      'Oceania': ['Australia and New Zealand', 'Melanesia', 'Micronesia', 'Polynesia'],
    };
  }

  static String getRegionDisplayName(String region) {
    switch (region) {
      case 'Europe':
        return 'Europe';
      case 'Asia':
        return 'Asia';
      case 'Americas':
        return 'Americas';
      case 'Africa':
        return 'Africa';
      case 'Oceania':
        return 'Oceania';
      default:
        return region;
    }
  }

  // Dangerous countries with risk levels
  static Map<String, Map<String, dynamic>> getDangerousCountries() {
    return {
      'AF': {'name': 'Afghanistan', 'risk': 'extreme', 'flag': '🇦🇫', 'description': 'High security risk'},
      'SY': {'name': 'Syria', 'risk': 'extreme', 'flag': '🇸🇾', 'description': 'Active conflict zone'},
      'YE': {'name': 'Yemen', 'risk': 'extreme', 'flag': '🇾🇪', 'description': 'Civil war ongoing'},
      'IQ': {'name': 'Iraq', 'risk': 'high', 'flag': '🇮🇶', 'description': 'Security instability'},
      'PK': {'name': 'Pakistan', 'risk': 'high', 'flag': '🇵🇰', 'description': 'Terrorism concerns'},
      'SO': {'name': 'Somalia', 'risk': 'extreme', 'flag': '🇸🇴', 'description': 'Piracy and instability'},
      'SD': {'name': 'Sudan', 'risk': 'high', 'flag': '🇸🇩', 'description': 'Civil unrest'},
      'SS': {'name': 'South Sudan', 'risk': 'high', 'flag': '🇸🇸', 'description': 'Ongoing conflict'},
      'CF': {'name': 'Central African Republic', 'risk': 'high', 'flag': '🇨🇫', 'description': 'Civil war'},
      'ML': {'name': 'Mali', 'risk': 'high', 'flag': '🇲🇱', 'description': 'Terrorism and instability'},
      'NG': {'name': 'Nigeria', 'risk': 'medium', 'flag': '🇳🇬', 'description': 'Boko Haram activity'},
      'VE': {'name': 'Venezuela', 'risk': 'medium', 'flag': '🇻🇪', 'description': 'Economic crisis'},
      'HT': {'name': 'Haiti', 'risk': 'medium', 'flag': '🇭🇹', 'description': 'Political instability'},
      'HN': {'name': 'Honduras', 'risk': 'medium', 'flag': '🇭🇳', 'description': 'High crime rates'},
      'SV': {'name': 'El Salvador', 'risk': 'medium', 'flag': '🇸🇻', 'description': 'Gang violence'},
      'GT': {'name': 'Guatemala', 'risk': 'medium', 'flag': '🇬🇹', 'description': 'High crime rates'},
      'MX': {'name': 'Mexico', 'risk': 'medium', 'flag': '🇲🇽', 'description': 'Drug cartel violence'},
    };
  }

  static String getRiskLevelColor(String risk) {
    switch (risk) {
      case 'extreme':
        return '#FF0000'; // Red
      case 'high':
        return '#FF6600'; // Orange
      case 'medium':
        return '#FFCC00'; // Yellow
      case 'low':
        return '#99CC00'; // Light green
      default:
        return '#666666'; // Gray
    }
  }

  static String getRiskLevelEmoji(String risk) {
    switch (risk) {
      case 'extreme':
        return '☠️';
      case 'high':
        return '⚠️';
      case 'medium':
        return '⚡';
      case 'low':
        return '🔶';
      default:
        return '❓';
    }
  }
} 